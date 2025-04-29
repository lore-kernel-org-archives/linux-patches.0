Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106B71C6B4;
	Tue, 29 Apr 2025 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947094; cv=none; b=U4q6R0lOJgnwu8pFQ24KMSVWiE4breUxnAGPTh0iqkO3mblv/HMROm6DnPdLPmn8Iwd3kkoTDJ1vGSKlrju+GEFBYjmPUgbHNplnt7Bg3IfHQqlVF6xotSitTAAcYaNbF8/UP9YZ96oG+BZr6gUEq1wbacsxHAthuuAPcvWYVbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947094; c=relaxed/simple;
	bh=JHfm2tVv+NTcdggrzeAN8OYwuXqLR1KR8sinOWh+3TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbUcEOtA2iunhwRgfsO3G0JcfeSJnxpq+/EC3VTGZ5Ugb9+bTcvMA36L8XzCG9Qq7bYYxkiyLpbsLm2WjBAo2tN1bGtkbvQlPrNkgn/G0XRNNf6jIt9y6PnISctnGBH45yKyppfkS3QuFvNt2TnHI3o4hYC/kMhBxDAvtNRdzYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNq5rELn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNq5rELn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741CAC4CEE3;
	Tue, 29 Apr 2025 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947093;
	bh=JHfm2tVv+NTcdggrzeAN8OYwuXqLR1KR8sinOWh+3TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNq5rELnBf6cE0AYs9RCVJhq7VKitwntjEGjfl6lBbgdtlGypp/WnKHYz7EPHnD9R
	 ygL6sGzRZ6CuOiZsESPFpdL/0KLiVwBgiIZjS+NykIYwNOvehvIzYTZX2ZCsq8isRb
	 a/2hMFeU2sL/StZPEyP0YSbr6u64QT4EgSoMBf5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 162/286] smb: client: fix use-after-free bug in cifs_debug_data_proc_show()
Date: Tue, 29 Apr 2025 18:41:06 +0200
Message-ID: <20250429161114.549457542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit d328c09ee9f15ee5a26431f5aad7c9239fa85e62 upstream.

Skip SMB sessions that are being teared down
(e.g. @ses->ses_status == SES_EXITING) in cifs_debug_data_proc_show()
to avoid use-after-free in @ses.

This fixes the following GPF when reading from /proc/fs/cifs/DebugData
while mounting and umounting

  [ 816.251274] general protection fault, probably for non-canonical
  address 0x6b6b6b6b6b6b6d81: 0000 [#1] PREEMPT SMP NOPTI
  ...
  [  816.260138] Call Trace:
  [  816.260329]  <TASK>
  [  816.260499]  ? die_addr+0x36/0x90
  [  816.260762]  ? exc_general_protection+0x1b3/0x410
  [  816.261126]  ? asm_exc_general_protection+0x26/0x30
  [  816.261502]  ? cifs_debug_tcon+0xbd/0x240 [cifs]
  [  816.261878]  ? cifs_debug_tcon+0xab/0x240 [cifs]
  [  816.262249]  cifs_debug_data_proc_show+0x516/0xdb0 [cifs]
  [  816.262689]  ? seq_read_iter+0x379/0x470
  [  816.262995]  seq_read_iter+0x118/0x470
  [  816.263291]  proc_reg_read_iter+0x53/0x90
  [  816.263596]  ? srso_alias_return_thunk+0x5/0x7f
  [  816.263945]  vfs_read+0x201/0x350
  [  816.264211]  ksys_read+0x75/0x100
  [  816.264472]  do_syscall_64+0x3f/0x90
  [  816.264750]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
  [  816.265135] RIP: 0033:0x7fd5e669d381

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ This patch removed lock/unlock operation due to ses_lock is
not present in v5.10 and not ported yet. ses->status is protected
by a global lock, cifs_tcp_ses_lock, in v5.10. ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -358,6 +358,8 @@ skip_rdma:
 		list_for_each(tmp2, &server->smb_ses_list) {
 			ses = list_entry(tmp2, struct cifs_ses,
 					 smb_ses_list);
+			if (ses->status == CifsExiting)
+				continue;
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
 				(ses->serverNOS == NULL)) {


