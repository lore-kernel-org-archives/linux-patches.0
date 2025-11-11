Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE061DF258;
	Tue, 11 Nov 2025 00:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822755; cv=none; b=Wrk0RsMlBB60r6GGZx3KDlyJ2qvf85zscceQx9G+9nwrA9HYFmNUVZm5VZ3Myp1NnzYZdCPThmxwks9wBjhn6Xb5gykadWcXhRHjpp+lrukhfr668t0/3vQB+q57duam9Bzng04HWRGtHXv9GMbfLzP5uON23r+j7ftXeXBCj6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822755; c=relaxed/simple;
	bh=XGQLx+dmqAHoT4gfo51eYwxxLQtD5QKdTtb72CLjvQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF3t8IKBzBn4chSLsNZneN1T7QOM5KTuw2eW+JbZFJp9wwZgPU+24IeyBKuA+Qfn2Z1votJIKdgzyQ35ApWYA/7nAWET2BFhZ+4Izz5xC4qELoh/Yht3yONFKHyGmGeqyipsQYwf9v8zo4uB+/Zy5ehXKahk1uFUvFwdqwP8RK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9/Iy4JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9/Iy4JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCACC116B1;
	Tue, 11 Nov 2025 00:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822755;
	bh=XGQLx+dmqAHoT4gfo51eYwxxLQtD5QKdTtb72CLjvQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9/Iy4JR4jhYVLhCFkJUifIa9JFnnFa/7PhbwITP75eMqKftHOCYbtgKY4QJ6/uUx
	 lULF9YYGUi3YyJqYYx5wWe17cv1JKLN5+Hbq17WTBt3iRuhCXUvNYos58pX7uC9x6p
	 EH5dYhWraXhrlleWq4zSVvsO/vCovd3Gf817tCWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/565] firewire: ohci: move self_id_complete tracepoint after validating register
Date: Tue, 11 Nov 2025 09:39:15 +0900
Message-ID: <20251111004529.181660006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 696968262aeee51e1c0529c3c060ddd180702e02 ]

The value of OHCI1394_SelfIDCount register includes an error-indicating
bit. It is safer to place the tracepoint probe after validating the
register value.

Link: https://lore.kernel.org/r/20250823030954.268412-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7ee55c2804ded..90fcab1f65bcd 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2060,6 +2060,9 @@ static void bus_reset_work(struct work_struct *work)
 		ohci_notice(ohci, "self ID receive error\n");
 		return;
 	}
+
+	trace_self_id_complete(ohci->card.index, reg, ohci->self_id, has_be_header_quirk(ohci));
+
 	/*
 	 * The count in the SelfIDCount register is the number of
 	 * bytes in the self ID receive buffer.  Since we also receive
@@ -2228,15 +2231,8 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (event & OHCI1394_busReset)
 		reg_write(ohci, OHCI1394_IntMaskClear, OHCI1394_busReset);
 
-	if (event & OHCI1394_selfIDComplete) {
-		if (trace_self_id_complete_enabled()) {
-			u32 reg = reg_read(ohci, OHCI1394_SelfIDCount);
-
-			trace_self_id_complete(ohci->card.index, reg, ohci->self_id,
-					       has_be_header_quirk(ohci));
-		}
+	if (event & OHCI1394_selfIDComplete)
 		queue_work(selfid_workqueue, &ohci->bus_reset_work);
-	}
 
 	if (event & OHCI1394_RQPkt)
 		tasklet_schedule(&ohci->ar_request_ctx.tasklet);
-- 
2.51.0



