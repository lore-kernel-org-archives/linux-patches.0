Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8A171C9;
	Wed,  6 Nov 2024 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896250; cv=none; b=rx5wxNQVRStUGaCe/ZYAdaB9bki8xEIIdCvIYIwWKxob23f+4k8K3IsxdK5e1dqHrJMVwvle1gpY1Tniw03lI9ObSu6NCM6eqURRSi/hHNmEaeFL+Kj/K554sk3fe6hYjcT5rDgLUN/MLZcOVMsTysUyNz8pu3BofNwCMyPhhGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896250; c=relaxed/simple;
	bh=dxMYw/poP/TwVUCMsRwea+jLu/fgaP5h862LJokD8Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFw11bk/9LIe78pcx9FbKdwkfnE55IeI1Q5QVXBrBxiaolgNMdn0qiosaX7ipnyQAIDg7jKjmg0Qff+9U/Le8z5MyOXT1pmrrDlgpTDqch/en1r4EoKKhknWsSYGHk04AVtQD5V5x75zWdBrPy5WShLdZtwxePfZvc6sMzn0iiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAL1BbZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAL1BbZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB65AC4CECD;
	Wed,  6 Nov 2024 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896250;
	bh=dxMYw/poP/TwVUCMsRwea+jLu/fgaP5h862LJokD8Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAL1BbZkkz3j3xp0odB42cHaRsfB8piyR5twAxN/CV1MA36IrcX33WP2AqM1LLUKH
	 SWT9CIjenWgoD8u1GBS2241H9yvQ9O/hKtIh0b6VdyoKoB+HXVSPkkx4+8Kq0T/ANK
	 PlTkCOiFnhGvYp52Y5vIQw5EbbdXhrbAo+VRS+JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.11 140/245] thunderbolt: Fix KASAN reported stack out-of-bounds read in tb_retimer_scan()
Date: Wed,  6 Nov 2024 13:03:13 +0100
Message-ID: <20241106120322.676472353@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e9e1b20fae7de06ba36dd3f8dba858157bad233d upstream.

KASAN reported following issue:

 BUG: KASAN: stack-out-of-bounds in tb_retimer_scan+0xffe/0x1550 [thunderbolt]
 Read of size 4 at addr ffff88810111fc1c by task kworker/u56:0/11
 CPU: 0 UID: 0 PID: 11 Comm: kworker/u56:0 Tainted: G     U             6.11.0+ #1387
 Tainted: [U]=USER
 Workqueue: thunderbolt0 tb_handle_hotplug [thunderbolt]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x6c/0x90
  print_report+0xd1/0x630
  kasan_report+0xdb/0x110
  __asan_report_load4_noabort+0x14/0x20
  tb_retimer_scan+0xffe/0x1550 [thunderbolt]
  tb_scan_port+0xa6f/0x2060 [thunderbolt]
  tb_handle_hotplug+0x17b1/0x3080 [thunderbolt]
  process_one_work+0x626/0x1100
  worker_thread+0x6c8/0xfa0
  kthread+0x2c8/0x3a0
  ret_from_fork+0x3a/0x80
  ret_from_fork_asm+0x1a/0x30

This happens because the loop variable still gets incremented by one so
max becomes 3 instead of 2, and this makes the second loop read past the
the array declared on the stack.

Fix this by assigning to max directly in the loop body.

Fixes: ff6ab055e070 ("thunderbolt: Add receiver lane margining support for retimers")
CC: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/retimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/retimer.c
+++ b/drivers/thunderbolt/retimer.c
@@ -516,7 +516,7 @@ int tb_retimer_scan(struct tb_port *port
 	 */
 	tb_retimer_set_inbound_sbtx(port);
 
-	for (i = 1; i <= TB_MAX_RETIMER_INDEX; i++) {
+	for (max = 1, i = 1; i <= TB_MAX_RETIMER_INDEX; i++) {
 		/*
 		 * Last retimer is true only for the last on-board
 		 * retimer (the one connected directly to the Type-C
@@ -527,9 +527,10 @@ int tb_retimer_scan(struct tb_port *port
 			last_idx = i;
 		else if (ret < 0)
 			break;
+
+		max = i;
 	}
 
-	max = i;
 	ret = 0;
 
 	/* Add retimers if they do not exist already */


