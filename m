Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625F28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B42CC433EF;
	Mon, 12 Dec 2022 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851635;
	bh=e7RZMR8jkpPuqmVbMV0PGR1OVbAhBbvQrRXJ2OnHq/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ4TEw9xqhXB9tphkGl64qXGoIL1j4F8xAAMnBT4VgErvwNwTPiPCRTpl6gAQI/z2
	 CGY7Gei/KtBZ/thF7KKDavAhRLLE9JOP4yR47WRDtI8T1bxt4cqJRwBMgXX3Izqmdg
	 mKnMRsHszTwzQaOKMWlqlYCb7xmg1feC5yN2SvIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Chao Song <chao.song@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 040/123] soundwire: intel: Initialize clock stop timeout
Date: Mon, 12 Dec 2022 14:16:46 +0100
Message-Id: <20221212130928.597470166@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sjoerd Simons <sjoerd@collabora.com>

commit 13c30a755847c7e804e1bf755e66e3ff7b7f9367 upstream.

The bus->clk_stop_timeout member is only initialized to a non-zero value
during the codec driver probe. This can lead to corner cases where this
value remains pegged at zero when the bus suspends, which results in an
endless loop in sdw_bus_wait_for_clk_prep_deprep().

Corner cases include configurations with no codecs described in the
firmware, or delays in probing codec drivers.

Initializing the default timeout to the smallest non-zero value avoid this
problem and allows for the existing logic to be preserved: the
bus->clk_stop_timeout is set as the maximum required by all codecs
connected on the bus.

Fixes: 1f2dcf3a154ac ("soundwire: intel: set dev_num_ida_min")
Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221020015624.1703950-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1285,6 +1285,7 @@ static int intel_link_probe(struct auxil
 	cdns->msg_count = 0;
 
 	bus->link_id = auxdev->id;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 


