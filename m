Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC90A523781;
	Wed,  9 Sep 2026 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961933; cv=none; b=Yni8/1QFRvaV9zR10Og+vIssEIyvtKW90JIiiBjYAT6aml0gqAhZDekdzwiU75XkEd1yUrQTSCY9/ze/yVzV6XTejyF8D5C63F2gb+Bm06hbhhNyNbjXwwbfC5ZnLqAhTAmFXuViZWB0eEDlNP1FjRvELrBvsg/Jt9HC+63UGfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961933; c=relaxed/simple;
	bh=vFl5aYUtPT8z6EMZ+/gzA36fMw+HnFzRpOs4MlD/nJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo3tT/7IM+6nUEHPkacrrx04IOdDy5ifuJPilfc60M/+Ime8q7PNEsu9cs95uCLLgbFi1Wxe6shXs27Cbt+TePxg0IuiVGHfwqeJAp/i/qb3uahtQkU4u1RN/92+Vv5F9RdOO7b6dz6RvcX1m681ipQj+l6L7V3/TPG7fsPABTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcLGiyh4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcLGiyh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFF21F00A3A;
	Wed,  9 Sep 2026 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961931;
	bh=XFkdIlLfJ52zbG0B+RdBOIvuvb+KZWJLjQh9XhIUJa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcLGiyh4LKLVNIyvsBWZiafwE2G9HvmD+KnlXgnJHUgiLXVZqTOZHsXqksuEwP/2a
	 2dN6TByd3BmumNk2dpGmEWJZPURAUZov/+LiPjY6+d6e+xL4ZvjGjtm9GcvqbjQWDQ
	 79y7fpufqjFYk0Xcbq1TYvXVOqIK+ZwGmjaPVQPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 114/556] cpuidle: dt_idle_genpd: kfree() the original name allocation
Date: Wed,  9 Sep 2026 15:36:34 +0200
Message-ID: <20260909134234.484926533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 2b0ac85512b7f67479127b2713254490662eb13d upstream.

dt_idle_pd_alloc() kasprintf()s the full node path, then points
pd->name at kbasename() of that string. dt_idle_pd_free() kfree()s
pd->name, which is no longer the start of the allocation.

Copy the basename instead.

Fixes: 9d976d6721df ("cpuidle: Factor-out power domain related code from PSCI domain driver")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/dt_idle_genpd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/cpuidle/dt_idle_genpd.c
+++ b/drivers/cpuidle/dt_idle_genpd.c
@@ -99,7 +99,7 @@ struct generic_pm_domain *dt_idle_pd_all
 	if (!pd)
 		goto out;
 
-	pd->name = kasprintf(GFP_KERNEL, "%pOF", np);
+	pd->name = kstrdup(kbasename(of_node_full_name(np)), GFP_KERNEL);
 	if (!pd->name)
 		goto free_pd;
 
@@ -112,7 +112,6 @@ struct generic_pm_domain *dt_idle_pd_all
 		goto free_name;
 
 	pd->free_states = pd_free_states;
-	pd->name = kbasename(pd->name);
 	pd->states = states;
 	pd->state_count = state_count;
 


