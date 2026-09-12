Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC36E45561A;
	Sat, 12 Sep 2026 10:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209980; cv=none; b=SlHlNqcumFWrh+u/NZuUVau4nmFvlMU5GETIU1szvscUc3kltcP4d5aAtsxpSgZ7nb8yJ5UXrDbw+llpaNcAQuiwoHRrPJrL9WTJPrGGoZHO8bPnpz0ilnzsIGs/jS4yx6tnHnGyQk11OGFs2QT7g8eXfeoIAwZHs11Gz6hcSlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209980; c=relaxed/simple;
	bh=8MW2kqtRdpdDbKIEXm8pRyVfTjYJuDceUnY+I8mklZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+Yxo/tPrKEJUoijhYwjurJrnw6zd9+LMTkXuWS1X96MJG2xviW0eu1TA0kGA1JnHMTLv11+uUPtYfKBQWSGtsQdOmbtKU/ZhH4TFWkRgpgK5plwsKi/WJJp0xjlYg34BIFQOFpokzPpwQYD9XvzKt8kKPXifL/NLaGj8oqqU08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq2wQbeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq2wQbeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21461F000FF;
	Sat, 12 Sep 2026 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209978;
	bh=RSO9uGsZUuURagNjHwCrrGYpOq37pCRzBrxIle3mzr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iq2wQbeu7Co6SV0hhNtJQCPpcm+DfFuX2hnvP3OoPA/nnTaAi4OEt3nKSOhmYD4ZO
	 30bMVuv1fvQZpPA3Ejji4wHA4fRgoUSMMS6FiA2cmWxEOwhZjO6uhsD3NBjhJsYaJi
	 6Tony4PoRqI8kl9/30C/Cv4ALUW/1oQcowHNmyAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0933/1518] arm64: hibernate: Restore DAIF state on error
Date: Sat, 12 Sep 2026 08:51:42 +0200
Message-ID: <20260912065644.557275724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 1eb1c1074c5b0..7bf1174277772 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -348,8 +348,10 @@ int swsusp_arch_suspend(void)
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



