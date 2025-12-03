Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770C32FA22;
	Wed,  3 Dec 2025 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777115; cv=none; b=C7RCdJOKvwaZPlQTBJQC3lD18Ztzj5+BA1Xt2yxy5T6Hzk8NiL5nMSD4hHmWV4mE5E5exWqaR31F08kkozjcjrebjqb5P6wUmOJU6kIprvOWhke8N33RE8hHQf2wBaeuEdohXKW54BAsDjyaFicX398zTosVN/Ktmt5vyVuCTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777115; c=relaxed/simple;
	bh=yUrDpJ3xJHwet2Z+ktijDb7TjhruVSTF1HHzUvFZ9V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4lxBz5sfos9Ow1IY4uZ4mUREihxORUT53IyDXz/48i+ye2Z2JmZgO6LJiilmLNTbFJ7pILcLy803C2YmFHvJOJEw0oxp/kEZ43ul54ec/MGKXETyN19OxHoaQ7bD7GPDHsDSO8iJzOeRlbc2jbPgVy233bVpHUu+kerJDevnpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxHmw/tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxHmw/tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C558C4CEF5;
	Wed,  3 Dec 2025 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777115;
	bh=yUrDpJ3xJHwet2Z+ktijDb7TjhruVSTF1HHzUvFZ9V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxHmw/tIgTOMUtnWoCiWmE21smCojFXo1c1Clo5QZeIBotT4WFC9K/NXaPrZdwG4r
	 Pr+0nrSyhO4AyH/e3Ph+h0QlNNr0xQohL76y6rL41g4496umOxrkqIln/SawjMb6kX
	 dw09hIoL5aHiYMVkGIKjDtj/ew/kzYGMXklU5EWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dharma Balasubiramani <dharma.b@microchip.com>,
	Kamel Bouhara <kamel.bouhara@bootlin.com>,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.17 087/146] counter: microchip-tcb-capture: Allow shared IRQ for multi-channel TCBs
Date: Wed,  3 Dec 2025 16:27:45 +0100
Message-ID: <20251203152349.645832421@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dharma Balasubiramani <dharma.b@microchip.com>

commit 109ff654934a4752f8875ded672efd1fbfe4d31d upstream.

Mark the interrupt as IRQF_SHARED to permit multiple counter channels to
share the same TCB IRQ line.

Each Timer/Counter Block (TCB) instance shares a single IRQ line among its
three internal channels. When multiple counter channels (e.g., counter@0
and counter@1) within the same TCB are enabled, the second call to
devm_request_irq() fails because the IRQ line is already requested by the
first channel.

Cc: stable@vger.kernel.org
Fixes: e5d581396821 ("counter: microchip-tcb-capture: Add IRQ handling")
Signed-off-by: Dharma Balasubiramani <dharma.b@microchip.com>
Reviewed-by: Kamel Bouhara <kamel.bouhara@bootlin.com>
Reviewed-by: Bence Csókás <bence98@sch.bme.hu>
Link: https://lore.kernel.org/r/20251006-microchip-tcb-v1-1-09c19181bb4a@microchip.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/microchip-tcb-capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 1a299d1f350b..19d457ae4c3b 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -451,7 +451,7 @@ static void mchp_tc_irq_remove(void *ptr)
 static int mchp_tc_irq_enable(struct counter_device *const counter, int irq)
 {
 	struct mchp_tc_data *const priv = counter_priv(counter);
-	int ret = devm_request_irq(counter->parent, irq, mchp_tc_isr, 0,
+	int ret = devm_request_irq(counter->parent, irq, mchp_tc_isr, IRQF_SHARED,
 				   dev_name(counter->parent), counter);
 
 	if (ret < 0)
-- 
2.52.0



