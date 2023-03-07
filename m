Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B85BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5EFC433D2;
	Tue,  7 Mar 2023 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215490;
	bh=//lWqUVWj5hupHS3Upx1ro8nwDSzbBIXosuSI8Xr7vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/xRblQZomARmLyy7tRmpMp+Eadc5zpn+eWWnsR6rPD2C5/zZT85ipZ7Ii+l+MadM
	 l06cN73DfcN3ZcA2r/rkFBX22hQhgGCEx3+mqbE5GMs1jEP6zmDyJ+cXitEWlrsJuU
	 WQxBOBPtxPW9CRhPzcR3WVrZHoKbNqH/ufe3ckLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/567] soundwire: cadence: Dont overflow the command FIFOs
Date: Tue,  7 Mar 2023 18:00:14 +0100
Message-Id: <20230307165917.949785057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7cbfee2e2e40d2be54196362a845a3ea0a3f877d ]

The command FIFOs in the Cadence IP can be configured during design
up to 32 entries, and the code in cadence_master.c was assuming the
full 32-entry FIFO. But all current Intel implementations use an 8-entry
FIFO.

Up to now the longest message used was 6 entries so this wasn't
causing any problem. But future Cirrus Logic codecs have downloadable
firmware or tuning blobs. It is more efficient for the codec driver to
issue long transfers that can take advantage of any queuing in the
Soundwire controller and avoid the overhead of repeatedly writing the
page registers.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Fixes: 2f52a5177caa ("soundwire: cdns: Add cadence library")
Link: https://lore.kernel.org/r/20221202161812.4186897-2-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 18d2f9b3e2010..0339e6df6eb78 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -127,7 +127,8 @@ MODULE_PARM_DESC(cdns_mcp_int_mask, "Cadence MCP IntMask");
 
 #define CDNS_MCP_CMD_BASE			0x80
 #define CDNS_MCP_RESP_BASE			0x80
-#define CDNS_MCP_CMD_LEN			0x20
+/* FIFO can hold 8 commands */
+#define CDNS_MCP_CMD_LEN			8
 #define CDNS_MCP_CMD_WORD_LEN			0x4
 
 #define CDNS_MCP_CMD_SSP_TAG			BIT(31)
-- 
2.39.2



