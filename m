Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022391;
	b=D8aqvxu/HtpdXYsJnp/K9XXWnvGMFWtCNQsJzWqwwxr7t0zyf/RN5qBDK3SOGNucdD+T
	 o+LsH3wpRpROGOVsOSyZDq2uujWxz2LtEMlZdP1/gxn0ObWVmJX/p26vu8s2iGLrKRshr
	 P1JD9LeK5+9kIZABrmstJsyjQRaJc16HkZS4sBrhvk4w902YY9icRzPqOfy634bUK61Vn
	 g3pkj4a5PAh+bYdJojkkce0TplRcZAubiO/BjA6HFh7rwbEIKD54Pa9szCdJys0UHJ1t4
	 bqnFQS5UcN/73CTTke9No/ig7yncgG5pNMJilR3DuLl21A06ICP8ROs5XuXMKJWOywA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t5WVX8j0eMrP1wrSmKoHuZPrwSVwtB2ZlepYZyKwgCM=;
	b=gNXaCAvVtzBv+yUfm0+CM7SGfz0QUQVwUMUNCjjvKNzd0hm0Cn7pwuAXhG7NNVW+43mV
	 vfpxoKblv4YDRy59w6As4N8tshD9+V7JAdWVHOpLAR8NiUPrbL+Nm13UEEpRShET/F9om
	 0bPG6M0eRyMXb/4ErY+V9aqVMtOkMBNmBXdoAX/2kFDUrV3O2W+9GRwi0o0xV99fmi3ex
	 HTkJuqSbY6jU95lAHVhhPe5QeY3tcz8QHWI/xPcIZIAPuxpIH/CsluUMqLZDEWhXlYYJb
	 VMkhRcjSIP0jrqT2EFU4UBEkhUxRTprISNjPe8QC66q8FpjJJ/JtTuSDQXMs7tyMAng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYZzyy7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D281F606A31C;
	Wed, 18 Nov 2026 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYZzyy7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC111F000C4;
	Wed, 18 Nov 2026 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022391;
	bh=t5WVX8j0eMrP1wrSmKoHuZPrwSVwtB2ZlepYZyKwgCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYZzyy7xjGTJ/naGyLr+LI/vpJO1jGf7oDaSAESiCWq4FAX+VFQmqzg/ubGECYfr/
	 Qh11ste0kp5KrkmcOBCATa6hanACPIf3lji/4vwi42N12Jc4k08pzC159dlsG+/aS9
	 JmJ4QPXNKRaQWO8fBWfR0rBUFyaFygh8x86/6Z2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 7.3 2645/2651] erofs: fix disallowing superblock_share if device= is set
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150419.306490046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

commit aafea970fb04633e22c7ad74cba4caf563c6d6a9 upstream.

superblock_share together with device= is rejected in
erofs_fc_fill_super():

	if (test_opt(&sbi->opt, SUPERBLOCK_SHARE) &&
	    sbi->devs->extra_devices)
		return -EINVAL;

but extra_devices is kept in sbi->devs, not in sbi->opt, and
erofs_sb_share_test_super() compares only the backing inode, the
fsoffset and sbi->opt.  So once the image is mounted with
superblock_share, a second mount with superblock_share,device= matches
that superblock and get_tree_super() reuses it without calling
fill_super() at all.

The same command line therefore either fails with -EINVAL or succeeds
with device= quietly dropped, depending on whether a compatible mount
already exists.

Refuse to match a context that brought device= options, so that it gets
a superblock of its own and fill_super() decides as it does today.

Only the incoming context can be tested: a shared superblock may have
extra_devices set itself, because erofs_scan_devices() fills the device
table from the image when no device= was given.

Fixes: cd4108319bb3 ("erofs: reuse superblock for file-backed mounts")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -827,7 +827,8 @@ static int erofs_sb_share_test_super(str
 		return 0;
 	return file_inode(sbi->dif0.file) == file_inode(new_sbi->dif0.file) &&
 	       sbi->dif0.fsoff == new_sbi->dif0.fsoff &&
-	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt));
+	       !memcmp(&sbi->opt, &new_sbi->opt, sizeof(sbi->opt)) &&
+	       !new_sbi->devs->extra_devices;
 }
 
 static int erofs_file_get_tree(struct fs_context *fc)


