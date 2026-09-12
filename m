Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36413793CA;
	Sat, 12 Sep 2026 18:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239308; cv=none; b=qyuFp/Cd1HaUjvoFbCIwHkzaHIfnVaZbBVbHXzz8bDVu4rnLicK+ClVkj5iRi6v3NhDo4Z7IEuD2+3wW6YV4zBh+NoMQtDZ3Bnvl+3yj8XyeK/LycR1SmVywoaXyJi2feF0p2v8YCavGl+WxQAUsheqbfxm5WgH2LQPBcNECr/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239308; c=relaxed/simple;
	bh=HchZhY53sE7r3nLuKDwr5JcdlrKvkYxNsd2Na+uuwKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1qUSMtXFE8zg+Qu2hyf4qTahfFjPNUSVtKsKNKnY7zeFASJ31JO5t0dsD5Yq/E4YX72u3mz1fnTdpgBTMZ3PL3+Bcp8BMSjrvuOPoKx+b8qDOfrWAzi4jQ7Xbfp24a8GeSHHBiRke0GEEytNOgeI5YwJ1t4bE9tfZPOGhAYaPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Muyu1ECp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Muyu1ECp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD941F000FF;
	Sat, 12 Sep 2026 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239306;
	bh=fW2AZj/GwMhU4EbX571FgQfzW9y7slTVYAYFXVTG1qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Muyu1ECpEhbwGi4rTAkJuaRdi+KNM/ZF54cVGwXPxt+8yeNuxygs2QmYpB2qg9xXQ
	 CtPIFOG1+O86kWvt0dqzMP7H9C0EC/2L+I6fi1Bz47vnmCRihtmTDS6MehRA3HkDVz
	 JaKMt/eIJ261Sw9HmVxrpz06TNE6o8Nv0vGkzur8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/935] clk: qcom: Return expected ENOMEM error on dynamic allocation failure
Date: Sat, 12 Sep 2026 09:01:09 +0200
Message-ID: <20260912065541.497903049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 22d9257f08913b6eec3e8ece4d13d9c41f14428b ]

If a dynamic memory allocation fails, the returned error code in clock
controller driver probe functions on a few legacy platforms should be
set to -ENOMEM instead of -EINVAL.

Fixes: ee15faffef11 ("clk: qcom: common: Add API to register board clocks backwards compatibly")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260629162127.3910603-1-vz@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 8aef7749f167d..7a5a5d1e0e205 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -148,7 +148,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (!node) {
 		fixed = devm_kzalloc(dev, sizeof(*fixed), GFP_KERNEL);
 		if (!fixed)
-			return -EINVAL;
+			return -ENOMEM;
 
 		fixed->fixed_rate = rate;
 		fixed->hw.init = &init_data;
@@ -165,7 +165,7 @@ static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
 	if (add_factor) {
 		factor = devm_kzalloc(dev, sizeof(*factor), GFP_KERNEL);
 		if (!factor)
-			return -EINVAL;
+			return -ENOMEM;
 
 		factor->mult = factor->div = 1;
 		factor->hw.init = &init_data;
-- 
2.53.0



