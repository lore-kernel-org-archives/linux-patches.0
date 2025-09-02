Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38DA30AAB4;
	Tue,  2 Sep 2025 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819725; cv=none; b=ErJhVhdKECzVYLBL3vidB3d4n3ZRVT7pY4CDyInpU/B7Bw0la7EVPG4oRKb9MV7JXMpXnXXkqm9Z3tM5kCvLMBioJppt+Kb3+Vf8IlLbjOL7FkS5Er0S9RjxkVHK0fu3i4ap7XuGut8NnqMJuSWt8e89ke835S2lZhklB+J+og8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819725; c=relaxed/simple;
	bh=c06sxzV+h1mhBHJ1vIgrioEKyd5H85LPMlQ1Pyv1VQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I190/ISdULbAZYQu+/MfTZ/zUq9lK2Mo2XJoddWErARuiz7r2v+Q31JxoTbLmXFljo/3ogA1JkCw5EB/F1L2OQpo4zBbwZdB7+/9lg8r/RCa7zSi+3SP8BSby4/zxgcWDDPapw0wb+LxVhxgYl9iFFsMmoDUPKxYueCHXvZtnig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6JNzA6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6JNzA6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D904C4CEED;
	Tue,  2 Sep 2025 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819725;
	bh=c06sxzV+h1mhBHJ1vIgrioEKyd5H85LPMlQ1Pyv1VQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6JNzA6xzRXcHkNWtKdbkTTrxaarS4sRFw8Kf2pX72ypyPST22KTD+/imML0gk/sg
	 Fjg5MF3vyYYG59Hym6wmUtb+ztljYyk6UC7fvZdUFP5bmfL6CeHIy5X4Y+yqIbsmpE
	 0pdgF3emHzFFQlXMEJpto/VWLXhDGu5gB6a53JEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 120/142] fs/smb: Fix inconsistent refcnt update
Date: Tue,  2 Sep 2025 15:20:22 +0200
Message-ID: <20250902131952.883469935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

commit ab529e6ca1f67bcf31f3ea80c72bffde2e9e053e upstream.

A possible inconsistent update of refcount was identified in `smb2_compound_op`.
Such inconsistent update could lead to possible resource leaks.

Why it is a possible bug:
1. In the comment section of the function, it clearly states that the
reference to `cfile` should be dropped after calling this function.
2. Every control flow path would check and drop the reference to
`cfile`, except the patched one.
3. Existing callers would not handle refcount update of `cfile` if
-ENOMEM is returned.

To fix the bug, an extra goto label "out" is added, to make sure that the
cleanup logic would always be respected. As the problem is caused by the
allocation failure of `vars`, the cleanup logic between label "finished"
and "out" can be safely ignored. According to the definition of function
`is_replayable_error`, the error code of "-ENOMEM" is not recoverable.
Therefore, the replay logic also gets ignored.

Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -207,8 +207,10 @@ replay_again:
 	server = cifs_pick_channel(ses);
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
-	if (vars == NULL)
-		return -ENOMEM;
+	if (vars == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	rqst = &vars->rqst[0];
 	rsp_iov = &vars->rsp_iov[0];
 
@@ -864,6 +866,7 @@ finished:
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
+out:
 	if (cfile)
 		cifsFileInfo_put(cfile);
 


