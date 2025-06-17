Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E68F54;
	Tue, 17 Jun 2025 16:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178672; cv=none; b=Ra5oUx8VKHeNKLQI8TLqRHneH/L7CHg2UkY1Hg/JW5gEERTIgX++Y3arKkM89UCXteaUlR4ZriUzbsl9KCB5Muwff+fdHqYR9leFjsDfSEXjXVv0GjcnuoKmIOw3lT0SS15zFk1atyaCP5Em2TNaplwC6sYpliSCCWAw+M5dzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178672; c=relaxed/simple;
	bh=vr/AWA56XpntZVAmd9Q1a0gg189XCUUAW2ncyBErcZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOYN5EXlEknDcyW5Z9MuGVypFv1KFtSVhPA3vAjwVfcqhXHt3qLG878Zquu0X3ohMWb5TheOfaoVuh5FND8aZxh3eSy9mCww0W2Q/7MswtsumAi9NHyGstqE570EgxrSxm8LIuwGkL3DkNgFE1nwPB5SEBhBcuU4W6HysgEAF+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB1nfTb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB1nfTb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92344C4CEF0;
	Tue, 17 Jun 2025 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178672;
	bh=vr/AWA56XpntZVAmd9Q1a0gg189XCUUAW2ncyBErcZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB1nfTb6C4cHScRr9Ob23+3fZuuloGYybFp8u7a6Dd7e2TgX3F9dYMqodR0oQTh00
	 EupHNmPTXbYRpa1wCMrSssH9uIoazC4bdAx3bLQN/ldKA5jxF6u4ATWnzRGC3aeh6t
	 uR6ib1jUYS8HMtbI4G+KgJqgNbgnL0r5bFGhHEwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 519/780] iio: filter: admv8818: fix integer overflow
Date: Tue, 17 Jun 2025 17:23:47 +0200
Message-ID: <20250617152512.644400290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Winchenbach <swinchenbach@arka.org>

[ Upstream commit fb6009a28d77edec4eb548b5875dae8c79b88467 ]

HZ_PER_MHZ is only unsigned long. This math overflows, leading to
incorrect results.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/20250328174831.227202-4-sam.winchenbach@framepointer.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index 3d8740caa1455..cd3aff9a2f7bf 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -154,7 +154,7 @@ static int __admv8818_hpf_select(struct admv8818_state *st, u64 freq)
 	}
 
 	/* Close HPF frequency gap between 12 and 12.5 GHz */
-	if (freq >= 12000 * HZ_PER_MHZ && freq <= 12500 * HZ_PER_MHZ) {
+	if (freq >= 12000ULL * HZ_PER_MHZ && freq < 12500ULL * HZ_PER_MHZ) {
 		hpf_band = 3;
 		hpf_step = 15;
 	}
-- 
2.39.5



