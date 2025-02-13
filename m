Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B321487FA;
	Thu, 13 Feb 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458919; cv=none; b=f7ZzPGqSejDzlEblFpzSIc6TipynajZJQjpJcRhEKZEf1UtKxjAPfqDqmYskEdidVaHGNhc3BnGb3pELH/JtiIXrnibDOMc+tswswYiNaZnVNIN4lVxRtt5IB28FB+5lQ0RsqoHDt5LGUGcWEUTEVxWdjXRPjveKRBcVUn8b+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458919; c=relaxed/simple;
	bh=L8HJYjMc0AFqo/K42f42dTjTESLFvHWspnK3YlyPpTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gieabO694AqN+A78Ct0JLs19176yRcABz2e2G0tAfT8eh6pmJqdwFZaCnSoAaUkPq7cao5PleFkHalZFWhrMs3RVnmsj5PrkMAePsImj/TOxmdR+ehAAzBkKQl6nVCv4aXLJ1r4CBkuJNXE6ElymUanNZNn7VWkMcPQtkyOTjGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u+sfph4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u+sfph4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4126BC4CED1;
	Thu, 13 Feb 2025 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458919;
	bh=L8HJYjMc0AFqo/K42f42dTjTESLFvHWspnK3YlyPpTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0u+sfph4fF18wiy6xnvRs4eURRHLKTQqYUx9ZiajFmXDKR6D+dNXx6BklNmXDDHhD
	 tuN+od7YuT2ZxXLAGuiAWawpAeKt0pleLuYQnT6xNGdnS27nCD9WZb/Ufyl4bS46RM
	 oVRt151UgoYm2cF2/rA58ybUIyw/cYxlfGEcaI4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 116/443] ice: Add check for devm_kzalloc()
Date: Thu, 13 Feb 2025 15:24:41 +0100
Message-ID: <20250213142445.088897865@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit a8aa6a6ddce9b5585f2b74f27f3feea1427fb4e7 ]

Add check for the return value of devm_kzalloc() to guarantee the success
of allocation.

Fixes: 42c2eb6b1f43 ("ice: Implement devlink-rate API")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250131013832.24805-1-jiashengjiangcool@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink.c b/drivers/net/ethernet/intel/ice/devlink/devlink.c
index 415445cefdb2a..b1efd287b3309 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink.c
@@ -977,6 +977,9 @@ static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv
 
 	/* preallocate memory for ice_sched_node */
 	node = devm_kzalloc(ice_hw_to_dev(pi->hw), sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
 	*priv = node;
 
 	return 0;
-- 
2.39.5



