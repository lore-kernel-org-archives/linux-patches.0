Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3625142E86;
	Wed,  5 Feb 2025 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763674; cv=none; b=XFA4vHahRr+K+JX0gI8L0+eGR+wyxWMk7GQnMdQ3l/N3i6GhqDvmqmc9zWJhMy+ocAqZmVG31q6UuPm6yqKuoWCGHp5BHM5jGw0Hk7yZiduRFf2XYRs6WyeCUKAFKnHNRG5nqHS5SGdu4IeV9my9QGSZkFF72nZPheHxVJQhZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763674; c=relaxed/simple;
	bh=gTzFqZPGFu+y06ukQAMZEkAunfVrxWJZ9wtKuDsl91Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeMxusS+pielPPyzM51o3A+Bk3wiGXpvd4fHCchs4p2Qh9UsKUVguNXNqwqXQDm1GVZSXqETPXjPzFvqBsM2/VdeV0LKuoXRatvpPi7g3dqMap7S2P4p3dYGV20Gz5qy3h9MnUkRUuUo5mxAahIct1AM9OcQXcnsor8UzLl/gmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9mWJupS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9mWJupS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460CEC4CED1;
	Wed,  5 Feb 2025 13:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763673;
	bh=gTzFqZPGFu+y06ukQAMZEkAunfVrxWJZ9wtKuDsl91Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9mWJupS4xNjDR0a6/NUuT5f2vdT76HcAILI/TeKd1mNswAnExi6AqaHqTLvzi16c
	 T9hUT1a8Sxks2yLfvA9GhauhMBXT8WqPHbRVCUw2deph6QZU7JzzaPCjtm6P7zQRla
	 4XcC3x4JQ+5Jw25Ti1/zlJd6QwBB629ZcxUUQc0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/393] OPP: OF: Fix an OF node leak in _opp_add_static_v2()
Date: Wed,  5 Feb 2025 14:40:14 +0100
Message-ID: <20250205134423.930154820@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ada4963c7cfae..657c08d0ad979 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -932,7 +932,7 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	ret = _of_opp_alloc_required_opps(opp_table, new_opp);
 	if (ret)
-		goto free_opp;
+		goto put_node;
 
 	if (!of_property_read_u32(np, "clock-latency-ns", &val))
 		new_opp->clock_latency_ns = val;
@@ -982,6 +982,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 free_required_opps:
 	_of_opp_free_required_opps(opp_table, new_opp);
+put_node:
+	of_node_put(np);
 free_opp:
 	_opp_free(new_opp);
 
-- 
2.39.5



