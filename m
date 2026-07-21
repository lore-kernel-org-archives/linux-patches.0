Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CCF367B92;
	Tue, 21 Jul 2026 22:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673746; cv=none; b=bsxo5ufencyWsbuP+UN8A7iuyLWiXkb7vp3Y9ld+1KzUPNPxYj3wxQIYCO4c8rdKDEjB1TUgoVDAnpLwDR8p0/dydz3sdFqjpy6KEnsL5sQ2CEaytLawP2OmTSmSTHvNT/WoZEg2XT6dUd27TFzFDxdCYo9LR2Cdjoy8dEkaRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673746; c=relaxed/simple;
	bh=oPgYw7mK04dhrq3z+wsSct4sBJmeFYnBuWu7BDvO0iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW3swqVhzj9fPh2Py9BKMTEXQMAzGUWEwxbrcUTwxxeufjV4iTogefrJghDiu1Ds0rqP26mU0pTx3e86P8/eMi0PFpv4xnoQq2Y2CZc4q4TkF4HcVv40pLiT7JZcL8BtAem314XXbn5t1KT/5y0eSMEk3yTjjvHP73m/hp32uHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaXrdlo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaXrdlo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119FE1F000E9;
	Tue, 21 Jul 2026 22:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673745;
	bh=e5YH+LJs8amZb9Hg6NTtGExnYpwYhy2R9c8CU3H9k3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaXrdlo8YZ4Xa0aLzrHbQzGkmLZFFRVhYgrrCdd0f2ZQLwKvsB6rgCtXMSS23RzoG
	 EhdhvhiqpL6S9y+I0aljeu57NIXiqGJuZOvMAqGJaR2CC2B9tXOdjxYRNLRBGtQofy
	 9ZF1YmRVYggynnePQsZ92J5xKg5FJe9BY3zBFMlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/699] staging: nvec: fix use-after-free in nvec_rx_completed()
Date: Tue, 21 Jul 2026 17:20:39 +0200
Message-ID: <20260721152402.013744085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

[ Upstream commit 26813881181deb3a32fbb59eadb2599cbe8423f6 ]

In nvec_rx_completed(), when an incomplete RX transfer is detected,
nvec_msg_free() is called to return the message back to the pool by
clearing its 'used' atomic flag. Immediately after this, the code
accesses nvec->rx->data[0] to check the message type.

Since nvec_msg_free() marks the pool slot as available via atomic_set(),
any concurrent or subsequent call to nvec_msg_alloc() could claim that
same slot and overwrite its data[] array. Reading nvec->rx->data[0] after
freeing the message is therefore a use-after-free.

Fix this by saving the message type byte before calling nvec_msg_free(),
then using the saved value for the battery quirk check.

Fixes: d6bdcf2e1019 ("staging: nvec: Add battery quirk to ignore incomplete responses")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260427081713.3401874-2-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/nvec/nvec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index a80996b2f5ce4a..49fdb486b01976 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -488,6 +488,8 @@ static void nvec_tx_completed(struct nvec_chip *nvec)
 static void nvec_rx_completed(struct nvec_chip *nvec)
 {
 	if (nvec->rx->pos != nvec_msg_size(nvec->rx)) {
+		unsigned char msg_type = nvec->rx->data[0];
+
 		dev_err(nvec->dev, "RX incomplete: Expected %u bytes, got %u\n",
 			(uint)nvec_msg_size(nvec->rx),
 			(uint)nvec->rx->pos);
@@ -496,7 +498,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
 		nvec->state = 0;
 
 		/* Battery quirk - Often incomplete, and likes to crash */
-		if (nvec->rx->data[0] == NVEC_BAT)
+		if (msg_type == NVEC_BAT)
 			complete(&nvec->ec_transfer);
 
 		return;
-- 
2.53.0



