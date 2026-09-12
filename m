Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562414749C0;
	Sat, 12 Sep 2026 11:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213144; cv=none; b=prMSwdfyzVN6AeEFv9MvcKxORTAdoxwBrYyQGmCvuWAfpSwYm2UL1alvR9DA+2LYXmqb5U5wXuwTktLcPxZ0XdJbLCz+E+k7MSzn5uLJVZdI8KRw6YTSnnWr14YGKeNBbARh7Bf4elIBGPf8+B/BO2/LMQNgqxSB7TviFA5RipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213144; c=relaxed/simple;
	bh=UuxvlxlOCxxdAzGySS0H+ab9cc1IL6sH48SmZVCLV9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrE/J/WfFAFZUOZBiKyi4ws4X5Rw6/XgNNKVGJEgFosKcWZ9byFuF/F7tXkYb9siTH4tVuhoW9RsIdq9mEg2mIi2Sro6o2sM9LLejPdkM96xmrubzEMCBod37qCFXYVvj2MRz/cXTMEWDH1gjl07v3w2vf565lhCWQsudZ85zQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQlIAOVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQlIAOVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2511F00893;
	Sat, 12 Sep 2026 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213141;
	bh=cqD10M5hQD3Lss9M9D4NPP/zJsD4L1u/ewJixQSrEVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQlIAOVu63F3hsk8nBSDLqNTFXEIco32M3z06FJdbUrX5bk47AZYEsjQJdULNsHux
	 nCeIEJpQLbukiZ4VeFCz30hxiMvt4pkCey2/ip/qQnRZHDw2J7gM0N0IIoPrwbU0bC
	 moqPxTxKv9F6QNbHT5du4hXTsmlBo8QZxs5aLySU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 0062/1376] cpuidle: dt_idle_genpd: kfree() the original name allocation
Date: Sat, 12 Sep 2026 08:41:28 +0200
Message-ID: <20260912065608.942779260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


