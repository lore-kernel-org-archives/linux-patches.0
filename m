Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211698;
	b=GnwJcHrE4Cf62zRZZ/KVwEZgmAv+NR0gyIVG3w9GFgTdiC5tVWlrCPMe92ecng6Cgx07
	 ZghQdzx6tKJCZJjWgelI5LpDQu6qGQ3UKFcFkz04jidv0aiW/64+oCDcA/pBTCbIn8ivE
	 /qhO2bMEs9c30pqN59daQ03N+oi18Qbnq1bUm3BbK/WaW6vKewjHpwirv/rL4HgG92KJF
	 5JD0rSfaf/jyvxXGDSxuXx2FALx1vRx9MCUD85snzv8iGiIoq32Gci/PRULQ4I2LOZ7b0
	 rBELa6AxoxJQxa2BDdepSvnzcnhbz94jY1LSnQ0yoOt7JMFoCHtPl9bbGpcxmiIjToA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8ra3ylsEmqvrt/6zSCz3CqJkR372VK9MzAcN/vf8z8=;
	b=YKpAjjR6HzWTFPKlNPJxWBYUWeOsglP67Suxyogdvyq09Br0/UFkgjGH/h5YhnJ3bziT
	 lni34Ckm1GnCToTRV/I8+kp+EHb7MQw0vJAHEY6x66zHFO9uk6zB8svIyfPT34U42tTaP
	 GCUuJFoZXHPyTN5+MHi4nYU+ixoecjdlpyBnTmfCYpjfwUElg6oLLOkPAPmCpF9+O2pRB
	 +00GSPmftTMZ/qXSdJRFCnz7SUrSsYmoCGOMTQFnJ7+ce5vC+VoH/9Dys+Lq4bPUjLsIT
	 Cvw5vxs80BHPr/oGHe9ux1D97QCzXqtEPRY+erBsbhw4qIwUvMmi4P8H1CKg35nkdOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nR3p+Jmu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53D9606A321;
	Wed, 28 Oct 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nR3p+Jmu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228551F01829;
	Wed, 28 Oct 2026 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211697;
	bh=G8ra3ylsEmqvrt/6zSCz3CqJkR372VK9MzAcN/vf8z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nR3p+JmuAAGY4etd/GjvW5+ufYBjXdU0D1De4qgdHzVH8w0m3BFsyzVaibTHcbyeN
	 X9wLbLmPWk6SrSLXDc3voYOtWh3KJb2FdB5Q8BlGkjpdXUaHkeshM7CqFvwpGZ+7t9
	 e6LmP2PzXsENZJe/H8FpMHx+ATQF2+QuS/CQdZqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/571] smb3: fix for slab out of bounds on mount to ksmbd
Date: Wed, 28 Oct 2026 17:59:20 +0100
Message-ID: <20261028170017.811746829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 7d34ec36abb84fdfb6632a0f2cbda90379ae21fc ]

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
(cherry picked from commit 7d34ec36abb84fdfb6632a0f2cbda90379ae21fc)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 88ae29c66becb..46f40bc3ef7ac 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -528,6 +528,13 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
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
@@ -539,7 +546,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	}
 
 	/* Azure rounds the buffer size up 8, to a 16 byte boundary */
-	if ((bytes_left > 8) || p->Next)
+	if ((bytes_left > 8) ||
+	    (bytes_left >= offsetof(struct network_interface_info_ioctl_rsp, Next)
+	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
 
-- 
2.53.0



