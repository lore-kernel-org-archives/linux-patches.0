Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E36FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4194DC433EF;
	Mon,  3 Apr 2023 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531938;
	bh=P4CzGikgM7jVUFgJYP7iZJQTknwuEyOTArmUon2XDVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJqZaR/G/yoMeEWZ3As2RTu67HKKuAJJ9r+dP+kp3Fmp1TFZUw1uzZ2FkiYt0KSRh
	 G48VagGqB+2hJLmb25Gvyi7IgcQ9Nnw0QNYCTvRG+9C2dqpQnvxzXW6lUDv6U+By6W
	 ZRWpPh3+2oTGeARVJQZnhq1kmPqwsznrf2wyEINk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Kaehn <kaehndan@gmail.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/173] HID: cp2112: Fix driver not registering GPIO IRQ chip as threaded
Date: Mon,  3 Apr 2023 16:08:00 +0200
Message-Id: <20230403140416.558156432@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danny Kaehn <kaehndan@gmail.com>

[ Upstream commit 37f5b858a66543b2b67c0288280af623985abc29 ]

The CP2112 generates interrupts from a polling routine on a thread,
and can only support threaded interrupts. This patch configures the
gpiochip irq chip with this flag, disallowing consumers to request
a hard IRQ from this driver, which resulted in a segfault previously.

Signed-off-by: Danny Kaehn <kaehndan@gmail.com>
Link: https://lore.kernel.org/r/20230210170044.11835-1-kaehndan@gmail.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 172f20e88c6c9..d902fe43cb818 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1352,6 +1352,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	girq->parents = NULL;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_simple_irq;
+	girq->threaded = true;
 
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
-- 
2.39.2



