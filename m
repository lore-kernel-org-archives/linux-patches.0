Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA77313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301058; cv=none; b=loJG5r23dr0iD/RNQ8BbcoouaKTuMtGRSCR3M7cou7mLtW8wtZ5gBNwAZJXwZYUY15rk7vax7ZcZYKXN6QU3IU87svbYQQG8oZy2N17dMNaAfQG3cpTHp/7NGcnQBj7mOUjkDSOnxOr1tU9EuLTBwEyyXyKvECbIeQfUX1oKoAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301058; c=relaxed/simple;
	bh=itYz9wcroCLYvmUBhLndqkq23hvv7APVzed7gy3USkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw9t2lbKpSNeWlieerUwaJnlL8TVzaW3KNjprbfrG3hoqydj6cLUYhDWW18Br7s9/TjMt/j/cWSptjd1VZrmK16PmCWqDPr559crcVQT6+a1FptrJx6tJbDACpOIaERxNBz4IvriKhSElNxIWkaIWELb8zXodZ4Y7rzxg6QRmqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5+iYaLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5+iYaLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EFDC116D0;
	Sat, 28 Feb 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301058;
	bh=itYz9wcroCLYvmUBhLndqkq23hvv7APVzed7gy3USkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5+iYaLH/EE11jQ3lkwUSM7W3DJhd9xwqNgHI6DKlEapRv0MtErVflA9C4OvCz29A
	 rpgb9hHfqddaDqj+/Hih9E8hWTAz4XVxu9gHF6zkaWFqGSwz90f03ARcCx4lS+lyk+
	 8WU9sRZwK2UgCsVtOgXzZbZKd4m/H6oyZ9czSLcPJfpdoLNpJlOcyfF9I8ZmNKvgOC
	 vd/sRbc2cpX9Z74steEJGcyBk7MxmbfN5yQ9V5494M8Y+eVM8VeG5hdvX1E/V6HYAU
	 WOtpFhW9VJYMPFK0XkYOykDuMzRSYQ3ojC4ujRmI79+DMdq9pGMn6eH1CTpJ3QMsrM
	 p3j4APseU6ryA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <gu_0233@qq.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/752] hwmon: (nct7363) Fix a resource leak in nct7363_present_pwm_fanin
Date: Sat, 28 Feb 2026 12:38:31 -0500
Message-ID: <20260228174750.1542406-200-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 4923bbff0bcffe488b3aa76829c829bd15b02585 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In nct7363_present_pwm_fanin, it does not release the reference,
causing a resource leak.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Link: https://lore.kernel.org/r/tencent_9717645269E4C07D3D131F52201E12E5E10A@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct7363.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/nct7363.c b/drivers/hwmon/nct7363.c
index e13ab918b1abe..56ac42e4a8653 100644
--- a/drivers/hwmon/nct7363.c
+++ b/drivers/hwmon/nct7363.c
@@ -351,6 +351,7 @@ static int nct7363_present_pwm_fanin(struct device *dev,
 	if (ret)
 		return ret;
 
+	of_node_put(args.np);
 	if (args.args[0] >= NCT7363_PWM_COUNT)
 		return -EINVAL;
 	data->pwm_mask |= BIT(args.args[0]);
-- 
2.51.0

