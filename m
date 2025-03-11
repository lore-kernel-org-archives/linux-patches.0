Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5003525E83D;
	Tue, 11 Mar 2025 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707266; cv=none; b=X1wBYWrdy8LZT4xBBqQBUX8oq9nzBffTV7rahZN/xJtKx7tbq5hkDWUiTNHCVqlDhdsF0zEy2UJqoRKHjTwLAx6DcTzHFE2Mz9raEQeW1EkEdwojSkvi3YBSeVr33LlBtrrPLbPz6PXD+LJW91NmJPsI1pUNNmaxPBSlk+Ii4jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707266; c=relaxed/simple;
	bh=PbXD0MwsQNd5+6xc8tc6ezWb8r/B0H9M0yw5dcSDSvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYsxa5YAILxH8I8nYLoRYM1naUTVTSHlBxfQ0RbBrNab3LAJy0MPz4tDz/MZ2fOcOM7s97FqHNmxBCZez0W97mGGTDzxtfkRy1yavStjn7reJPmRxIBE/MCyvGTZdCpQClf5koQFuHEsq6rUnSdyIN/DJfbdWMeA29WTLKjYVkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkpZSlOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkpZSlOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDE4C4CEE9;
	Tue, 11 Mar 2025 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707265;
	bh=PbXD0MwsQNd5+6xc8tc6ezWb8r/B0H9M0yw5dcSDSvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkpZSlOBdHRGJ7OXLwH8aA/8+4uK8U3rSeIvH3u3wsLqUb+89u2N38n4rx8sfjF5G
	 KNbQbPlAlHj9uCjVyb2QNkXSU5iy+Q5pFVMrMk+Nf7kuKeplvPO6R9mcqZznV5pqgh
	 SikdzxlagZY6J4PV6tTHZrY46uOL9lG88WK6qpSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jill Donahue <jilliandonahue58@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/462] USB: gadget: f_midi: f_midi_complete to call queue_work
Date: Tue, 11 Mar 2025 15:59:56 +0100
Message-ID: <20250311145811.398516103@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

From: Jill Donahue <jilliandonahue58@gmail.com>

[ Upstream commit 4ab37fcb42832cdd3e9d5e50653285ca84d6686f ]

When using USB MIDI, a lock is attempted to be acquired twice through a
re-entrant call to f_midi_transmit, causing a deadlock.

Fix it by using queue_work() to schedule the inner f_midi_transmit() via
a high priority work queue from the completion handler.

Link: https://lore.kernel.org/all/CAArt=LjxU0fUZOj06X+5tkeGT+6RbXzpWg1h4t4Fwa_KGVAX6g@mail.gmail.com/
Fixes: d5daf49b58661 ("USB: gadget: midi: add midi function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jill Donahue <jilliandonahue58@gmail.com>
Link: https://lore.kernel.org/r/20250211174805.1369265-1-jdonahue@fender.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 01c5736d381ef..3e8ea1bbe429a 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -282,7 +282,7 @@ f_midi_complete(struct usb_ep *ep, struct usb_request *req)
 			/* Our transmit completed. See if there's more to go.
 			 * f_midi_transmit eats req, don't queue it again. */
 			req->length = 0;
-			f_midi_transmit(midi);
+			queue_work(system_highpri_wq, &midi->work);
 			return;
 		}
 		break;
-- 
2.39.5



