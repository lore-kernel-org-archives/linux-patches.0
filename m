Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D4B31B138;
	Mon, 18 Aug 2025 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522094; cv=none; b=E2JLhD4x8HUkiT//MnZbUNdV+nzeTv+3p82EygicKArfkcjZWdeA2cY9ywB+/aVp7++e9TLr1jfIBmc4KcK6/mW/4WgU0osB5gf358oM8RipfnVjVGK6JYxwUyf4t7+zgzB0TihRzDuTLLsLSyFUTZFHbnojbaMLKoVfGVkibNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522094; c=relaxed/simple;
	bh=UfaEnKgWe05u/f8BAAA4yYumQZyvyDz08BXUDox6yOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYHkJvwWjXxhUOrq4i5CGtK4a5CXobtvXu0UWPWcedUaDtR0jF1U7skGCcwdlmvBuEgj87+rAlBdw2O5+TQn/J24b2ZZVwtt/yBCOtlGVn/hE/tU6aF2fM40RJqHaMO+WwZSK193EhXjIegYmcbrPQ/QGl1jP6tJdRnwIgv2y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1DZbZVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1DZbZVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC1FC4CEEB;
	Mon, 18 Aug 2025 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522094;
	bh=UfaEnKgWe05u/f8BAAA4yYumQZyvyDz08BXUDox6yOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1DZbZViYMXcwO9qgiuHN4ESEBQsR2NQ55PwBjTIakdNQs6G9WwZi/jAQley+rBLp
	 lunCm7ZyhgpB6F+9I0jnzSAdBBowY6Ik/eUbeM9kdQB+4aNEYOoj4Ihvzq+0zzPn20
	 3Wak7nJXmx7pa99IciV0uA5NTKENttWgYLPrE0D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/444] perf/arm: Add missing .suppress_bind_attrs
Date: Mon, 18 Aug 2025 14:43:58 +0200
Message-ID: <20250818124456.798521209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 860a831de138a7ad6bc86019adaf10eb84c02655 ]

PMU drivers should set .suppress_bind_attrs so that userspace is denied
the opportunity to pull the driver out from underneath an in-use PMU
(with predictably unpleasant consequences). Somehow both the CMN and NI
drivers have managed to miss this; put that right.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/acd48c341b33b96804a3969ee00b355d40c546e2.1751465293.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 1 +
 drivers/perf/arm-ni.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index ff17e0f95fbb..978b239ec10b 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2661,6 +2661,7 @@ static struct platform_driver arm_cmn_driver = {
 		.name = "arm-cmn",
 		.of_match_table = of_match_ptr(arm_cmn_of_match),
 		.acpi_match_table = ACPI_PTR(arm_cmn_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = arm_cmn_probe,
 	.remove_new = arm_cmn_remove,
diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
index 4b9d53dae897..fb09730a9aa0 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -710,6 +710,7 @@ static struct platform_driver arm_ni_driver = {
 		.name = "arm-ni",
 		.of_match_table = of_match_ptr(arm_ni_of_match),
 		.acpi_match_table = ACPI_PTR(arm_ni_acpi_match),
+		.suppress_bind_attrs = true,
 	},
 	.probe = arm_ni_probe,
 	.remove = arm_ni_remove,
-- 
2.39.5



