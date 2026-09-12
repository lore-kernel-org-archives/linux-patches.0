Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7FC43B3EF;
	Sat, 12 Sep 2026 12:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217557; cv=none; b=uxr5aFOxw7XR/dZae4TB439wmn4s7h5p1dATDA5Yv854wSvOoyOaFE6jAYTHM0ebiiqaSSwgid2m0N4NzOGJAMB6o53kFgJO5NLtDCM0yw33dogXtasOkDk+woEtma2BmJYe7LFHPKg7tVt4pBzWlCQI6zg9gOsyy8rH8fcBFvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217557; c=relaxed/simple;
	bh=F1fwE/9FXaty0hVi/xz10G2gmBg9JDaJzxMkaDM7QI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1AOoXcviOQx2clacfNq8hwucWnfhoCZZduKfTmis7R2YL2MM4Hs86jwbXpk7iVr6LpZKfnn76nPmht6S+9DmILyRB1YcJxYJ6NBJkY9HI7O1zm6KAJJS/rgqiNjHVjvu1NyfLaMI6PHFja8v1Hq/iGblmvPEyqg9ScSWrqh+YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyb0XXjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyb0XXjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23171F000FF;
	Sat, 12 Sep 2026 12:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217556;
	bh=+GPAwO2RNbMaNHpQOvciqAI4J7ySjSmSMKCOhzyPtio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyb0XXjlj6H/lx55sLIsNYemQwVbgKOYuOsL1F5yDSArTPn3qtfIJR8VlXbjynlUC
	 /g2f/FrDNx5WQBlzxXHp/G9CWbZdLBCHJBIwLq9yYlLsg+GRuEQMWbP6E6Ll4Lr2Fx
	 hU2UDV7tu9LvDAFGKLclfRZo529iU39cLviFL3XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0934/1376] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 08:56:00 +0200
Message-ID: <20260912065628.378964170@linuxfoundation.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 541549827889d0380fd73f8aacb5de6ef7a5a1ac ]

Sashiko AI has reported that if swsusp_mte_save_tags() for some reason
fails we return from swsusp_arch_suspend() with DAIF being masked -
that is not what we'd expect. Restore the saved DAIF state before
returning from the error path.

Fixes: ee11f332af96 ("arm64: mte: Save tags when hibernating")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 7b9f82ccdf0e4..44d31b019efd5 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -342,8 +342,10 @@ int swsusp_arch_suspend(void)
 		crash_prepare_suspend();
 
 		ret = swsusp_mte_save_tags();
-		if (ret)
+		if (ret) {
+			local_daif_restore(flags);
 			return ret;
+		}
 
 		sleep_cpu = smp_processor_id();
 		ret = swsusp_save();
-- 
2.53.0



