Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5C388397;
	Sat, 12 Sep 2026 19:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242324; cv=none; b=MJg9Dob5RR05LZ2QBlVFe7rwKwhF08e935SBKCXWTfrnPBr7/5BGARjisF9aeT65szNr/XByf2+ZJ1enjnwO6fTNeKaBGnvelYvf8rZ7AfLq8jzl6gdl5PoKxSyd6ymGhWRjONTvq+FxlzTkmjjl0y/KSqfeTcE5pFFNyssP8Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242324; c=relaxed/simple;
	bh=aWoEBWjAvKeOYLKRq8G48nfmOXMNm11zUQo5YhsFdsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPEGw2uMGPhIFxXW3h4iGShK6tHPpPTZXzwvQXNklBZugH6hw92q7O8zVoEIB7S/zRk3XGkGvMtqOgIh9Y/Cbqhapnca3mylMM1p/TDtD/x+HmBh8VWxgC/O/cqtss93mhmidotxAk2Y8EGhxMKEZa9kf41z+hy/G0yzFsTBT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bg/rUHs8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bg/rUHs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88D61F000FF;
	Sat, 12 Sep 2026 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242322;
	bh=F43HSEAlbL1xYWipeMFljjz32vQZNbdSSWcZQGGeg/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bg/rUHs8p6TxpkdPYvdThpdAwLwrRE8g3NLhHT70YMDdyThUCvOvRdfFlUZwrfYB5
	 a/HgtLUubia+tOwrBknBkVZ+IokQzK9vR8pBVzkS7gIeA8Gcuw6eeyf4RSjNQ3U90L
	 AdFK58XlW83aF37HUzH2E3jWEchIrZTWnP3HmTj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/798] soundwire: qcom: add static port map support
Date: Sat, 12 Sep 2026 08:59:51 +0200
Message-ID: <20260912065525.480048849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit eb5a909441a896fe9e230086363284a09c23e5df ]

SoundWire device ports are statically mapped to Controller ports during
design. Add support to read these from SoundWire devices.
This controller uses static port map info to setup bandwidth
parameters for those ports.

A generic port allocation is not possible in this cases!

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210315165650.13392-4-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 6ccec91c3535 ("soundwire: qcom: Fix port exhaustion check in stream_alloc_ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 430448ee25ae8..d4091b6a58d59 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -460,6 +460,8 @@ static int qcom_swrm_compute_params(struct sdw_bus *bus)
 	struct sdw_slave_runtime *s_rt;
 	struct sdw_port_runtime *p_rt;
 	struct qcom_swrm_port_config *pcfg;
+	struct sdw_slave *slave;
+	unsigned int m_port;
 	int i = 0;
 
 	list_for_each_entry(m_rt, &bus->m_rt_list, bus_node) {
@@ -473,8 +475,14 @@ static int qcom_swrm_compute_params(struct sdw_bus *bus)
 		}
 
 		list_for_each_entry(s_rt, &m_rt->slave_rt_list, m_rt_node) {
+			slave = s_rt->slave;
 			list_for_each_entry(p_rt, &s_rt->port_list, port_node) {
-				pcfg = &ctrl->pconfig[i];
+				m_port = slave->m_port_map[p_rt->num];
+				/* port config starts at offset 0 so -1 from actual port number */
+				if (m_port)
+					pcfg = &ctrl->pconfig[m_port - 1];
+				else
+					pcfg = &ctrl->pconfig[i];
 				p_rt->transport_params.port_num = p_rt->num;
 				p_rt->transport_params.sample_interval =
 					pcfg->si + 1;
@@ -535,8 +543,10 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 	struct sdw_master_runtime *m_rt;
 	struct sdw_slave_runtime *s_rt;
 	struct sdw_port_runtime *p_rt;
+	struct sdw_slave *slave;
 	unsigned long *port_mask;
 	int i, maxport, pn, nports = 0, ret = 0;
+	unsigned int m_port;
 
 	mutex_lock(&ctrl->port_lock);
 	list_for_each_entry(m_rt, &stream->master_list, stream_node) {
@@ -549,9 +559,15 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 		}
 
 		list_for_each_entry(s_rt, &m_rt->slave_rt_list, m_rt_node) {
+			slave = s_rt->slave;
 			list_for_each_entry(p_rt, &s_rt->port_list, port_node) {
+				m_port = slave->m_port_map[p_rt->num];
 				/* Port numbers start from 1 - 14*/
-				pn = find_first_zero_bit(port_mask, maxport);
+				if (m_port)
+					pn = m_port;
+				else
+					pn = find_first_zero_bit(port_mask, maxport);
+
 				if (pn > maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					ret = -EBUSY;
-- 
2.53.0



