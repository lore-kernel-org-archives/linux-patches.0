Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD13B10E0;
	Tue, 26 Aug 2025 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219391; cv=none; b=fLHYGYIqXTzvUeeOtV+h/3Mxrih+DMlw6ZkE3wm1jgtbpYZKX9MbImPY0elss4DPgAjIA/OoT8OSpXDoQv/WwgC5XJx44cCE+Nhk9k11CQWb4d+5ckdDJGW6CqDzByV+fMeK5CoL2mTB6ivq5OHP1vnT/fJmbBOKxYUFV6vyaqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219391; c=relaxed/simple;
	bh=ztdUQUC9dWSrglNOQ3Yj98rMqhRmiuClbjiWfRrm/EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8Ybl4OMGMsPCw1Pgb1AE5Mlmwv8h+pFgvWCb51U3gXL6U0uCV6hn/UnTHPhTnQgDlT9Js9IDjuHB6tQJe65sUX1HOe1kdp0/x4k1HC1FmaJ5VVk8gCHqZ6vN/H1I0shdzZJVBmrNEso0rRwxkh5k7q4b7+xhLKGjThj7qO9RAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J73K5rqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J73K5rqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A116C4CEF1;
	Tue, 26 Aug 2025 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219390;
	bh=ztdUQUC9dWSrglNOQ3Yj98rMqhRmiuClbjiWfRrm/EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J73K5rqBtghwhLDptZvbQfTjI2R0E+Tdm6/zT/JFqzPDGmw0twOo3s7d649MFTf1F
	 /Q8qB8m408SutOy/M74nTLYegfiFQ0KXryufaxeKn8/TnF8HX2Mq0B7+847czcwQE7
	 a4UkIkojNYW+xW9OoFKvXroMBxb8eyWYapq0HEqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 364/403] media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()
Date: Tue, 26 Aug 2025 13:11:30 +0200
Message-ID: <20250826110917.056343183@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 7af160aea26c7dc9e6734d19306128cce156ec40 ]

In the interrupt handler rain_interrupt(), the buffer full check on
rain->buf_len is performed before acquiring rain->buf_lock. This
creates a Time-of-Check to Time-of-Use (TOCTOU) race condition, as
rain->buf_len is concurrently accessed and modified in the work
handler rain_irq_work_handler() under the same lock.

Multiple interrupt invocations can race, with each reading buf_len
before it becomes full and then proceeding. This can lead to both
interrupts attempting to write to the buffer, incrementing buf_len
beyond its capacity (DATA_SIZE) and causing a buffer overflow.

Fix this bug by moving the spin_lock() to before the buffer full
check. This ensures that the check and the subsequent buffer modification
are performed atomically, preventing the race condition. An corresponding
spin_unlock() is added to the overflow path to correctly release the
lock.

This possible bug was found by an experimental static analysis tool
developed by our team.

Fixes: 0f314f6c2e77 ("[media] rainshadow-cec: new RainShadow Tech HDMI CEC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[ drivers/media/cec/usb/rainshadow/ => drivers/media/usb/rainshadow-cec/ ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -171,11 +171,12 @@ static irqreturn_t rain_interrupt(struct
 {
 	struct rain *rain = serio_get_drvdata(serio);
 
+	spin_lock(&rain->buf_lock);
 	if (rain->buf_len == DATA_SIZE) {
+		spin_unlock(&rain->buf_lock);
 		dev_warn_once(rain->dev, "buffer overflow\n");
 		return IRQ_HANDLED;
 	}
-	spin_lock(&rain->buf_lock);
 	rain->buf_len++;
 	rain->buf[rain->buf_wr_idx] = data;
 	rain->buf_wr_idx = (rain->buf_wr_idx + 1) & 0xff;


