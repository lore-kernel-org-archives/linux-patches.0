Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D789C46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE92C433F2;
	Mon, 16 Jan 2023 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886859;
	bh=ew3PR0avQ36xWuY3qsnGh/YZZmNtTnySiuGuTPhvjRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rii82bbyEurqn0gnIOv9m9yxxd/L7fGC+yzjrQCvw4Z/VBtsAxXbD3AVc0Cx5J5ct
	 NwixZjtcrajz9WQJXPCd1AZgK7ICBCSKUNT3kYY2GNM/LxMIOg2VE7OWjb/Uz96tn8
	 tOAsYb4bGfMqhkOA1RHhcqofh7W38Bwsxv43s5lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Dickson <steved@redhat.com>,
	JianHong Yin <yin-jianhong@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 590/658] nfsd: fix handling of readdir in v4root vs. mount upcall timeout
Date: Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154936.486893548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

commit cad853374d85fe678d721512cecfabd7636e51f3 upstream.

If v4 READDIR operation hits a mountpoint and gets back an error,
then it will include that entry in the reply and set RDATTR_ERROR for it
to the error.

That's fine for "normal" exported filesystems, but on the v4root, we
need to be more careful to only expose the existence of dentries that
lead to exports.

If the mountd upcall times out while checking to see whether a
mountpoint on the v4root is exported, then we have no recourse other
than to fail the whole operation.

Cc: Steve Dickson <steved@redhat.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216777
Reported-by: JianHong Yin <yin-jianhong@163.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3109,6 +3109,17 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	case nfserr_noent:
 		xdr_truncate_encode(xdr, start_offset);
 		goto skip_entry;
+	case nfserr_jukebox:
+		/*
+		 * The pseudoroot should only display dentries that lead to
+		 * exports. If we get EJUKEBOX here, then we can't tell whether
+		 * this entry should be included. Just fail the whole READDIR
+		 * with NFS4ERR_DELAY in that case, and hope that the situation
+		 * will resolve itself by the client's next attempt.
+		 */
+		if (cd->rd_fhp->fh_export->ex_flags & NFSEXP_V4ROOT)
+			goto fail;
+		fallthrough;
 	default:
 		/*
 		 * If the client requested the RDATTR_ERROR attribute,


