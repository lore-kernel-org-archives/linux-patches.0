Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C20617AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1632C433CB;
	Wed,  9 Aug 2023 11:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581331;
	bh=qj4JVP/Sr8qjVGEhUQQ/zqaS5duXdJP3OPj+7OdIvSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQBuk5oUTwnUQoIYD2bcVPfz9M6aQYO8O8UPMo5N7hxS492Q/nEVSniuG66nwS31e
	 bbAKCvgEHqc+Ccw7Bp/hSLylBQ53moQqxw1xyu88bcl3m8Ae60dTr/SM5YfqySnGdl
	 udQdgrzDgawHEb0tDq8cgdDQenrXbT56v8Z/OLi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Chao Song <chao.song@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/201] soundwire: bus: add better dev_dbg to track complete() calls
Date: Wed,  9 Aug 2023 12:43:10 +0200
Message-ID: <20230809103650.106720412@linuxfoundation.org>
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

[ Upstream commit f1b690261247c9895f7a4b05d14a4026739134eb ]

Add a dev_dbg() log for both enumeration and initialization completion
to better track suspend-resume issues.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Chao Song <chao.song@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210126085402.4264-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c40d6b3249b1 ("soundwire: fix enumeration completion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 3317a02bcc170..9c7c8fa7f53e4 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -797,7 +797,7 @@ static void sdw_modify_slave_status(struct sdw_slave *slave,
 
 	if (status == SDW_SLAVE_UNATTACHED) {
 		dev_dbg(&slave->dev,
-			"%s: initializing completion for Slave %d\n",
+			"%s: initializing enumeration and init completion for Slave %d\n",
 			__func__, slave->dev_num);
 
 		init_completion(&slave->enumeration_complete);
@@ -806,7 +806,7 @@ static void sdw_modify_slave_status(struct sdw_slave *slave,
 	} else if ((status == SDW_SLAVE_ATTACHED) &&
 		   (slave->status == SDW_SLAVE_UNATTACHED)) {
 		dev_dbg(&slave->dev,
-			"%s: signaling completion for Slave %d\n",
+			"%s: signaling enumeration completion for Slave %d\n",
 			__func__, slave->dev_num);
 
 		complete(&slave->enumeration_complete);
@@ -1734,8 +1734,13 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 		if (ret)
 			dev_err(slave->bus->dev,
 				"Update Slave status failed:%d\n", ret);
-		if (attached_initializing)
+		if (attached_initializing) {
+			dev_dbg(&slave->dev,
+				"%s: signaling initialization completion for Slave %d\n",
+				__func__, slave->dev_num);
+
 			complete(&slave->initialization_complete);
+		}
 	}
 
 	return ret;
-- 
2.40.1



