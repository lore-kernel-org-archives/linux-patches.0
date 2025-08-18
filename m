Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C4B2C235F;
	Mon, 18 Aug 2025 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521481; cv=none; b=ESA/c+KNkwwwZB0Pz25soyt87jKDOqMsdBIPUeR8ZcsbMjOt5LmfMgfIKlN9b5dX4F74D09Iru92+yjoG0DQCVbUopBLEHGfBdsADQ/Sl43qFU7CxNQ+If32iZxeZ1QMjxbRsmxgt+kTxuZWJnRPq5kuTu9JHK6mMSG/JAbyUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521481; c=relaxed/simple;
	bh=7DVn8d19TtKcZivFXRucIZnr120dDj8t2SQ1Sr7IjAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmbS5K9/me5poJZCKiedOShH+OFxRlvOU0aAe8Yau/8jhZg5k8D8cyio5N8CPjAt6epu/FJ+AJBE4ky5OyFsd+jhbIvSh0A1znDX6veAeJiFwNPZmrRppWlVPCIGLl0crr0QJ0Vc42fyB2Bpe7iP53JEDCVmloVlTP10vdlBZJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uiJ6CTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uiJ6CTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D1CC4CEEB;
	Mon, 18 Aug 2025 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521481;
	bh=7DVn8d19TtKcZivFXRucIZnr120dDj8t2SQ1Sr7IjAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uiJ6CTsfZGNKQk7Z9DGA2eoGYpsbzetjrKb8i8h0dx84Pw3aTK6VCODDukI9lLmX
	 +6XbAYOnN44mE5b9gFH/ZVHBbMCE9KCDDNR4dYZwl7UHo96Zn9actB6zFMr5UBG2YU
	 ppM09r4y+AiNWpzDZh900XpTLRoHeS5VBqh+VqA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 006/444] smb3: fix for slab out of bounds on mount to ksmbd
Date: Mon, 18 Aug 2025 14:40:32 +0200
Message-ID: <20250818124449.138646950@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -772,6 +772,13 @@ next_iface:
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
@@ -783,7 +790,9 @@ next_iface:
 	}
 
 	/* Azure rounds the buffer size up 8, to a 16 byte boundary */
-	if ((bytes_left > 8) || p->Next)
+	if ((bytes_left > 8) ||
+	    (bytes_left >= offsetof(struct network_interface_info_ioctl_rsp, Next)
+	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
 	ses->iface_last_update = jiffies;


