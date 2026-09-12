Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3DB388397;
	Sat, 12 Sep 2026 19:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242318; cv=none; b=jvCCdh8LIIzbjVaIqxW7h8V7VJ1P6VV8Oi+PyuxZum/uvBaPzezjRrNA5YADUYx5KhFyBmzKwFJ4xtSd3I83kwtCQqCHeSl/IKdysT44pzhWzrbdV0XdLKLI5bcpqeijk8se31p9R6hZdv0YmIY1wRBTQH/XhpYR0TJtPOujFhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242318; c=relaxed/simple;
	bh=QNIuHQvyR/6SbwnZgSQkFpVPF3bthH+XPNQ/kJH5JYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0CK9Wyx26oy7+F1dpZVJcA2oJKoSz3tLv3UJBUcoyK5O1mlHklvN0YOOjTpxmc3QdThim+KwCpxa4hueEp0h87mVsHtDFn8FZqBW71XOU20KipdsPY5qs1N0MyNYu+/feFswddc2K990U59jxb0wKD+e6c9H/lVLTeorgwFfNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4+pHHBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4+pHHBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F0E1F000FF;
	Sat, 12 Sep 2026 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242316;
	bh=VhemMLsmYgj09vOQN3je85JUk7pNyd9CGcQl7eaubNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4+pHHBOiSDRrEwwk/LrVjG5slfFFstvrmqFHjvQbLlirB6cQvFu9mcmg3CKDv3MW
	 HvV9qfDTUDjFrclqf2oIPUwIycn03ktemcvfCSCNCrHjC/qkvZImmv1VtjYsPkMUxB
	 /VOOsfvKtcE1tBifKNlSXhSLfoAWiKI4GerCsFN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/798] soundwire: add static port mapping support
Date: Sat, 12 Sep 2026 08:59:49 +0200
Message-ID: <20260912065525.434115253@linuxfoundation.org>
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

[ Upstream commit f4022062e5417ab7228e95aec1a8687059a19db7 ]

Some of the SoundWire device ports are statically mapped to Controller
ports during design, however there is no way to expose this information
to the controller. Controllers like Qualcomm ones use this info to setup
static bandwidth parameters for those ports.

A generic port allocation is not possible in this cases!
So this patch adds a new member m_port_map to struct sdw_slave to expose
this static map.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210315165650.13392-2-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 6ccec91c3535 ("soundwire: qcom: Fix port exhaustion check in stream_alloc_ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soundwire/sdw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index 57cda3a3a9d95..6136ac212503d 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -610,6 +610,7 @@ struct sdw_slave_ops {
  * @debugfs: Slave debugfs
  * @node: node for bus list
  * @port_ready: Port ready completion flag for each Slave port
+ * @m_port_map: static Master port map for each Slave port
  * @dev_num: Current Device Number, values can be 0 or dev_num_sticky
  * @dev_num_sticky: one-time static Device Number assigned by Bus
  * @probed: boolean tracking driver state
@@ -641,6 +642,7 @@ struct sdw_slave {
 #endif
 	struct list_head node;
 	struct completion port_ready[SDW_MAX_PORTS];
+	unsigned int m_port_map[SDW_MAX_PORTS];
 	enum sdw_clk_stop_mode curr_clk_stop_mode;
 	u16 dev_num;
 	u16 dev_num_sticky;
-- 
2.53.0



