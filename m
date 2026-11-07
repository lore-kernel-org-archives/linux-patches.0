Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061539;
	b=sOSmC6jzA3aVfNCZixx2PLtJ41uWr+a7t6YUhhzwARPAP6MYkxLmXEPN/3L0VyICsl8a
	 V3lRNqw1O1BPrb6W7/RttshuyAL5X5UbdUgjOmAzbYCtoslILC73N4L8bbdxYnnN+qqbR
	 h+GhPuXZtag9fDqSM/qymk41yTLFBL4SDJP1f21aYUoIYeQ2siOJRsFN2Dflzt9+8QuMM
	 JZ8UurLWGwYj/qZM+NSkPvtyPFlOD62epNExqTteDuNOeXVfRyivlVPK2F2viVseUyJzx
	 5vGuojsVJzb2I+qeLe4DYnz5U2TZxidv5+vedjrVY1n0Sy40ikkjLrUcfI2IzAPdOIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cbq9kjUk3iIzO0jt9os6dp3KVdnXl2iBqkmZvQU/Aic=;
	b=3FF/phILijMdN8li3gHiezzwxT+vRuxRoKS56aPmjGHzUfWnrC+XJNqALXjeAvZmdElk
	 Car9lIZHE7ifE1eTWwEvd1ACSnKYypQ7cCgz6R+1De/V19lRe7eAPUHrKJQclTwwrfMKE
	 SK/+77ujKNFgtEHUtx7zNGhtZOgIeV8NogzhlXhOUTBVKcgqiY24EPQmm6QAt+QDqDIKo
	 RlS/j5emQK2d6YmI5lpn7yq/EubTPJlRX60aXultcqRkw//gQLYafVOoBsH601RrSHOVM
	 rF6wXJJstDk/M4LrYqJF7tBr5qo0r25oCJvjp+jgW+sekdFZGk/VEXxkjGX/NqLM3GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pD6crxfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7FA606A326;
	Sat,  7 Nov 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pD6crxfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A881F0089F;
	Sat,  7 Nov 2026 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061539;
	bh=cbq9kjUk3iIzO0jt9os6dp3KVdnXl2iBqkmZvQU/Aic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pD6crxfByDM7ZuxujICRjyroEU1XQvASIRqiMBMC5da3FEYWq//GNBGTC2l7JBbns
	 yyasL+g/9eljgAtkRf0Pb9/OVOBRBpAuPw+SE9NOyxyirWtld5NzmDhXJW3xKlQhZ8
	 xxAdNvJtYFG2rDwkCBbJIXXbFagXSf5uA2yre+2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0586/1536] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Sat,  7 Nov 2026 08:43:22 -0500
Message-ID: <20261107135013.998693045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1093,9 +1093,12 @@ int build_sec_desc(struct mnt_idmap *idm
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


