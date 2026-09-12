Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723F313545;
	Sat, 12 Sep 2026 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221309; cv=none; b=E/FIr3j4UOhQGvPS2ogwaCa0GaiEqqjJhp1J0oroSZvaU8eCRf+swkkgIxj8AmhcYJbTp9tU98aDLxyz9qKqo6iUfrqG7UFo8GHwTM+/Bc3+p12gOylXe0GpV8qEVtQgs1t8mhf9H4DUGF30cOya4qAVsN79gfsdJg4IOYPES0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221309; c=relaxed/simple;
	bh=PJGhQxliv8rVG1a0iv+JI6o3smGRrLNjViT5HuVv+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZxcAn10i0kh7ufbZIELax6/Ul52VRrZ8DrdWNCyex1hkIjA3xZMP+X+3W3MEFVfSCtkuTi3gB1PVgo88O1V11rx1M/wrgswz8LvCErmuB+S2Mc9jYMqM8EUEsxbgLPDXtBh/xc9UMAtQ00j6yBN/FSLVMM7sEFTqHmVkUb/Thc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smLI/ESD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smLI/ESD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C1B1F000FF;
	Sat, 12 Sep 2026 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221308;
	bh=taQhXXV2s+zYx8nG7UfjNQ0EeZ5diRaSyRUmXalHTrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smLI/ESD1bmh7OOTFT+oCfBdtp5ifq4lqPp3oXWVhlBbiv8WxTVxh3dIyYYJzMsmp
	 uILGjgpKQou5OgmWqxHg4rEeZexqKe7ibrD86kc8J0QAZL/F3FbMjXuJOTnJ1qOill
	 Kc0ABAQPgnvEiEMKPUmbr4DYi3cJH8AAY3frxa6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0357/1424] cpuidle: dt_idle_genpd: kfree() the original name allocation
Date: Sat, 12 Sep 2026 08:46:29 +0200
Message-ID: <20260912065615.282725955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


