Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F0D2CCC0;
	Tue, 27 May 2025 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365186; cv=none; b=IhG3HvqnfxroBmaRkk3ZrItu9o8JTSgr08hT3O0iSuTQC94LZ43aMGhJsrlinCpWpkqIL7A7iAGeU0nJg93vSeSpt4UtCK9rTr7ggxwUsorYj5DUf+9pGfzETWXluM0Qu1C40Z4+JyvskKlLDB+PjvexXrI2EbOqLMeqqKD8q88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365186; c=relaxed/simple;
	bh=WQNOPGvNe1PfYuK9jPT2W77yR06hKOxfqAjDoJum6F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfy41kszIUzwLGMZ0Fl3dVAVUISCZOZk7D0Y+l9XbbTg2PWxPOh3Gzbx4Z7gePU8WhdvDlMH45ltMPMLgdWGfcvSBKF+E2gwhmOpApJB0OAu5P6ObaD5RG63F1kLP5aBoJ1tWgY/FIdJbLf6VtnP2in+xoSqOjkU0D2B4pfQ/bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FagkQAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FagkQAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9583BC4CEE9;
	Tue, 27 May 2025 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365186;
	bh=WQNOPGvNe1PfYuK9jPT2W77yR06hKOxfqAjDoJum6F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FagkQAFgxeTmVp3Gs8WXFFRz6KhZ8DsqNEx95hNK7SfpIjcX4rjfNL8fgaQchgAY
	 p4ZPzFoTIqOTIP/LjCTNYeMky9sj8/Rt3oyNYaKI5m7nnFQJYhpiXBCEmk0VF5RDAd
	 NJNmljysUryRyYf3wPB3DoI8Gbt8Q2H9s+XXaSFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/626] cpuidle: menu: Avoid discarding useful information
Date: Tue, 27 May 2025 18:23:08 +0200
Message-ID: <20250527162457.020467204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 85975daeaa4d6ec560bfcd354fc9c08ad7f38888 ]

When giving up on making a high-confidence prediction,
get_typical_interval() always returns UINT_MAX which means that the
next idle interval prediction will be based entirely on the time till
the next timer.  However, the information represented by the most
recent intervals may not be completely useless in those cases.

Namely, the largest recent idle interval is an upper bound on the
recently observed idle duration, so it is reasonable to assume that
the next idle duration is unlikely to exceed it.  Moreover, this is
still true after eliminating the suspected outliers if the sample
set still under consideration is at least as large as 50% of the
maximum sample set size.

Accordingly, make get_typical_interval() return the current maximum
recent interval value in that case instead of UINT_MAX.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Link: https://patch.msgid.link/7770672.EvYhyI6sBW@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f3c9d49f0f2a5..97ffadc7e57a6 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -239,8 +239,19 @@ static unsigned int get_typical_interval(struct menu_device *data)
 	 * This can deal with workloads that have long pauses interspersed
 	 * with sporadic activity with a bunch of short pauses.
 	 */
-	if ((divisor * 4) <= INTERVALS * 3)
+	if (divisor * 4 <= INTERVALS * 3) {
+		/*
+		 * If there are sufficiently many data points still under
+		 * consideration after the outliers have been eliminated,
+		 * returning without a prediction would be a mistake because it
+		 * is likely that the next interval will not exceed the current
+		 * maximum, so return the latter in that case.
+		 */
+		if (divisor >= INTERVALS / 2)
+			return max;
+
 		return UINT_MAX;
+	}
 
 	thresh = max - 1;
 	goto again;
-- 
2.39.5



