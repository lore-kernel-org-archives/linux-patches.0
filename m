Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576FA223DFF;
	Tue, 12 Aug 2025 19:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026242; cv=none; b=jGlM8trJVdV7unRHSk7uhLkyyU3JmoKwLiDCnk2z3paejuRxrxIGgTautvUdebssOORS3ABauQw37t/xn0TFrb+kV/bF4MFn8BtuwQ3RaofnyFrRNqARaI8dKO2BsXA7TcYu+caCYneyMfDklc40RCl3WWbgzP0v//bQiP+TzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026242; c=relaxed/simple;
	bh=3OJQGfd/PYv0Hl7n24chPaYe6P9D5Ps8J5j54VE+aLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjbG5B/luvejVqnLjbtVErUpYzw8MJklBU9C7JMI2x/tsebVgh044ADJsaADm1RQPvwMeiUzEqj13yuzxGwaqww6AK3w4qq74+EjJXiObfT7HXu1maNJj7JViDDT9pqcopQ+RGBFQUtI0txvKp+eTS+j8BojHoKZ0X6LNAT7nnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ED3jP/3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ED3jP/3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CA6C4CEF0;
	Tue, 12 Aug 2025 19:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026242;
	bh=3OJQGfd/PYv0Hl7n24chPaYe6P9D5Ps8J5j54VE+aLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED3jP/3RaNg9LXVYp/qErs8fJYpQUw6orRL+eMrSRFU5w9Gzi2Xe31X0FCGdLvDCD
	 Nrm4QEq66ux0miwRlMAbb0LoPqgAeKxu+1zXB3anoStDCynz3JE1QMrBJ0IJCZzCcG
	 lG+HKx0/VjwzmYi2s+LKSASQWU2j7vGkAnMLPRoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 279/480] perf hwmon_pmu: Avoid shortening hwmon PMU name
Date: Tue, 12 Aug 2025 19:48:07 +0200
Message-ID: <20250812174408.942170140@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 28f5aa8184c9c9b8eab35fa3884c416fe75e88e4 ]

Long names like ucsi_source_psy_USBC000:001 when prefixed with hwmon_
exceed the buffer size and the last digit is lost. This causes
confusion with similar names like ucsi_source_psy_USBC000:002. Extend
the buffer size to avoid this.

Fixes: 53cc0b351ec9 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250710235126.1086011-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index 3cce77fc8004..cf7156c7e3bc 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -344,7 +344,7 @@ static int hwmon_pmu__read_events(struct hwmon_pmu *pmu)
 
 struct perf_pmu *hwmon_pmu__new(struct list_head *pmus, int hwmon_dir, const char *sysfs_name, const char *name)
 {
-	char buf[32];
+	char buf[64];
 	struct hwmon_pmu *hwm;
 
 	hwm = zalloc(sizeof(*hwm));
-- 
2.39.5



