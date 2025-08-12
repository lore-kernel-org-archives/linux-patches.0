Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8505186331;
	Tue, 12 Aug 2025 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020583; cv=none; b=hmXL7VFIGKI1BKPYHeiaVSuNo+8ArHYwynj0DhYxJKZqw5gA+SivbnT789o31D1yRpicc+wu4myYpME0U3LORnYwQmrJDaD1xIEmYon8QmIUsG26QIptgc3z4GrHGexYSdPAj42G0LP7PTELjWm8wGOUIsJSrU1iPqvcJne/v9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020583; c=relaxed/simple;
	bh=QQEcIPQPmkOBjdxJDehzWj3XtkzACDAIfdevAnGJ41I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjlJsM8/yyi8Qcs2pLT4g1yD7oNmovXh+T3ywloVgn4s97JdES0AjsIDvX0jLOlpQp9xhjZjHpE3gP8EGiEToQc/y6/2OjJjH4k37XfJwv4j8vXqptDpF6b+J8ut1kzs2CWyWMnUHE5gZCIfFkIJDZlK3WEt8QGQGL4zQfFvsr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLlLBVh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLlLBVh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7902C4CEF0;
	Tue, 12 Aug 2025 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020583;
	bh=QQEcIPQPmkOBjdxJDehzWj3XtkzACDAIfdevAnGJ41I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLlLBVh7xsf2/sznhqsGKaX+H6CGFrR58mJKHCKiB9/1+KPXFZFEDUv2Gq78L6Xwn
	 ogUemNC1scRflvzvWL6h33VH9pE8wEiGPiV4RpffWxIlakibKqLZCaqKKkkSNWi/2y
	 nlGMAEbKHJWFvxXdOHH8mSodkYNwXHvyjPll+IWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/253] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 12 Aug 2025 19:28:03 +0200
Message-ID: <20250812172952.776624650@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



