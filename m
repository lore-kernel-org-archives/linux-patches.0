Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4378BE8;
	Tue, 30 Jul 2024 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355634; cv=none; b=lo5qSTiG2sBQmRNsaP+MrkO0HCZXiQse0kEFr1LkiFZaWm+Tex9pz5UZgMVs1AGZeICcEIzdLTWGGpr2H6VHgXyZBdGalOCSmQuWHqdvMhgChu8nLKk0AO/IaReY6QLaWU+vNFaf00lznE8Dn8K8VPnZlSc8iThhySjyVyk5LUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355634; c=relaxed/simple;
	bh=6QYB/r4W+ldt2NlxwzJPo7sm2xn7jJKdaXzVvWBbJOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmdbrSSoZ0OYGMtLFve76s9JvnO1UFESKstlzLaYB5nkrwCcfpcPFFd/mLPNfrvdg6RN24EojkLub2kVnwCg04Ja5XCbw1JkO/Tv7EpBGeHM1jyd6SZNUxocNrtfVlq559BgS0/CbcKNc+KWJp1J3uyzmWYeXnjAkep/xowr1tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF3Cg565; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF3Cg565"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6A0C32782;
	Tue, 30 Jul 2024 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355634;
	bh=6QYB/r4W+ldt2NlxwzJPo7sm2xn7jJKdaXzVvWBbJOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IF3Cg5654KNA0vfh/f8C8HhK72PKaYAAubWdlLdeTDrkBmniZvF8dxvQOzknT2WvR
	 dm+AHq6DJThn9PAdf+a6eCb5b3ZHKlMLUb1Kpo5+FBexIZtpOwTYJWZlZqrweQipwM
	 eb/FrisU8GLq+2uImGXP3Erophsth7a6pUAvfjwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 073/809] OPP: ti: Fix ti_opp_supply_probe wrong return values
Date: Tue, 30 Jul 2024 17:39:09 +0200
Message-ID: <20240730151727.523587821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 3a1ac6b8f603a9310274990a0ad563a5fb709f59 ]

Function ti_opp_supply_probe() since commit 6baee034cb55 ("OPP: ti:
Migrate to dev_pm_opp_set_config_regulators()") returns wrong values
when all goes well and hence driver probing eventually fails.

Fixes: 6baee034cb55 ("OPP: ti: Migrate to dev_pm_opp_set_config_regulators()")
Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/ti-opp-supply.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/ti-opp-supply.c b/drivers/opp/ti-opp-supply.c
index e3b97cd1fbbf3..ec0056a4bb135 100644
--- a/drivers/opp/ti-opp-supply.c
+++ b/drivers/opp/ti-opp-supply.c
@@ -393,10 +393,12 @@ static int ti_opp_supply_probe(struct platform_device *pdev)
 	}
 
 	ret = dev_pm_opp_set_config_regulators(cpu_dev, ti_opp_config_regulators);
-	if (ret < 0)
+	if (ret < 0) {
 		_free_optimized_voltages(dev, &opp_data);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static struct platform_driver ti_opp_supply_driver = {
-- 
2.43.0



