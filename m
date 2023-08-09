Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5C04680
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1651C433C9;
	Wed,  9 Aug 2023 11:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581334;
	bh=Mv2pNaHu4Cx66qpLi1aOltxcNhGJc1vUZWxXa9wdbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS2jXid7naYCjWWezftE7ldTGeiPzAkvIJr9ye76pN3ooSobudoBAvju41A+mcOtu
	 jhmNamUaOOikMBjgVIu5A53PpPzhJ0nqjUGQYJVUX/56mHAh7eiEPeuP1LDAuRW3H0
	 jcg9R8JyQMG0NKQLyRfY4EZHtJtI3uw1P/FV2CX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/201] soundwire: bus: pm_runtime_request_resume on peripheral attachment
Date: Wed,  9 Aug 2023 12:43:11 +0200
Message-ID: <20230809103650.143794171@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit e557bca49b812908f380c56b5b4b2f273848b676 ]

In typical use cases, the peripheral becomes pm_runtime active as a
result of the ALSA/ASoC framework starting up a DAI. The parent/child
hierarchy guarantees that the manager device will be fully resumed
beforehand.

There is however a corner case where the manager device may become
pm_runtime active, but without ALSA/ASoC requesting any functionality
from the peripherals. In this case, the hardware peripheral device
will report as ATTACHED and its initialization routine will be
executed. If this initialization routine initiates any sort of
deferred processing, there is a possibility that the manager could
suspend without the peripheral suspend sequence being invoked: from
the pm_runtime framework perspective, the peripheral is *already*
suspended.

To avoid such disconnects between hardware state and pm_runtime state,
this patch adds an asynchronous pm_request_resume() upon successful
attach/initialization which will result in the proper resume/suspend
sequence to be followed on the peripheral side.

BugLink: https://github.com/thesofproject/linux/issues/3459
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220420023241.14335-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c40d6b3249b1 ("soundwire: fix enumeration completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 9c7c8fa7f53e4..831d2d751d5de 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1740,6 +1740,18 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 				__func__, slave->dev_num);
 
 			complete(&slave->initialization_complete);
+
+			/*
+			 * If the manager became pm_runtime active, the peripherals will be
+			 * restarted and attach, but their pm_runtime status may remain
+			 * suspended. If the 'update_slave_status' callback initiates
+			 * any sort of deferred processing, this processing would not be
+			 * cancelled on pm_runtime suspend.
+			 * To avoid such zombie states, we queue a request to resume.
+			 * This would be a no-op in case the peripheral was being resumed
+			 * by e.g. the ALSA/ASoC framework.
+			 */
+			pm_request_resume(&slave->dev);
 		}
 	}
 
-- 
2.40.1



