Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062795;
	b=N6/9VrTIY8pN0bIFHjUP0UzF7YgAUZqmae/sdBIjo0LSTX+v3OAPpEUdxyzazxqQ6R+S
	 ouCr1BCdi+b1kUnRt36IQCZbOxNgagU5AbWHTM2FVYAtJVIN9wAoULeGWFLnHszeYeunG
	 MnChtj4KDep7IY5eyQb0kR1DWw8sjVkHsM+Q6AdS/pEc2KU+/ROOVAeRPoMEqYBiO51AW
	 KcrFQOAkyEPXWOMLva6CxclzCV2QVYBz3l+edNGIKpZFASgReebWdBTSfoHoLIOtofhpl
	 0TJedhyRXJGridx6ar70bWjIxBpxWPAjHH1fcMKqb1EIxle7SQZPq/7tZmzNFkVbQaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XnalLnkyGRT7vCf/Gfi8X41aDZFO4lu5XWApPq9Bnco=;
	b=uAILtggGOLYnjx+i6x6i99+3kwsrpC97f/LsOVfb/9/jjH53ALI3wB+eZ6GhVtv4BBK2
	 tsayD/cwmPRUrZbu3c+a0I/m7BDqa6oV7Dl/swz4UIJ0TsfhmVed2g36dm8pSKXecL2LQ
	 o/1igOmYIy/TkuULcYQNyZn17Dtrs33dJy/R+ElEeRIFnhdlOFlioCob6IeA4uKMM6LbZ
	 nE/1LaUFxIkL55B+BFufS6XrxSS6mFCiNLc/iihUQdw4y7DIPe+zCpqIou+4+v/MDd4Vr
	 QG/g4lGg4bUqtaAqgi3cX0nBPk4QYNuRM6gJBu9jwNdV/bM8lHpKoOfKJ0DwtmdiR9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCimmdE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357A8606D804;
	Sat,  7 Nov 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCimmdE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60C71F008A4;
	Sat,  7 Nov 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062794;
	bh=XnalLnkyGRT7vCf/Gfi8X41aDZFO4lu5XWApPq9Bnco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCimmdE2YHMvTI9SoO/H1S+h5mVtiWnkDUuBdu6tf/SdWG67t6G0baUDxIHu4dioE
	 pxkcCvYnAUdEeQOX+Kz2y5Ic1pCoPGlEd6H84hZk9lXgHb69m0bk0Ypqonfwmop5vg
	 EqJgAyieoV7YFuTnhU28lp/0q08WzQYqR9EYfO94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/869] media: microchip-isc: fix PM runtime leak in AWB work handler
Date: Sat,  7 Nov 2026 08:46:21 -0500
Message-ID: <20261107134856.015709286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 21ad8225822a892c4c273bf1368d477a83a19dbb ]

Early return when streaming stops skips pm_runtime_put_sync(),
leaking the reference and preventing runtime suspend.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index cf4611443fd13..21d108eb93c7b 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1432,7 +1432,7 @@ static void isc_awb_work(struct work_struct *w)
 	/* streaming is not active anymore */
 	if (isc->stop) {
 		mutex_unlock(&isc->awb_mutex);
-		return;
+		goto out_pm_put;
 	}
 
 	isc_update_profile(isc);
@@ -1443,6 +1443,7 @@ static void isc_awb_work(struct work_struct *w)
 	if (ctrls->awb)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
 
+out_pm_put:
 	pm_runtime_put_sync(isc->dev);
 }
 
-- 
2.53.0



