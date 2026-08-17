Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F620175A6B;
	Mon, 17 Aug 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978875; cv=none; b=ejx0+y8oDrI7DZDByVlyFlo6oAJbAgM/qeZsJbf3+ts/QYL1YXlS1JmRaIv7/cAPtPiKwMlzYCLiz1OmIitQLk3+t+QqjFFzalFJqpmlGPR+J8vKCJVaAm8/EEwIC4MlzBMY2sSIVsIFsv6+ELEswxMGp1l5Es/I3jv5gWoQivY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978875; c=relaxed/simple;
	bh=G4LnH1a3gHkhhebqpSRG/0XxTLD1zwBKp6pqrl8KBOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOycGZj1RjzhIQrcrLeCB6rwzHUbgUa4GisdOeiT1iQ5gDkHjDkPYocdQq4YartGxFJrkKpWouO244k05YoQ8yJ0pEJnNalwtkCkY9FZP+jehgBVVAciz5HpM7d2MJn2Du4Lw02GR5QUjwBgCbd5tNvXh0VlvvusQYupBVItAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqVBsdji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqVBsdji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589451F00A3A;
	Mon, 17 Aug 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978874;
	bh=hWrfTgIgv1w0DYbs6eIkfGMBYu7QINOqg2jhzPaTDUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqVBsdjiGPb8PYb1xknOqBqmznBocx2spS+McUBgmNLS5FZDj8V1Aa2j584B2+QPy
	 cHBSOTaNrjhhCNKZQvicHjeoR7Zse0Kn0zCQpL/TmRAMXDUCLEC8kyslRX1Z6pgNpQ
	 WsIptyGpLxaoOZGNFVoIqvnPdIlwZuGDaeBLpW9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/609] Input: ims-pcu - fix logic error in packet reset
Date: Mon, 17 Aug 2026 15:25:19 +0200
Message-ID: <20260817132543.997371490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2c9b85a14abb4811e8d4773ccd13559e59792efb ]

ims_pcu_reset_packet() incorrectly sets have_stx to true, which implies
that the start-of-packet delimiter has already been received. This
causes the protocol parser to skip waiting for the next STX byte and
potentially process garbage data.

Correctly set have_stx to false when resetting the packet state.

Fixes: 875115b82c29 ("Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index af1dfc08b10b25..6b2aeaa50812f2 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -450,7 +450,7 @@ static void ims_pcu_handle_response(struct ims_pcu *pcu)
 
 static void ims_pcu_reset_packet(struct ims_pcu *pcu)
 {
-	pcu->have_stx = true;
+	pcu->have_stx = false;
 	pcu->have_dle = false;
 	pcu->read_pos = 0;
 	pcu->check_sum = 0;
-- 
2.53.0



