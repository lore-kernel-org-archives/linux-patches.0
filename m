Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1F923B600;
	Tue, 17 Jun 2025 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178633; cv=none; b=Jlw4c32zzngs8N44EKbn2SrPrR9dYZc6Y7YwqFFWDF5TId9JFqWxG12ufuDovb6MITwsrgAbT6Vba8hnGH2RBmFnr94agA0ekygFf8HbVJvnvC6/o0Z0FbOzml1/cmLu3xag5DKIujI4H1kQeQg9zyu9zHtNVeN0D6fgak3VtS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178633; c=relaxed/simple;
	bh=2ilIhE20stBjkj5lYd571e5ar7eLzUdJ7UykSqKGZ0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ho1RuUGO70gP2gU65HzS2rhzvhQYk0GLIPCOA5bi1WeLz3L2zmF7viXQg5cmvoJBBoopDkCs0Vs0uYGrtqyVF8dyOhKrfN3qdgRztxflV7xKQUcDr1zi1joJ7fPaJJF2CcL6fKY7P/JyPh7La8JsCEXHJdTPjJlPp0FW1mTNsvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKU7fNG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKU7fNG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E9AC4CEE3;
	Tue, 17 Jun 2025 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178633;
	bh=2ilIhE20stBjkj5lYd571e5ar7eLzUdJ7UykSqKGZ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKU7fNG5j7rPdQ3niiIuLz08vIvH9U2ZEZLW+wugVeJuNuvhfJYAFYYd1ojfT6VVi
	 Q6McjVjE9vzAACMMJrbsBrWh3ZKfQ9sVcFbuMy205HWTcrw3TOVMlzcniTONm0w4X9
	 qjrDO5ya2/MlQgXx/71f42Hdg/y6sDUm0PIi4SK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 505/780] soundwire: only compute port params in specific stream states
Date: Tue, 17 Jun 2025 17:23:33 +0200
Message-ID: <20250617152512.062495193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 62ada17a6217a50fbd1b23f10899890f56effc97 ]

Currently, sdw_compute_master_ports() is blindly called for every single
Manager runtime. However, we should not take into account the stream's
bandwidth if the stream is just allocated or already deprepared.

Fixes: 25befdf32aa4 ("soundwire: generic_bandwidth_allocation: count the bandwidth of active streams only")
Link: https://github.com/thesofproject/linux/issues/5398
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20250508062029.6596-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/generic_bandwidth_allocation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index 1cfaccf43eac5..c18f0c16f9297 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -204,6 +204,13 @@ static void _sdw_compute_port_params(struct sdw_bus *bus,
 			port_bo = 1;
 
 			list_for_each_entry(m_rt, &bus->m_rt_list, bus_node) {
+				/*
+				 * Only runtimes with CONFIGURED, PREPARED, ENABLED, and DISABLED
+				 * states should be included in the bandwidth calculation.
+				 */
+				if (m_rt->stream->state > SDW_STREAM_DISABLED ||
+				    m_rt->stream->state < SDW_STREAM_CONFIGURED)
+					continue;
 				sdw_compute_master_ports(m_rt, &params[i], &port_bo, hstop);
 			}
 
-- 
2.39.5



