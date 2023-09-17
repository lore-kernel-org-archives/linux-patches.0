Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A3E6FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC8FC433C7;
	Sun, 17 Sep 2023 20:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982796;
	bh=HuVoiCWovM9o2D3WB/0oNLr3gzNppIEIwTUTfE9yC+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15jP3ZkiqHi+hrscODMqypuQEbQNi44NCDf+6u2NEjtJsoChvJlwLzygVaBqDpnzU
	 Xl+Z0g+PmjEOD5n7ULCNUlEfv7V2ulnp7fsM/VWKhA6maM/AzHRton/tOfhazHK4DR
	 klwyUJBubP881U3I4bZQU2sBYPnlok+Ytuu8+T94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlong Xing <yunlong.xing@unisoc.com>,
	Enlin Mu <enlin.mu@unisoc.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 355/511] pstore/ram: Check start of empty przs during init
Date: Sun, 17 Sep 2023 21:13:02 +0200
Message-ID: <20230917191122.375111830@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enlin Mu <enlin.mu@unisoc.com>

commit fe8c3623ab06603eb760444a032d426542212021 upstream.

After commit 30696378f68a ("pstore/ram: Do not treat empty buffers as
valid"), initialization would assume a prz was valid after seeing that
the buffer_size is zero (regardless of the buffer start position). This
unchecked start value means it could be outside the bounds of the buffer,
leading to future access panics when written to:

 sysdump_panic_event+0x3b4/0x5b8
 atomic_notifier_call_chain+0x54/0x90
 panic+0x1c8/0x42c
 die+0x29c/0x2a8
 die_kernel_fault+0x68/0x78
 __do_kernel_fault+0x1c4/0x1e0
 do_bad_area+0x40/0x100
 do_translation_fault+0x68/0x80
 do_mem_abort+0x68/0xf8
 el1_da+0x1c/0xc0
 __raw_writeb+0x38/0x174
 __memcpy_toio+0x40/0xac
 persistent_ram_update+0x44/0x12c
 persistent_ram_write+0x1a8/0x1b8
 ramoops_pstore_write+0x198/0x1e8
 pstore_console_write+0x94/0xe0
 ...

To avoid this, also check if the prz start is 0 during the initialization
phase. If not, the next prz sanity check case will discover it (start >
size) and zap the buffer back to a sane state.

Fixes: 30696378f68a ("pstore/ram: Do not treat empty buffers as valid")
Cc: Yunlong Xing <yunlong.xing@unisoc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
Link: https://lore.kernel.org/r/20230801060432.1307717-1-yunlong.xing@unisoc.com
[kees: update commit log with backtrace and clarifications]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/ram_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -518,7 +518,7 @@ static int persistent_ram_post_init(stru
 	sig ^= PERSISTENT_RAM_SIG;
 
 	if (prz->buffer->sig == sig) {
-		if (buffer_size(prz) == 0) {
+		if (buffer_size(prz) == 0 && buffer_start(prz) == 0) {
 			pr_debug("found existing empty buffer\n");
 			return 0;
 		}


