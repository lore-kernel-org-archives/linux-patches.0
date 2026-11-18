Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035007;
	b=sU5WTGy4k9LTrrUMbfywKpTRfjCFv+oo5/NUwfuZHOfCdXuo+pFHasxxQft02sSOORIk
	 fgJLCAB9Zm/L3Lte5V8fs3TaCLR4wRcRz3ehRn4rWPuD1GEvv7r+vseIlFpwVt9pJ58lG
	 e5ZqVowZ4PkrCbCPNdGhXULXy6XHIZhHL49lwv0yGijEohggAMx1dyr/pToVwvzDM4RgG
	 LsTihhjAqtJdgv4qhCBCuV1p8cotU1aRZ0Hnj+ecSjuyqvBiWyBsY5inWg//cfs9J19G/
	 sa/r7hDztbd5C5tVFecjTGB0nz8GTFIOtI6uG4zg9FxiZJrLqFgIBSMwZOlizSbRWpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/jTlvnH+94zZgJHs+IAvsqfjGGPop2caBvrvSHaPbs=;
	b=OCASZofnIWYlAVLEHl3S5x2cyZHv6jn8ghwz3GakSmwbolibtXSkSF0DSlCstYpDBffX
	 hXeN7Cl1JSeLOpk2HXmq3sh0qVTfPb1qw/KYf+exP/yG1bpisil4tdhffWC8htzI3nwsm
	 iaJQhIoPV+6zT9KvQI6bzUxcWkZYsCHcqUKz0yNwgzvS+reSyBoq+ZNpsUug3y0ic979A
	 +7XfhENsfbUXI+kftzT+A/BjGaeqfv3RnfXHkZjwdaecIWCWlzZ7AEj0Khcnh5X/fOr/9
	 LUE13PBLJEWqta9z7QnuAotSKQkZhzSoT31wX96Uzzruvp5hm9xH+LekKF7VBnBK76Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIMj8wkD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E30C606A325;
	Wed, 18 Nov 2026 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIMj8wkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E3E1F000C4;
	Wed, 18 Nov 2026 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035007;
	bh=I/jTlvnH+94zZgJHs+IAvsqfjGGPop2caBvrvSHaPbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIMj8wkDq9ybyZjgYL2vUPuv2FdzUCkFONYC0ogfJUSRHuXTQlUgpdkwhKn64RWSs
	 gz4nTzr3RCt4n8J7DLZPw9Ph8fI5gNckM+xI/ojXzOlmDzMPaD53m6F25OO4U7yQNa
	 jv8M/TH/gWL34pkROwa/0CUImyZ/p4dbOCERd2xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0571/3318] ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()
Date: Wed, 18 Nov 2026 15:19:53 +0100
Message-ID: <20261118150334.570345010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


