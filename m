Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3000118C91F;
	Tue, 30 Jul 2024 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355528; cv=none; b=PLmeJ1DNL+jP1kApTOpo12cPP4Iz/VkATWxB7b6hTiFL/BLVnczD3dpDbSb+7o2C4+H0WEfaiI7zXSxK8LGFaZn0dJcAVnZhbcH8GP0/QzljxI7JAAq156cRZQKxr/0Tje3VGtbdupeqrkdPjeqbTdhj07MrjOM42RAmw4UNko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355528; c=relaxed/simple;
	bh=SyRuPbDSj+zTDZL6b+o17QyAQ702hraxKml3c++5NwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOaESEQSv4jey+A5vV2JdsKlj0OTk7v+G+yJQfIXlDM7AocdAY1F8Fm/U1KrH1VOcm79unHkJ44cquOKWktNo3skTmrjylumyeESMweIGGj5UqOa6QMR3QaAX01Wsd/BI+X1RxGnS3IWZY1K62z0OaaPnNTZUcyNSlifiXTl1Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mz8le5L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mz8le5L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E92C32782;
	Tue, 30 Jul 2024 16:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355527;
	bh=SyRuPbDSj+zTDZL6b+o17QyAQ702hraxKml3c++5NwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz8le5L2Z4bhDzmT/wWodRLY/0lofD247epTWzpUOWBQj2FsbTFnbqrNIn1jMy5Gi
	 JfUw/ei9yAcBeJvxWA0Qhf03e4ZiqkrP8oRvIN0mz/7k1lx6Xx02ItNaFO2uFcr+7j
	 phbfiC5OJPFT37dcHo4RAtrmJATY3mwZhkGX03vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 063/809] OPP: Fix missing cleanup on error in _opp_attach_genpd()
Date: Tue, 30 Jul 2024 17:38:59 +0200
Message-ID: <20240730151727.133298669@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit d86a2f0800683652004490c590b4b96a63e7fc04 ]

A recent commit updated the code mistakenly to return directly on
errors, without doing the required cleanups. Fix it.

Fixes: 2a56c462fe5a ("OPP: Fix required_opp_tables for multiple genpds using same table")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202405180016.4fbn86bm-lkp@intel.com/
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index cb4611fe1b5b2..4e4d293bf5b10 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2443,8 +2443,10 @@ static int _opp_attach_genpd(struct opp_table *opp_table, struct device *dev,
 		 * Cross check it again and fix if required.
 		 */
 		gdev = dev_to_genpd_dev(virt_dev);
-		if (IS_ERR(gdev))
-			return PTR_ERR(gdev);
+		if (IS_ERR(gdev)) {
+			ret = PTR_ERR(gdev);
+			goto err;
+		}
 
 		genpd_table = _find_opp_table(gdev);
 		if (!IS_ERR(genpd_table)) {
-- 
2.43.0



