Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C461C3F0A;
	Wed, 19 Feb 2025 09:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956121; cv=none; b=qczHOhu3KEMactnuseDAnTZ+sdW7DJ1hhZjU5C/TZ1Fv48ZDMcRmkOMAvjLlsho7RddL1+6yxsXngyh6r4WKkqNSIgicbwfFqhr/KwtnjEJjScCNoUXvnO6aKRUbhA1H4IJKeKcyRtE946YK2RmrwaRgOM2pjJivqAmwJWNSPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956121; c=relaxed/simple;
	bh=LQUd3N4xx6GfADnAHT3kiYp3+YWhZHq0XLD3Sbs5mpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLxOHSrJs7wod3ccgYvRXuUBZtlj+L5e+oZ8oaOdm3Vo7nqMpTYldUB5azgls8CO3raO9U5NDAJfFeu0eT0tyFi1C1e3OcqVT30f2c3nEkZz0GTo6ENKEIHpSlpzdxzP482Q7EgpFPvhys7orzrcxdpZErBQTdiuvMG40UKTOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtpLqhDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtpLqhDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C721C4CEE6;
	Wed, 19 Feb 2025 09:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956120;
	bh=LQUd3N4xx6GfADnAHT3kiYp3+YWhZHq0XLD3Sbs5mpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtpLqhDOYzbYsczaEYxcfYeZ0UaQ/ddl1R0ZdIWyty8OIEmKncZsvHOb8P9MBDaes
	 NmjtE7O+Tg2DVaz90GykgqatGoE0UpkVFbhvBqWnVZ+bHdrLCtVlsbdAVWK7kmdQqJ
	 UDoyC+vnQvKZKfmANgki16ImBDbxtY2vQEhzwT9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/578] OPP: OF: Fix an OF node leak in _opp_add_static_v2()
Date: Wed, 19 Feb 2025 09:21:14 +0100
Message-ID: <20250219082655.639014756@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 1d38eb7f7b26261a0b642f6e0923269c7c000a97 ]

_opp_add_static_v2() leaks the obtained OF node reference when
_of_opp_alloc_required_opps() fails. Add an of_node_put() call in the
error path.

Fixes: 3466ea2cd6b6 ("OPP: Don't drop opp->np reference while it is still in use")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index 605d68673f928..c1b2d8927845c 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -950,7 +950,7 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	ret = _of_opp_alloc_required_opps(opp_table, new_opp);
 	if (ret)
-		goto free_opp;
+		goto put_node;
 
 	if (!of_property_read_u32(np, "clock-latency-ns", &val))
 		new_opp->clock_latency_ns = val;
@@ -1003,6 +1003,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 free_required_opps:
 	_of_opp_free_required_opps(opp_table, new_opp);
+put_node:
+	of_node_put(np);
 free_opp:
 	_opp_free(new_opp);
 
-- 
2.39.5



