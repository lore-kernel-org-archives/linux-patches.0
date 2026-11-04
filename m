Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826977;
	b=wX9FSDN2G3z+UoMH0HUufs92BELAYikRuPtZps0A0uZwccgXg58C/eOitMIamG1yMX7T
	 2woAZldnTyGMxW4d4IBweKb1uxz5tQ+GS2mEhc3X7gGpDHp6nWRxr7v1aneB/oexF6uXr
	 zfvw/wvLEg6lx4ZbFqGRqc8+4hL6yfgMxqFSq4zDr4YtOWYKkVttme6k3ha9ms6E8Qp5o
	 DzRH1FCRrGQZipIjAFCTMlHyMBGoWxP8tISvN36fcWFdqWhc2B3shL4NzPt57j4xeV5Mh
	 KR3W9dRbDp4barekjoSY5rkJXim6LRWxFBweEyrT+GCYltkvgkLeq+EtSzBrqLb5gUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJr6snIrDXdeBIr0cS1nafFlIMvG9/6ufFL8YjwMfac=;
	b=PQOUqSTslgmyUuqjdHLgpaqU63azJo8Hz5BrpsRjUy5K6hhrPTt8EhFUXGrffxRVWEYW
	 uD2VmpWq6rTqAo+Y+ybEiUefNt5lO/0qgXmLAgqRmT0bI5jgPa9PJd6JjdDJo7USoEE7X
	 mIwFpqDkIZCnUSeIqd5+NBaz3bPjscKfY9bsN6dS3K8jvOAFyKEC6GVvJu1++22fXld+K
	 aAOekUQCuLrul6A9boVpcFia5z5DxM2+vlQYQ5valxNcQqALLusp81P/627Uv8yCHSxm4
	 ui45FevP9/zDzKLfmLBicg/RAwGo/hDWzthTO5lTk6JYmtvjXY7Hf5oX/Xn4YuD3I3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAr4JXnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FDD607458C;
	Wed,  4 Nov 2026 21:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAr4JXnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECA1F000C1;
	Wed,  4 Nov 2026 21:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826977;
	bh=pJr6snIrDXdeBIr0cS1nafFlIMvG9/6ufFL8YjwMfac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAr4JXnQHOw1gqTL3ASE06ZEOI1b4CqZsOYZuYFti4UkJGIYZKTgDpos8lsULUYXd
	 4KpNsiNuMnHntQSAOUObR2BVFTlz3gttcyNqH5948C9U54sv4ctGhU/b5upk5ZveHZ
	 g79aN2BZcLgLj8GTHyb2As4PZMZYicnMJuOwNHq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 120/547] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Wed,  4 Nov 2026 16:05:04 -0500
Message-ID: <20261104211041.603671860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Kobakhia <gkobakhi@asu.edu>

commit eb96e2a0e817807c48dc8387ca6a5249fdeae3a0 upstream.

When the large dacl_offset is provided, dacl_offset + sizeof(struct
smb_acl) overflows on 32-bit builds and the check is passed,
Which makes le16_to_cpu(ppdacl_ptr->size) read out-of-bounds. This
only happens for dacl_offset in range [0xFFFFFFF8, 0xFFFFFFFF]. So
the oob read is max 8 bytes preceding the allocated ppntsd.

    unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
    int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;

    if (!dacl_offset ||
	(dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
	    goto out;

Commit beff0bc9d69b ("ksmbd: fix overflow in dacloffset bounds check")
fixes similar checks in other functions. But leaves this one out,
because it is only valid for 32-bit builds.

Reproduced on 32-bit ARM with KASAN, by a client sending SMB2
SET_INFO(SEC) with dacloffset=0xfffffff8, then QUERY_INFO(SEC) on the
same file:

 BUG: KASAN: slab-out-of-bounds in build_sec_desc (fs/smb/server/smbacl.c:1105)
 Read of size 2 at addr c2a273fa by task kworker/1:1/35
 CPU: 1 UID: 0 PID: 35 Comm: kworker/1:1 Not tainted 7.3.0-rc2+ #5
 Workqueue: ksmbd-io handle_ksmbd_work
 Call trace:
  kasan_check_range from build_sec_desc (fs/smb/server/smbacl.c:1105)
  build_sec_desc from smb2_query_info (fs/smb/server/smb2pdu.c:7676)
  smb2_query_info from handle_ksmbd_work (fs/smb/server/server.c:160)
  handle_ksmbd_work from process_one_work (kernel/workqueue.c:3401)
  process_one_work from worker_thread (kernel/workqueue.c:3473)
  worker_thread from kthread (kernel/kthread.c:436)

Add overflow check.

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Cc: stable@vger.kernel.org
Assisted-by: LLM claude
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1096,9 +1096,12 @@ int build_sec_desc(struct mnt_idmap *idm
 			struct smb_acl *ppdacl_ptr;
 			unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
 			int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;
+			size_t dacl_struct_end;
 
 			if (!dacl_offset ||
-			    (dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
+			    check_add_overflow(dacl_offset, sizeof(struct smb_acl),
+					       &dacl_struct_end) ||
+			    dacl_struct_end > (size_t)ppntsd_size)
 				goto out;
 
 			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd + dacl_offset);


