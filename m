Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E7D1A76B7;
	Thu, 15 Aug 2024 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730866; cv=none; b=JxvDnIqq4cCxbJ49LefIX/P3e+8dI7F9GZtfZxHkF37DLiFR+qqFBODQ2+NooMOej5UyyMqa0yuYc5yT+2YQNJmcEeHFU60QSVSVo/83C/DaXCJvIONkx58y4WyWfLegz8FBdvxkiVDyzRMhN2BFXzGmi9VHDjTgj292/ZxL1WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730866; c=relaxed/simple;
	bh=3CS/A/m/K+GQuHGgeRVdy/ABg8ggzq0sbWwXpXI5tkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DN+xtBtsC5yr0iS7DUKr6BMQONdFSS8cccyPU8dsGAoxpL0UlmPyFFXtxov7PMx231ia61wjqj4oAb1R8e7jdmxzAmQ6Oj1Q/zbME4JMVcjVshnFWcvnBU4MJA2umxqMtp8CraZP6Bf7oAGSLFTqRg5t6MFXLmbRKRdmKA8QeDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc/ADwaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc/ADwaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFEC32786;
	Thu, 15 Aug 2024 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730866;
	bh=3CS/A/m/K+GQuHGgeRVdy/ABg8ggzq0sbWwXpXI5tkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc/ADwaSshoN6pgxtw4N8OvBou+DVxlnsa3I6m6CIVOP1CvvaO29GSrRRhuJSZHcn
	 +qzU12tOEWzccln38rGXXyR9TA4hWpg/60XQT4W913mYozFQdLaoVWP0uz0gflpIJs
	 hccDl6x/rTYDdfP4B9Ol5RwXsWIrfpk/qQM3o1Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 03/67] ASoC: topology: Fix route memory corruption
Date: Thu, 15 Aug 2024 15:25:17 +0200
Message-ID: <20240815131838.446637528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit 0298f51652be47b79780833e0b63194e1231fa34 upstream.

It was reported that recent fix for memory corruption during topology
load, causes corruption in other cases. Instead of being overeager with
checking topology, assume that it is properly formatted and just
duplicate strings.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Closes: https://lore.kernel.org/linux-sound/171812236450.201359.3019210915105428447.b4-ty@kernel.org/T/#m8c4bd5abf453960fde6f826c4b7f84881da63e9d
Suggested-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240613090126.841189-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-topology.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1052,21 +1052,15 @@ static int soc_tplg_dapm_graph_elems_loa
 			break;
 		}
 
-		route->source = devm_kmemdup(tplg->dev, elem->source,
-					     min(strlen(elem->source), maxlen),
-					     GFP_KERNEL);
-		route->sink = devm_kmemdup(tplg->dev, elem->sink,
-					   min(strlen(elem->sink), maxlen),
-					   GFP_KERNEL);
+		route->source = devm_kstrdup(tplg->dev, elem->source, GFP_KERNEL);
+		route->sink = devm_kstrdup(tplg->dev, elem->sink, GFP_KERNEL);
 		if (!route->source || !route->sink) {
 			ret = -ENOMEM;
 			break;
 		}
 
 		if (strnlen(elem->control, maxlen) != 0) {
-			route->control = devm_kmemdup(tplg->dev, elem->control,
-						      min(strlen(elem->control), maxlen),
-						      GFP_KERNEL);
+			route->control = devm_kstrdup(tplg->dev, elem->control, GFP_KERNEL);
 			if (!route->control) {
 				ret = -ENOMEM;
 				break;


