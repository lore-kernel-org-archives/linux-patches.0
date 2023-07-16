Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDC48F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE43C433C8;
	Sun, 16 Jul 2023 20:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538858;
	bh=LjF85nLATEdMUduK4886fs5lLswmeglPuDL+uC7ySqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svzb3TVyIHLxQQD7Tyrdgu3bjA9AQg4oK3p6SoiMCHT4VFGPhDLKDsFbIb/sCb80N
	 PWDZNi/K1xFOoXsEklTuuBfQsfNqz+1XKACLkBjLUaeVYWJ+ydXd5VYUTExCrmoHt2
	 7vdMS7OROTN3SGRrVChU0XnvtxX5EmpDff2vrHHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 602/800] coresight: Fix loss of connection info when a module is unloaded
Date: Sun, 16 Jul 2023 21:47:35 +0200
Message-ID: <20230716195003.087436188@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

[ Upstream commit c45b2835e7b205783bdfe08cc98fa86a7c5eeb74 ]

child_fwnode should be a read only property based on the DT or ACPI. If
it's cleared on the parent device when a child is unloaded, then when
the child is loaded again the connection won't be remade.

child_dev should be cleared instead which signifies that the connection
should be remade when the child_fwnode registers a new coresight_device.

Similarly the reference count shouldn't be decremented as long as the
parent device exists. The correct place to drop the reference is in
coresight_release_platform_data() which is already done.

Reproducible on Juno with the following steps:

  # load all coresight modules.
  $ cd /sys/bus/coresight/devices/
  $ echo 1 > tmc_etr0/enable_sink
  $ echo 1 > etm0/enable_source
  # Works fine ^

  $ echo 0 > etm0/enable_source
  $ rmmod coresight-funnel
  $ modprobe coresight-funnel
  $ echo 1 > etm0/enable_source
  -bash: echo: write error: Invalid argument

Fixes: 37ea1ffddffa ("coresight: Use fwnode handle instead of device names")
Fixes: 2af89ebacf29 ("coresight: Clear the connection field properly")
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230425143542.2305069-2-james.clark@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index d3bf82c0de1d8..5733294ce5cd2 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1419,13 +1419,8 @@ static int coresight_remove_match(struct device *dev, void *data)
 		if (csdev->dev.fwnode == conn->child_fwnode) {
 			iterator->orphan = true;
 			coresight_remove_links(iterator, conn);
-			/*
-			 * Drop the reference to the handle for the remote
-			 * device acquired in parsing the connections from
-			 * platform data.
-			 */
-			fwnode_handle_put(conn->child_fwnode);
-			conn->child_fwnode = NULL;
+
+			conn->child_dev = NULL;
 			/* No need to continue */
 			break;
 		}
-- 
2.39.2



