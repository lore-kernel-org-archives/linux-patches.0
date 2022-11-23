Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E931C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A51FC433C1;
	Wed, 23 Nov 2022 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197365;
	bh=uq07HycUuh2aczJEPzhjUVLluB6NOHBwxU9ddSm4wSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KKNAn1bB0LJqFwAKIIlzexFHEcfh8OfnP9CGSz12J50MyTiGG62u/ZVtaRGqK7BH
	 fjMKzWOhuSyu1FAtvlZdBxbLo9BN80aP6uaBxBKlVjqd0HKbQW9usSOdJoZAVoOTlu
	 H3ckYyN6jE0fsmKG5/Wq8olZijfmsuryWWyBdHZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sven Peter <sven@svenpeter.dev>,
	Eric Curtin <ecurtin@redhat.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>
Subject: [PATCH 6.0 243/314] usb: typec: tipd: Prevent uninitialized event{1,2} in IRQ handler
Date: Wed, 23 Nov 2022 09:51:28 +0100
Message-Id: <20221123084636.496667105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Peter <sven@svenpeter.dev>

commit 6d8fc203b28ff8f6115fbe5eaf584de8b824f4fa upstream.

If reading TPS_REG_INT_EVENT1/2 fails in the interrupt handler event1
and event2 may be uninitialized when they are used to determine
IRQ_HANDLED vs. IRQ_NONE in the error path.

Fixes: c7260e29dd20 ("usb: typec: tipd: Add short-circuit for no irqs")
Fixes: 45188f27b3d0 ("usb: typec: tipd: Add support for Apple CD321X")
Cc: stable <stable@kernel.org>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Link: https://lore.kernel.org/r/20221102161542.30669-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -474,7 +474,7 @@ static void tps6598x_handle_plug_event(s
 static irqreturn_t cd321x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event;
+	u64 event = 0;
 	u32 status;
 	int ret;
 
@@ -519,8 +519,8 @@ err_unlock:
 static irqreturn_t tps6598x_interrupt(int irq, void *data)
 {
 	struct tps6598x *tps = data;
-	u64 event1;
-	u64 event2;
+	u64 event1 = 0;
+	u64 event2 = 0;
 	u32 status;
 	int ret;
 


