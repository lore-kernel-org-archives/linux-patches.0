Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6D79D8;
	Sat, 30 Dec 2023 12:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2FtGz3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596C9C433C7;
	Sat, 30 Dec 2023 12:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937958;
	bh=uNWs5a0NcNvtoMfbLEhsWE3LXwZ41jj+OmVeXZ2jNYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2FtGz3oxW4s1Hi753ZLifmQUNhbGL7ZpkloOuZiDkqJAyBEkUI68YL4Ep5v87IhV
	 zAJzCGo+K+Nlk7XgyGx/ys21yCU/5P0mjDOqIfC3fteJ9d9v1tRoc5icIEzkmR+ylD
	 sAOYKV2xwi6PlwlRmC0Nx5GH7Lud/GNi9E6pEkKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 128/156] smb: client: fix OOB in smbCalcSize()
Date: Sat, 30 Dec 2023 11:59:42 +0000
Message-ID: <20231230115816.549764772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit b35858b3786ddbb56e1c35138ba25d6adf8d0bef upstream.

Validate @smb->WordCount to avoid reading off the end of @smb and thus
causing the following KASAN splat:

  BUG: KASAN: slab-out-of-bounds in smbCalcSize+0x32/0x40 [cifs]
  Read of size 2 at addr ffff88801c024ec5 by task cifsd/1328

  CPU: 1 PID: 1328 Comm: cifsd Not tainted 6.7.0-rc5 #9
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __phys_addr+0x46/0x90
   kasan_report+0xd8/0x110
   ? smbCalcSize+0x32/0x40 [cifs]
   ? smbCalcSize+0x32/0x40 [cifs]
   kasan_check_range+0x105/0x1b0
   smbCalcSize+0x32/0x40 [cifs]
   checkSMB+0x162/0x370 [cifs]
   ? __pfx_checkSMB+0x10/0x10 [cifs]
   cifs_handle_standard+0xbc/0x2f0 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_demultiplex_thread+0xed1/0x1360 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lockdep_hardirqs_on_prepare+0x136/0x210
   ? __pfx_lock_release+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? mark_held_locks+0x1a/0x90
   ? lockdep_hardirqs_on_prepare+0x136/0x210
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __kthread_parkme+0xce/0xf0
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0x18d/0x1d0
   ? kthread+0xdb/0x1d0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34/0x60
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1b/0x30
   </TASK>

This fixes CVE-2023-6606.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218218
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -363,6 +363,10 @@ checkSMB(char *buf, unsigned int total_r
 			cifs_dbg(VFS, "Length less than smb header size\n");
 		}
 		return -EIO;
+	} else if (total_read < sizeof(*smb) + 2 * smb->WordCount) {
+		cifs_dbg(VFS, "%s: can't read BCC due to invalid WordCount(%u)\n",
+			 __func__, smb->WordCount);
+		return -EIO;
 	}
 
 	/* otherwise, there is enough to get to the BCC */


