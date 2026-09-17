Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36034E9C3A;
	Thu, 17 Sep 2026 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668439; cv=none; b=mvek0YGeEt+nvAdwY8yaF9HS0R5yF9VRQzbUXQ1DLoolhJmbmryBSNXNxl1KXhoS7C4XQAbG/gyP7C3kFK7fdk7gpUo/3Pnnr1EgWD2LwilFx4q1Ki96Q7VLo5PcDQjxQsPC0yiGHoVbGoLM8xoQr6PP5tmByKUUI7IX1oJO4Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668439; c=relaxed/simple;
	bh=hpT1x03CeeLe/EhFUyBMDLupdWT8cM1fsNkvw+ssyIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HunKrTjhuePDmcOeWesLxgOzbTphVTpGCYxn8DPqDJ5eG/0gJRgwu35M1EppQNZS0R5zaiEWpCXwnVbVWeLo9dKHoY705YtYsFLLWSQ9Q/RjRSy7Yq0DiHvJ7RdsI9K2jQzgfcgWoX8iELPgFjwvkYN6LRAZNWaQh1EHM4l96Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/xzFX5j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/xzFX5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B291F000FF;
	Thu, 17 Sep 2026 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668437;
	bh=jf+j5Z6oRhUq07j+WP3dVdzUw9hWeVudVLvySGNvYGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/xzFX5j8XW4RHoivmwdVqQlQtUUNXl8/IN4W0XHz3uGgQy2AdvUypMzEHh8huNkF
	 KeX8DhYeh7yirl7QEhscZ8oUEQQjNW+3uVoh5QMjd1GSVb2Ng5iBeQCpwn/y4qXb3s
	 F/i9s71F9KyD3Ws6JUQjVUW2xdog92QjON/ZaWT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0426/1102] arm64: fixmap: Allow 256K early_ioremap() at any offset
Date: Thu, 17 Sep 2026 16:06:09 +0100
Message-ID: <20260917151550.366686694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit 21fc7ec93f8b633b60d5bddef2f1529ff6b36185 ]

NR_FIX_BTMAPS is the per-slot page limit for early_ioremap(). Since
__early_ioremap() maps the page-aligned physical range, a 256K request
can require one extra page when the physical address is not page-aligned.

Reserve one extra page per slot so the 256K mapping budget is usable
regardless of the initial page offset.

Link: https://lore.kernel.org/r/08fd96fa-ee3a-4904-bd11-bb08bd90436f@kylinos.cn
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fixmap.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 87e307804b99c..de25908f5d901 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -72,8 +72,12 @@ enum fixed_addresses {
 	/*
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
+	 *
+	 * Reserve one extra page so a 256K mapping may start at any
+	 * offset within a page. early_ioremap() maps the page-aligned
+	 * physical range, so the initial offset can consume an extra page.
 	 */
-#define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
+#define NR_FIX_BTMAPS		((SZ_256K / PAGE_SIZE) + 1)
 #define FIX_BTMAPS_SLOTS	7
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
 
-- 
2.53.0



