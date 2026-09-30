Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F7E515961;
	Wed, 30 Sep 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784607; cv=none; b=nxqK2MHLSWyTcbT1HU+jAYazIVOM6tQVDWJQpOxNl3nXDcU1EiZXPZ6D0u9p6UgI74+osPUdddfCBWfpB0SVbWKRdfEWMrnoncdvafa2wPPgoEzskxtLV4HWTt576cPAy3guC1T/f5MsNsYGTfB0HDHEmMlPxpW1Sh4UBKPDg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784607; c=relaxed/simple;
	bh=ehxApt84hdlRyeSUZIcaOsGTg5IMG/so2AjH004XZ/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cljKTLcoRDKUbol3j/Gp7DFM07DIWDEy1d9EZ8itzfP4g4K6ZkLl0muAh64qo7o8BRXggdxW1SDc+LdmaF3Fm4ALTYO17t4XJrk3ebndNZIMq6ylYckrdxHDLq2bM0VPILTcO/xav6d8VoVeOeMluZTZcaXAE1825K7jaUZ0tx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkgW934E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkgW934E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB571F00893;
	Wed, 30 Sep 2026 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784601;
	bh=OZqFZmJP6W0AoYTGRM6YIALjKgXW635PLXeTll3CvvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkgW934EbcYE38vO51lb8G5mS9w8WqvrNYqRlwpRt2MzwmRakV2BTT4lw7TL+yrsh
	 wuOBkoKt/oPQftwywQv6qy1gRzmEZqsxnCwtSElCK9L4Ao+JbL2tUboRGqmstPiOki
	 QXUFYn4XWjDTtqSCG5zmiYBTnWbdYIe8p1UaR2vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/982] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Wed, 30 Sep 2026 17:15:50 +0200
Message-ID: <20260930152421.405783320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 664aa8c0781e9..dd0864df1d8cf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -992,7 +992,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0



