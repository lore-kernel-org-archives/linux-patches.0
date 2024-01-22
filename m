Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ED350A75;
	Tue, 23 Jan 2024 00:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970408; cv=none; b=Xh+jT4BQsKcmQ/wv/unCAIPxsM1BEacxFZqOStvmVomnEPfkvoz2c43lkPcBAkG3QK6d+2a/LHxKk3/FcAypqqwNy09i7md0fRKD7lmsFbFTmtOXW2Coo9+IrzfAS59fYcEps9IDcHsqft2MNR8ujMXMXGcHeswHo2Tom1JaJI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970408; c=relaxed/simple;
	bh=CdVIeeDOKiTpbCaqVDJpSruwqwqYWsCAZPfjpezyJa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3rtcLh2yAKiwLlBBE7Iwu7ZasLpzVfTi7x803foBrQ5gGP1vKX659mS+SGG5oSCO83d6PvVqlz5KmB953SyeN2PLEKiq410eH37vDL9vuM9cbQq9UAhfswzTl8zraA6xlwvoiayW2x3RT1pbG8MRirjDiKfoAc/qyrWDwKcWEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvjZZieQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvjZZieQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E519C433F1;
	Tue, 23 Jan 2024 00:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970407;
	bh=CdVIeeDOKiTpbCaqVDJpSruwqwqYWsCAZPfjpezyJa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvjZZieQPw2ZO13bTiY/2rhtJWaOJ2bQFcHG0U9KcvRzR0WaNbmWmw1Z/en0143YA
	 QLODWbL5WDzqpjd35YUKS5G3ysoC45HbZmwvXSKA1HJvhRaxNWQUHcq5XhxClLSzxV
	 vwMo6y0il9Ko3+m5CWGuxnRwLbpsTZBFoC/A0jnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/417] powerpc/imc-pmu: Add a null pointer check in update_events_in_group()
Date: Mon, 22 Jan 2024 15:53:00 -0800
Message-ID: <20240122235751.928493349@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 0a233867a39078ebb0f575e2948593bbff5826b3 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 885dcd709ba9 ("powerpc/perf: Add nest IMC PMU support")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231126093719.1440305-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index ada817c49b72..56d82f7f9734 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -299,6 +299,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 	attr_group->attrs = attrs;
 	do {
 		ev_val_str = kasprintf(GFP_KERNEL, "event=0x%x", pmu->events[i].value);
+		if (!ev_val_str)
+			continue;
 		dev_str = device_str_attr_create(pmu->events[i].name, ev_val_str);
 		if (!dev_str)
 			continue;
@@ -306,6 +308,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 		attrs[j++] = dev_str;
 		if (pmu->events[i].scale) {
 			ev_scale_str = kasprintf(GFP_KERNEL, "%s.scale", pmu->events[i].name);
+			if (!ev_scale_str)
+				continue;
 			dev_str = device_str_attr_create(ev_scale_str, pmu->events[i].scale);
 			if (!dev_str)
 				continue;
@@ -315,6 +319,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 
 		if (pmu->events[i].unit) {
 			ev_unit_str = kasprintf(GFP_KERNEL, "%s.unit", pmu->events[i].name);
+			if (!ev_unit_str)
+				continue;
 			dev_str = device_str_attr_create(ev_unit_str, pmu->events[i].unit);
 			if (!dev_str)
 				continue;
-- 
2.43.0



