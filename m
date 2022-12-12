Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A03C433F1;
	Mon, 12 Dec 2022 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852308;
	bh=P7A2QBzDkilDUUi7RCnLBhrn9bEaUQ/D3QSuZQ64mlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZfNuN9wJFaw7/stoIerG5PVAQbEBUxh/rDhuab4u0z/MOCy1trnOsuqFPq1B9gOu
	 y8RK2MdPH0TGI0O4AHCJxy1GtZ6Rxt7aQPLJNcuoXF7YQrCVVShfBL9R7Qh574mufi
	 9a2oE3TpGt3u19W2FJO6wWW8A/JwLGaYEBREVIA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Chao Song <chao.song@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 055/157] soundwire: intel: Initialize clock stop timeout
Date: Mon, 12 Dec 2022 14:16:43 +0100
Message-Id: <20221212130936.771461078@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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
@@ -1307,6 +1307,7 @@ static int intel_link_probe(struct auxil
 	cdns->msg_count = 0;
 
 	bus->link_id = auxdev->id;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 


