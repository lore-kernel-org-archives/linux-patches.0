Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F433261B96;
	Wed,  3 Dec 2025 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777628; cv=none; b=skdW52hN3RhcxZy2fp38XRW1Hzh9EhHnqPLz+IOFRWRqRW+mulp2fN1f2JRIhYRaEDkrd2d9Z30XjjkA/DFx1JAJ37kRUvw/Bv63tgi9v10thXi5gcRcqh9a1oOKeXkJOmcTOEyuwcKhi9x/LZKi8AoE4QvQJLHe52sBYfGbVDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777628; c=relaxed/simple;
	bh=I0OgnjuocvEgVu5z+dxAe5o5kN/BxLNoHLoshgXCWdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmrUMFxgrR4WvUPZgw5aivFo9K1E92jyBb8nvEQeppOw5F07NuvK4JHXKa/HPXxjlo6aUhFvE0wZQ6CI50A2/eL/ubmbZ63R8WLyrOo7kjTATXy9hDvsWpq7A4Ky20STYJbQM4fY0bu+iOJrJBlGf+OHcUilAalnVDn1hwNPrrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2uUEWx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2uUEWx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03B6C4CEF5;
	Wed,  3 Dec 2025 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777628;
	bh=I0OgnjuocvEgVu5z+dxAe5o5kN/BxLNoHLoshgXCWdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2uUEWx155aHFLJq9DxUEKQIJAKLjh3kKNCcavH92dxl+4ZMicmYZVwe12zldYn13
	 QwJLSedN/dus5b0fM76Xt+v0tmYKU09aB/SQPoaZ6uw+SnOBEGrn5B/nyj2vOWgGTP
	 Jmn7kOFMrr20oangq2NH32Oy0RZ6dwuwJ57g+WvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Beier <nanovim@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/392] cpufreq/longhaul: handle NULL policy in longhaul_exit
Date: Wed,  3 Dec 2025 16:23:33 +0100
Message-ID: <20251203152416.429580465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Beier <nanovim@gmail.com>

[ Upstream commit 592532a77b736b5153e0c2e4c74aa50af0a352ab ]

longhaul_exit() was calling cpufreq_cpu_get(0) without checking
for a NULL policy pointer. On some systems, this could lead to a
NULL dereference and a kernel warning or panic.

This patch adds a check using unlikely() and returns early if the
policy is NULL.

Bugzilla: #219962

Signed-off-by: Dennis Beier <nanovim@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/longhaul.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index c538a153ee828..f116a1d555490 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -953,6 +953,9 @@ static void __exit longhaul_exit(void)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	int i;
 
+	if (unlikely(!policy))
+		return;
+
 	for (i = 0; i < numscales; i++) {
 		if (mults[i] == maxmult) {
 			struct cpufreq_freqs freqs;
-- 
2.51.0



