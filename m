Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044482;
	b=1VYyRV7ZdPDbIS5qsRRArjo9aUOtkqNCkoBoUBfQ4wl/BgnFq04mmN5mZQcwZLTfn6wV
	 vAMsif9XlZCz0cZ+5RXqCmg5i9w3fwxaNmP99QbY80pc8Ppp6JQtvP/OK9P9RmCMruoaB
	 aeyp2W88chlTaRodI7e0ingMW56jm6ZFn8OWIa41RH/Bg4CG3CCACs37Dw7eM0myJiZn1
	 Ef2hEG7AZsufgMRXZUa14FBp7PUkpzcUKnBymhppD3KYfH7TushANcxGsIjld59x807dm
	 bRmNHLX4uPsTdFrYxDYNg8tqYDf+2v4/no6vRKol4bPD4KpxSx7Spl6Qk7Y02PF8Ftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tXQhp/bNDzOWWGcFmhLlvjmb22+Qje+x5Bg5SAu2FpI=;
	b=NSpUErBU2uEpchOV7VybimX2yAKHv0vXKFrb3lAYKW6usA+bzVcTjxua06rJZnKeTcaw
	 QjJrzX58wRw3GAVuYp+OvotvspBDTsff04TLg6q09sMsEP6Ar1DRRf2fhY5+duGhGHYrR
	 y+4qNYubUhdTSFcSoM/X3KtehEjkEifZr31gDFT2dB6Eb4m1iZdml0JQd2R+s51LyBR/X
	 3H+Xi1Aqn0JWm71iclZVZ5WBCuxOVDcqpKYiAf06yv+MdzEXViEVzcD4f6cOLBQRgWmtG
	 vCF2hVh56Ut9E+socO9gNuu6jigMG/u/unGmICLX4p4aIMTNmVK8CAB3lDZQs9WRefw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4rp2TFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DEB606A31C;
	Wed, 18 Nov 2026 23:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4rp2TFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84621F000C4;
	Wed, 18 Nov 2026 23:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044482;
	bh=tXQhp/bNDzOWWGcFmhLlvjmb22+Qje+x5Bg5SAu2FpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4rp2TFkqge2LK8zEy3DPDZkD9lta5btXhMpq/s2kgea1WqrsrSCvJb5eqziZX6/k
	 o2Yr9DlDNPmUgJF+YMxEfFX2easV8Env5Qr4i5tga1jLutaxqfqdV1jM/i1tmma5FH
	 ySRMQ/dQsLXLPi/Gkus+9Hx20i+uCcm74JfaHPiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 0584/2857] EDAC/mc: Really fix error path ordering in edac_mc_alloc()
Date: Wed, 18 Nov 2026 15:26:58 +0100
Message-ID: <20261118150222.510396553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

The backport of 51520e03e70d ("EDAC/mc: Fix error path ordering in
edac_mc_alloc()") to stable kernel branches is incomplete due to a
different memory allocation scheme. In v6.19 and earlier, the device
initialization must be moved further up so that all jumps to the
error label are covered.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@kernel.org # v6.19-
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 952ebd94e0ece..9ab8f31fbab55 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -365,13 +365,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned int mc_num,
 	if (!mci)
 		return NULL;
 
+	mci->dev.release = mci_release;
+	device_initialize(&mci->dev);
+
 	mci->layers = kcalloc(n_layers, sizeof(struct edac_mc_layer), GFP_KERNEL);
 	if (!mci->layers)
 		goto error;
 
-	mci->dev.release = mci_release;
-	device_initialize(&mci->dev);
-
 	mci->pvt_info = kzalloc(sz_pvt, GFP_KERNEL);
 	if (!mci->pvt_info)
 		goto error;
-- 
2.53.0



