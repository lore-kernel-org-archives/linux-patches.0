Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3C21DE4EF;
	Sat, 12 Sep 2026 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227980; cv=none; b=IbEykCgp9ItPU7bqjrzmVnbbz3oSk0tiCLJz9sN89t55wv0zHt+s6Sm//2STrztcVJ++ysSjCfWKwxSdPzhWXOqnWujPKsISAIWrfe1xqc5a3tqQDt4RWuZ4LZsfs3I8tzZorTnQ/giTlhJqXKUXXzljsrve8s81VScgJLywGtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227980; c=relaxed/simple;
	bh=Lze17Kdy3sWN1vYOogU7Ks1iZ5OOtgcXTnPMjo3GGGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAQhszh3nbDlxGacCCl4LRxEzfSdiylz9ik1kTDUDY7NQPZPjAqR+NFgA+5MP9mR4CrUYQdWRhyAk+HKV+TZPDjpEEB90igbaTPuf13NGf54OA64wy3rs7Cg9p3JlJJmz5Mq3ntBtqZViKIvRB5S3rdTVHH4wriH/L3YoFyyMFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgS+f/sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgS+f/sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455031F000FF;
	Sat, 12 Sep 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227979;
	bh=pkFZiXEsfX1aIIXBzK+328spjtaLKlUpngz+S9ZA3Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgS+f/szPToBGsabxtjVwSDxxMcRQPjgBWUaDOLrP2/L2ue9Qyq2IYpwBxOViF/H8
	 BMp21P7h6XgpGhtlUvsN2q3J64mJstIWISu2zEEE7OwYjLnGjesNfLhQx0yypPUglP
	 VgNkvedd+l+uY748cyrWkmiqHTSMG8NvBK3UmCx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0293/1191] cpuidle: dt_idle_genpd: kfree() the original name allocation
Date: Sat, 12 Sep 2026 08:50:21 +0200
Message-ID: <20260912065554.812122584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


