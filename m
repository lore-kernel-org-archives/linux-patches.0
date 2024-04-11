Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCBC624;
	Thu, 11 Apr 2024 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832487; cv=none; b=FKz6gDrPqHcg122MT8QUAeyeKQJlcqof7Cy+7k8PEpy6/y0IgCsPx+wpmUc8amfCjuY/ew9WkGf0ctkDi+ri6NsI72cci9QmUnF1egOpwY9Mw2LBqJvHNMulPgjSGJ71MONxi2IeXBCmgy2ixntutuSzwr6SXkSqGbxqDJqALTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832487; c=relaxed/simple;
	bh=jhqAz2YVuA7GpbS4Fj6ORXSRFXwgSmT4yxym6d6mhvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+eBXYREZpM6rRb/dBZWr5tPA5bwKddBQGfOzs5O/a4N2yHcKIP/Sja8bD9pwqUSda9p5yJMylRxJ+L6S6WnsAa4Md+NrTxmyx8cTxf87vUuH3Y7pHZrduSzeO82nmnasl3rTXzjPJ37/CWfVJ9YrdyBo8xQkL139oJ5JvD0fcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3bPPvud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3bPPvud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A061BC433F1;
	Thu, 11 Apr 2024 10:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832487;
	bh=jhqAz2YVuA7GpbS4Fj6ORXSRFXwgSmT4yxym6d6mhvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3bPPvudDqmwgsprYz8GQIhBmIM9q0HDkG1SPjEnPWQnFgfu1t3kmi2jgZsRjKEOb
	 YqJdDrt9Jz0diwwcV2X+tH+TvC9jsOzVtL3NQ2kNzQ9bVEn8SPFbVe9c8Ui/lI8ITs
	 0HaIDw/3RH7llTQiyehGf20u5K/wIN+sKXoM7RGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 64/83] ASoC: soc-core.c: Skip dummy codec when adding platforms
Date: Thu, 11 Apr 2024 11:57:36 +0200
Message-ID: <20240411095414.611457932@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 23fb6bc2696119391ec3a92ccaffe50e567c515e ]

When pcm_runtime is adding platform components it will scan all
registered components. In case of DPCM FE/BE some DAI links will
configure dummy platform. However both dummy codec and dummy platform
are using "snd-soc-dummy" as component->name. Dummy codec should be
skipped when adding platforms otherwise there'll be overflow and UBSAN
complains.

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://msgid.link/r/20240305065606.3778642-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a409fbed8f34c..6a4101dc15a54 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1020,6 +1020,9 @@ int snd_soc_add_pcm_runtime(struct snd_soc_card *card,
 			if (!snd_soc_is_matching_component(platform, component))
 				continue;
 
+			if (snd_soc_component_is_dummy(component) && component->num_dai)
+				continue;
+
 			snd_soc_rtd_add_component(rtd, component);
 		}
 	}
-- 
2.43.0



