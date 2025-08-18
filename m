Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42476335BCB;
	Mon, 18 Aug 2025 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524614; cv=none; b=G7Ao4I+KE7Iw/pW7IphoEaqhP1o6em0nfBlNjKp+iBgof+XXsM+uAH+FmxXsNm4UDvZTIb7Ks9B6gov/WvGN0ktVB9XyGLFBeZL1Zx+jEs9MuJuUGmyJ2bYHDkOJfQsg3UunX4viwLRI5qChahK5oHFHvvHXRS3C72mQBbIYHIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524614; c=relaxed/simple;
	bh=EeFrnRSoPreiKelVYWBOUhsVGjyKhyGCrPnWcl6YSlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTs31qDLHBlpzoI6FurwlI0tAse9JbC1LEZW+vPf1xupSP2g3TBk+NOsiHSl0y20fyNBi5GRn046gn57IoGq9zEhvHLHPLPXQ2IHXxvowR9U4LQT6JHycb3gRYxHHki/J5iSTcIOW+ppMwpHvq0AXyFKQ4q1Wk5S3U8pmEHT6ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFn3AyKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFn3AyKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF4FC4CEEB;
	Mon, 18 Aug 2025 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524613;
	bh=EeFrnRSoPreiKelVYWBOUhsVGjyKhyGCrPnWcl6YSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFn3AyKtBsawtn3ewlPXoqnZ2BVXvpdwiD7SHomuqf2bJeTiU/wPaIY83OAIL6L1x
	 7Zvj6hoOSKhko+0ujvk/l7u6CwRzdiYvxX+/YFFuDORHO5iD08phZ+S7J3ZHi4NxC2
	 SemzS6HkatDiLXJRrBJQ+9TYR3FVLyWbS0NcMXj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 010/570] smb3: fix for slab out of bounds on mount to ksmbd
Date: Mon, 18 Aug 2025 14:39:57 +0200
Message-ID: <20250818124506.181863696@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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


