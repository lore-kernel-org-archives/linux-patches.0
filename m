Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F65522A;
	Wed,  5 Feb 2025 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765086; cv=none; b=MPTjaT952hlci3nxGqnEKuOmNKUsxjP4mAXX3Lm3fcAEE+DRqOaGVypmJK5HiVC1CmKrraPmZPTeWkkVj+2pT/9Hvc52C3qsrMsiWZExAQgWMkxUI3pFEwnw4yW5+bsmcRWTp27E4JBea8ayFQyfTNX+ARCVTZunXwDkoVpz+wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765086; c=relaxed/simple;
	bh=1Ql/qXH+e4jvTjVOSQUKuaMZCPfeXebpj06HS7+PPqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ftb04o9M2fg6YvLEwsAyhpcjQXuGFKdn0jW3MzBhHz1I8VJZnitjJeb47rVstVE13f0GQnnk4vqzb1/NgInXet/MSxM+4ZQqLanF0r9n4NTpG8AHrWNzRaSojXLrOkwWDIyzJORl09JzX2o+9tgVGJwB9lsNcnopAre+AlsUVDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/nXwZ+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/nXwZ+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7900C4CED6;
	Wed,  5 Feb 2025 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765086;
	bh=1Ql/qXH+e4jvTjVOSQUKuaMZCPfeXebpj06HS7+PPqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/nXwZ+/jDruFivMf2KPbUG+548PRC1a0T67vY3abW00aNz0Ocd7E2pJAgY5vETW1
	 CmN/M5HRF30Vallonve066zgX0nhkrqUQdMHnEJHCX8BiVl405Q26rFOY8EeuvRy9F
	 Ienv+5ZRdSTbsZOJJLP6HfKTdtmuA10G3r7oZFXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 142/623] OPP: OF: Fix an OF node leak in _opp_add_static_v2()
Date: Wed,  5 Feb 2025 14:38:04 +0100
Message-ID: <20250205134501.666597737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index fd5ed28582588..a24f76f5fd017 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -926,7 +926,7 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 	ret = _of_opp_alloc_required_opps(opp_table, new_opp);
 	if (ret)
-		goto free_opp;
+		goto put_node;
 
 	if (!of_property_read_u32(np, "clock-latency-ns", &val))
 		new_opp->clock_latency_ns = val;
@@ -976,6 +976,8 @@ static struct dev_pm_opp *_opp_add_static_v2(struct opp_table *opp_table,
 
 free_required_opps:
 	_of_opp_free_required_opps(opp_table, new_opp);
+put_node:
+	of_node_put(np);
 free_opp:
 	_opp_free(new_opp);
 
-- 
2.39.5



