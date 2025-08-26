Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BA2D060B;
	Tue, 26 Aug 2025 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215781; cv=none; b=FerA7a+Ce7JJ+D/D8Fa2SaeoEPcNxXPHcm5kZQDLhBUQ2s3TJhj/Y5dWc+Ygl8+1+MYaGGP1W/wXen/MjA0e346O3d5FRglV+aMAFXPqpsdnqIjGlBg2KBBeyplgK9sedry5O1KTc/+WFVJTh3XZGxks00wnwkDC/JE1xZyfAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215781; c=relaxed/simple;
	bh=Io9msalZ7gOlrwWhnA8lQhrlJ7HjxFoyFx/DVLFBaO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJs7SbQYpymdMi3fWIme01f+usXasCRMn2zGWTdo7sp3V7q67NZM2qkUD51liH+9hvwU4tAYg7x4n/rpPTkFeGmnn7qxI7IU6Vj16n28HBzuRnaMhHIb4LlkQ2nrLbPIxpgKAN1WAW7aNeOy7VfZrMjD/vnH/K3Pr0XuX2JBfnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD6myMvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD6myMvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3217C4CEF1;
	Tue, 26 Aug 2025 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215781;
	bh=Io9msalZ7gOlrwWhnA8lQhrlJ7HjxFoyFx/DVLFBaO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD6myMvvq8NRrFxFDFlYdff51Xa/79xVEJ1U/Pshlhz1aa9Ychyksh3Qq0WZrg8PH
	 dvBbALYLF/WllvRjQ2L00wngrMXrxULlpDtQjTVCQKMIhdNE0D80GabuConaPpT56/
	 YWOof2V0ZTGBCBZcbqhcmuwpgXg//cF2dxLSEB40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/644] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 26 Aug 2025 13:03:44 +0200
Message-ID: <20250826110949.803051222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a8934352ba01081c51d2df428e9d540aae0e88b5 ]

The battery manufacturer string was incorrectly null terminated using
bat_model instead of bat_manu. This could result in an unintended
write to the wrong field and potentially incorrect behavior.

fixe the issue by correctly null terminating the bat_manu string.

Fixes: 32890b983086 ("Staging: initial version of the nvec driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250719080755.3954373-1-alok.a.tiwari@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/nvec/nvec_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec_power.c b/drivers/staging/nvec/nvec_power.c
index b1ef196e1cfe..622d99ea9555 100644
--- a/drivers/staging/nvec/nvec_power.c
+++ b/drivers/staging/nvec/nvec_power.c
@@ -194,7 +194,7 @@ static int nvec_power_bat_notifier(struct notifier_block *nb,
 		break;
 	case MANUFACTURER:
 		memcpy(power->bat_manu, &res->plc, res->length - 2);
-		power->bat_model[res->length - 2] = '\0';
+		power->bat_manu[res->length - 2] = '\0';
 		break;
 	case MODEL:
 		memcpy(power->bat_model, &res->plc, res->length - 2);
-- 
2.39.5



