Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1522F745D;
	Tue, 12 Aug 2025 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023604; cv=none; b=Kz6gucU17EE1nvY0PGX2r9jAynbGfZDEsywfNsjHUOx3vHod/BIgk01F80J+nowNQA0K0xlEkHv7hQMRSRYwo/dINcypZIY2HXDXvjjAvYfasm3VhBW36Tu4tkJoFiPRKLZBC8VblgmPuq6lH/+7p1DkxERhf9Oo9PMuqfMjUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023604; c=relaxed/simple;
	bh=IBXbcSSyflIoytEVv83Y52qyU2xZv1tT+Xy5JPcSsZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ur5PVoht3t6GyaUJXRbwaRfRjQQ2uKzqsio8Q//FUVe30i/mvp8quUseNaVdVMo+5AB6oFeXwBTq880CuqddGcSeO/t0QYhjL5K5VF8LTNxw99o1jiEQrS+tZsxoX3wwFBHmqnrMajk1qNU/7n0GOkt5MFPkMxa6P+LQ/p4xYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSOf9pZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSOf9pZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA746C4CEF0;
	Tue, 12 Aug 2025 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023604;
	bh=IBXbcSSyflIoytEVv83Y52qyU2xZv1tT+Xy5JPcSsZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSOf9pZ05T5s7XTYmQE2kXhzs2qRK4hh1aMDHBcBXwl3ritdkGU4Ly9woNwb9lPdU
	 uvLiRdImX7w60OAQ8ahUyFyv2VXUsvak6TlixtjBniBbSkOwE6CIbNJVy4bXv1MgFh
	 MNjacDJel12mrHhKssUc4cy0AkAJBG64fdGvRTck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 127/627] staging: nvec: Fix incorrect null termination of battery manufacturer
Date: Tue, 12 Aug 2025 19:27:02 +0200
Message-ID: <20250812173424.153767582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e0e67a3eb722..2faab9fdedef 100644
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



