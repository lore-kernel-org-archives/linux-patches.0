Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390413A25E;
	Tue, 14 May 2024 11:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684678; cv=none; b=hZavKqOf8c5YZTqf9BdNTXhzLKxGsZfbFC+Jf6npaFzdjckCeJSeQJmWq2bg8auU6Ugq7KU0Y89g1Cjfl4PvzTeTVvzVq+VqlvRCqZ4uda8Qjmgu18w1P33MhONgIY+Y1eLFgt+VYKE3xCbx25X5ZCM+0fv1UyZCPFWKrhzq+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684678; c=relaxed/simple;
	bh=ZjA0gMkCDNUX7YEP7MPWXi96QKAQpm5Qaluy/ACIhj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDFBWbFyXFExpb/ENiQMv19wwoUZey+++jlloCQfFNAJK3ZOGXdTUysLZfO+j40PGhwR/sZnf8xIo08hvNDNZG5FU2VJ2nTBJjxY7Q/MI2ssG1Z1Llhr2j0uIw3v5yZpb2ZIgzRIEO+102GdwDbFXLVK6nCyvvW/WTcnfiyd10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0v6ssdYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0v6ssdYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18904C2BD10;
	Tue, 14 May 2024 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684678;
	bh=ZjA0gMkCDNUX7YEP7MPWXi96QKAQpm5Qaluy/ACIhj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0v6ssdYLkVS8SnuMQi5haE4lUYbPkfohcH/H6+Hmyjzf+Rjo7XWZNaqfDExNQlXgA
	 /iayidnuczyW9UuwY402nUYwXuR1vLL0kFnn5jMjn18iWIcOQkw+4vK7MCwQto4uxX
	 2TCK75kpSod1X1hZ7AzPs3jwnmGKAfeqq4QcyMBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mans Rullgard <mans@mansr.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/301] spi: fix null pointer dereference within spi_sync
Date: Tue, 14 May 2024 12:15:46 +0200
Message-ID: <20240514101035.081845325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit 4756fa529b2f12b7cb8f21fe229b0f6f47190829 ]

If spi_sync() is called with the non-empty queue and the same spi_message
is then reused, the complete callback for the message remains set while
the context is cleared, leading to a null pointer dereference when the
callback is invoked from spi_finalize_current_message().

With function inlining disabled, the call stack might look like this:

  _raw_spin_lock_irqsave from complete_with_flags+0x18/0x58
  complete_with_flags from spi_complete+0x8/0xc
  spi_complete from spi_finalize_current_message+0xec/0x184
  spi_finalize_current_message from spi_transfer_one_message+0x2a8/0x474
  spi_transfer_one_message from __spi_pump_transfer_message+0x104/0x230
  __spi_pump_transfer_message from __spi_transfer_message_noqueue+0x30/0xc4
  __spi_transfer_message_noqueue from __spi_sync+0x204/0x248
  __spi_sync from spi_sync+0x24/0x3c
  spi_sync from mcp251xfd_regmap_crc_read+0x124/0x28c [mcp251xfd]
  mcp251xfd_regmap_crc_read [mcp251xfd] from _regmap_raw_read+0xf8/0x154
  _regmap_raw_read from _regmap_bus_read+0x44/0x70
  _regmap_bus_read from _regmap_read+0x60/0xd8
  _regmap_read from regmap_read+0x3c/0x5c
  regmap_read from mcp251xfd_alloc_can_err_skb+0x1c/0x54 [mcp251xfd]
  mcp251xfd_alloc_can_err_skb [mcp251xfd] from mcp251xfd_irq+0x194/0xe70 [mcp251xfd]
  mcp251xfd_irq [mcp251xfd] from irq_thread_fn+0x1c/0x78
  irq_thread_fn from irq_thread+0x118/0x1f4
  irq_thread from kthread+0xd8/0xf4
  kthread from ret_from_fork+0x14/0x28

Fix this by also setting message->complete to NULL when the transfer is
complete.

Fixes: ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")

Signed-off-by: Mans Rullgard <mans@mansr.com>
Link: https://lore.kernel.org/r/20240430182705.13019-1-mans@mansr.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1e08cd571d21a..76383ddbd6a6f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4261,6 +4261,7 @@ static int __spi_sync(struct spi_device *spi, struct spi_message *message)
 		wait_for_completion(&done);
 		status = message->status;
 	}
+	message->complete = NULL;
 	message->context = NULL;
 
 	return status;
-- 
2.43.0



