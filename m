Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D80F3451CD;
	Tue, 26 Aug 2025 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214108; cv=none; b=m3LYl9wCrQUQcFkyNIa792vZT3kq2IOOfJWTEFDuCDcNng6G17ikdOX8U+MzpLbyDkClEzqGUnGIlDgEWsrQWZpj+cpjf6lgC0wZ45FemQSGv5CXzURpnK4JvkGHYGqIbvcE2cPILwnRLSDRynRBcgi/pPscQhMiX78NM81V/7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214108; c=relaxed/simple;
	bh=nInMHi/lC4ixGPF0X7aVfHx4N6mfSOi3vpws9+kfWqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTsViH5qWe54AYTx3lUlfvZbeGGbeMNXG864TPMDHAaaogtb/RD9CipscuAr8lDaCdQl24Wm3AVzADQjZADjNCu0WZKpKL0o6yMWasJ26pi3FMHbu/dmAVcifI2rZUuekaPa3fHh1+KKHg7axpBb53W5qiY9snVOVOkZJTsVZ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nws9uCTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nws9uCTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8120CC4CEF1;
	Tue, 26 Aug 2025 13:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214107;
	bh=nInMHi/lC4ixGPF0X7aVfHx4N6mfSOi3vpws9+kfWqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nws9uCTvsL8kXEHp2xBPRJ97jO/eCycojX8x4dIxdqJ44BqjXIo+GZNC22rDjx/kV
	 zZkKH8jzVvxClB7kqfO3365CXFhiVpGlGXH//t873znbszbUpk6SdJ8o4nTt7jD7t4
	 auyg3NqEGYezd2lo8z/MU7nDqYx69tgEqU/sMDqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 006/482] smb3: fix for slab out of bounds on mount to ksmbd
Date: Tue, 26 Aug 2025 13:04:19 +0200
Message-ID: <20250826110930.937733893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 7d34ec36abb84fdfb6632a0f2cbda90379ae21fc upstream.

With KASAN enabled, it is possible to get a slab out of bounds
during mount to ksmbd due to missing check in parse_server_interfaces()
(see below):

 BUG: KASAN: slab-out-of-bounds in
 parse_server_interfaces+0x14ee/0x1880 [cifs]
 Read of size 4 at addr ffff8881433dba98 by task mount/9827

 CPU: 5 UID: 0 PID: 9827 Comm: mount Tainted: G
 OE       6.16.0-rc2-kasan #2 PREEMPT(voluntary)
 Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
 Hardware name: Dell Inc. Precision Tower 3620/0MWYPT,
 BIOS 2.13.1 06/14/2019
 Call Trace:
  <TASK>
 dump_stack_lvl+0x9f/0xf0
 print_report+0xd1/0x670
 __virt_addr_valid+0x22c/0x430
 ? parse_server_interfaces+0x14ee/0x1880 [cifs]
 ? kasan_complete_mode_report_info+0x2a/0x1f0
 ? parse_server_interfaces+0x14ee/0x1880 [cifs]
   kasan_report+0xd6/0x110
   parse_server_interfaces+0x14ee/0x1880 [cifs]
   __asan_report_load_n_noabort+0x13/0x20
   parse_server_interfaces+0x14ee/0x1880 [cifs]
 ? __pfx_parse_server_interfaces+0x10/0x10 [cifs]
 ? trace_hardirqs_on+0x51/0x60
 SMB3_request_interfaces+0x1ad/0x3f0 [cifs]
 ? __pfx_SMB3_request_interfaces+0x10/0x10 [cifs]
 ? SMB2_tcon+0x23c/0x15d0 [cifs]
 smb3_qfs_tcon+0x173/0x2b0 [cifs]
 ? __pfx_smb3_qfs_tcon+0x10/0x10 [cifs]
 ? cifs_get_tcon+0x105d/0x2120 [cifs]
 ? do_raw_spin_unlock+0x5d/0x200
 ? cifs_get_tcon+0x105d/0x2120 [cifs]
 ? __pfx_smb3_qfs_tcon+0x10/0x10 [cifs]
 cifs_mount_get_tcon+0x369/0xb90 [cifs]
 ? dfs_cache_find+0xe7/0x150 [cifs]
 dfs_mount_share+0x985/0x2970 [cifs]
 ? check_path.constprop.0+0x28/0x50
 ? save_trace+0x54/0x370
 ? __pfx_dfs_mount_share+0x10/0x10 [cifs]
 ? __lock_acquire+0xb82/0x2ba0
 ? __kasan_check_write+0x18/0x20
 cifs_mount+0xbc/0x9e0 [cifs]
 ? __pfx_cifs_mount+0x10/0x10 [cifs]
 ? do_raw_spin_unlock+0x5d/0x200
 ? cifs_setup_cifs_sb+0x29d/0x810 [cifs]
 cifs_smb3_do_mount+0x263/0x1990 [cifs]

Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -714,6 +714,13 @@ next_iface:
 			bytes_left -= sizeof(*p);
 			break;
 		}
+		/* Validate that Next doesn't point beyond the buffer */
+		if (next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
+				 __func__, next, bytes_left);
+			rc = -EINVAL;
+			goto out;
+		}
 		p = (struct network_interface_info_ioctl_rsp *)((u8 *)p+next);
 		bytes_left -= next;
 	}
@@ -725,7 +732,9 @@ next_iface:
 	}
 
 	/* Azure rounds the buffer size up 8, to a 16 byte boundary */
-	if ((bytes_left > 8) || p->Next)
+	if ((bytes_left > 8) ||
+	    (bytes_left >= offsetof(struct network_interface_info_ioctl_rsp, Next)
+	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
 


