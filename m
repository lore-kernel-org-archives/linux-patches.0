Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E75A2EE61A;
	Tue, 17 Jun 2025 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177309; cv=none; b=iol+FmUBdsfcONl1qEOeAmYdSuE8p/BubkYndxSpU+4oJZ42ohce6p0HBvM8zMiN8Wmc3gT7NU9PEdC5ljWvrtwg7WcBgQiKTOMSc18cexIdQ3E7+ZShZbpNgixaFWd1IR1TksxMjKTlny4oVgl6BiKpF52q9dt9CFBOz83AZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177309; c=relaxed/simple;
	bh=uofsRUT0Uv8LgMgkTbsIT2aNGwU9yq5xfZ8VHEqGMVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhmfsIiQI2rJOasuZk26KhuXwQ9uLEZSwe/lw6l4PkI/L3hCfB1biVH3wUVgxZ+HNAjSoXFEKt6mVLFmycNSUZ94/KxunLrDCO0Ji/5CjuZPwQCfpfU1E6xgS/ha3zarTmzGAp1rKJnpHYPUimPGECaKoNupbjMjfXl98hgKbP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7fb5uCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7fb5uCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4CBC4CEE3;
	Tue, 17 Jun 2025 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177309;
	bh=uofsRUT0Uv8LgMgkTbsIT2aNGwU9yq5xfZ8VHEqGMVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7fb5uCuZl1fPp/IxgK/E6IeiyaOt9QY4m5rn9eG5Q82FHYJT+2UkM8yihXMtulTo
	 8c35XuA2VNiunPTbIuCDYDtABXRzC9llAv5UdQlmRQ3hyfFKJRzN71DzHNIXeMPN72
	 A4eKfz2bunFyLNKrDxpbU8YceUifIqsNeHhxe6MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 325/512] iio: filter: admv8818: fix integer overflow
Date: Tue, 17 Jun 2025 17:24:51 +0200
Message-ID: <20250617152432.769405194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



