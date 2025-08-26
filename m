Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E87199935;
	Tue, 26 Aug 2025 11:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208470; cv=none; b=KIBckAwXQaZNoOcpxJvcFfyn/QEZHMd9pYI+8ydSOmzba+Q0sIRJP/uzE/kEbB+hoiz3zsD1ZwOLEaXtMp9vshis4KGIcyBFpJUNZ+NQ8yiTljpyQYm3+dBfOf0dfcA2ouGeXnTqtTsLL+26iD15oAWaUrD4lfzQ8wiVdNPPSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208470; c=relaxed/simple;
	bh=kLJFD/SKWmQyYFaPY0nVDGSh2ckPHo7op1YmFNe7Kd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOfeza3ugZWreLqZ9kbgeRB3mapZvSvLQ/EkhiAQxLjhn8vzTILfGWidjJsaaHuoJVkgJRGpYZKPOJDXJNgWNpY3AT417cGokvmKHYJGFIsalp6UInK49V2DzKQ0ovX05iSafNrxllnWT8p4z1gNiSA5Xns4tMHSMP/dWEThc+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXgepgrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXgepgrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29083C4CEF1;
	Tue, 26 Aug 2025 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208469;
	bh=kLJFD/SKWmQyYFaPY0nVDGSh2ckPHo7op1YmFNe7Kd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXgepgrLuhyGAoqiMHCUsfcKqXHHLylMGuZfllDLQxogLgovQcK5v5wugY6RZrvnQ
	 zp22HsWpt8GYzAj1c7bCs9bEBNk8fBxGAaYMa5LR1DfrTQpPhlLsos+cgbSm/gEezS
	 TDggGoKN4b6FOQtWx+oZ2VI4wzbC7dix9TADGP0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 106/322] media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()
Date: Tue, 26 Aug 2025 13:08:41 +0200
Message-ID: <20250826110918.381466083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 7af160aea26c7dc9e6734d19306128cce156ec40 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/usb/rainshadow/rainshadow-cec.c
+++ b/drivers/media/cec/usb/rainshadow/rainshadow-cec.c
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


