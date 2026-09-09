Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3125783C;
	Wed,  9 Sep 2026 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963430; cv=none; b=qfCGTmAGb6RgDWgZV5eJ8IoU0wUUF6TYpAsqHf0ZfiWosLkjGq1kHOhewYM1cJe+besTXlb/NvaR1TqaV5rMDOM2XTCL1siHhR1N3pHImPUWzEg54wLaQQLaJHDBew10BkCh/ie6OtqEVTOxai1aziPrw9XHKZ7ELa10bcDXOpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963430; c=relaxed/simple;
	bh=cmf+5j7Ezi0Z9+7o4hA7JGacL0lANhBavpIV2S1+M3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx7pocgQyAwJZRdP7MiiomK8ROVK0h+I0zBDE9QXHbddE6anGUwWofTnzuuEB4wSyMqmK36pI8Y6zlKgLnB9irk1/Ajmfl4OuLf6qyjOoIFNHtfHhSxPzeiMT0xPMjS9FFteFvmQJLtgcQKAIkxQBcpMLEL8XgpAhJ8UPY8a39U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jq23dpn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jq23dpn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A849E1F00A3A;
	Wed,  9 Sep 2026 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963429;
	bh=tyLMlhssXAr17L2AGjLVfjL8bQX3uo1ktu36A49YKg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jq23dpn5tB2r99BAGMCs1TsV1GJzRzr3lP19MvlLrfnDqfdUIhb3+1HB6L+76Fcxn
	 OU7lEVO1OfJwjiSjDeeYHyFhfJWYZlX1NCnMZwDfJH193XnPWlY8gNNgAIA/wszM79
	 20Nc0Sf4dHhB1kPyaUEJxpJkuc8RzFuY6g4dC1r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 074/583] cpuidle: dt_idle_genpd: kfree() the original name allocation
Date: Wed,  9 Sep 2026 15:35:59 +0200
Message-ID: <20260909134240.649537874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


