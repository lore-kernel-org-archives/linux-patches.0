Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F91171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58716C433D2;
	Mon, 22 May 2023 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785181;
	bh=gtPX+gK8M/M6DY8uBxiQFtISdtUNTW7FhN6K02+LVOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGQuSwS38eOrieK17WAtaOGB6bOhl8WhGiGteGrC4LT9cKfp0UBPeWfuPsMRsOps5
	 E/lUJTi4/vcxE4fxIle2Ng3tSsuOvJuR/XmedybsIij18cRF5afpJ6Ehnt+mca9CtB
	 mWXLd/D4mA2GjBF5Q9VAlXbPLQ0PjYIzTO2wQvqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Schilder <frans@dtu.dk>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.3 336/364] ceph: force updating the msg pointer in non-split case
Date: Mon, 22 May 2023 20:10:41 +0100
Message-Id: <20230522190421.176657883@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit 4cafd0400bcb6187c0d4ab4d4b0229a89ac4f8c2 upstream.

When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
request may still contain a list of 'split_realms', and we need
to skip it anyway. Or it will be parsed as a corrupt snaptrace.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61200
Reported-by: Frank Schilder <frans@dtu.dk>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/snap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1111,6 +1111,19 @@ skip_inode:
 				continue;
 			adjust_snap_realm_parent(mdsc, child, realm->ino);
 		}
+	} else {
+		/*
+		 * In the non-split case both 'num_split_inos' and
+		 * 'num_split_realms' should be 0, making this a no-op.
+		 * However the MDS happens to populate 'split_realms' list
+		 * in one of the UPDATE op cases by mistake.
+		 *
+		 * Skip both lists just in case to ensure that 'p' is
+		 * positioned at the start of realm info, as expected by
+		 * ceph_update_snap_trace().
+		 */
+		p += sizeof(u64) * num_split_inos;
+		p += sizeof(u64) * num_split_realms;
 	}
 
 	/*


