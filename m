Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F6021A4A8;
	Tue, 12 Nov 2024 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408400; cv=none; b=CDw0yKr7KCdMA0DtB1djowu9g3gE6eXGqFe5BY5Oe62RaoJqaaif8RC4R0V3Xdsy8FKNpAqGDBrEy4+JHpaNE+nDwP9kkJL4GtrfJdaQyyKRgFJld+1r3GmxH9vkKol69GXE8taUs7rLxsd2z13QMhxh5Y4wpi7JwHtLrd/ELwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408400; c=relaxed/simple;
	bh=s6cUf99GOkXMAXBJ8ooIT7bW42cVL4ZpH9sQ9MYJ9vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvV9yUfRz8jisvNCu7+ANde4bTh9yxYinKNs3KEiLm3ZdfZiL60/hBCVpnM+N8oMK0Uy+PEiLOuKNnHLHdJc0e1TmcOsWD5MZbBmOZGC2L8+vYgVY+Sogfjf5QX6aOgZn4yjEuLHh7g8jqLEEHPoNuETUSm11/HZanqCHRgTSwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LEyamfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LEyamfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C42C4CECD;
	Tue, 12 Nov 2024 10:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408400;
	bh=s6cUf99GOkXMAXBJ8ooIT7bW42cVL4ZpH9sQ9MYJ9vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LEyamfd5JTXdflBRaKKYzGKBc/3q4AkB2R0chwUnAHkRRx9IKLZ/L0Wlvebi2+/g
	 mznzZhxa1R4KE/0d14ac9BULy9j8qP6zzhCwCgBLUySHl37CBiguK3gt/SzzE5meBr
	 cK8f+0N6LGWjSZGDYUrlJZJ5ba0b5nyW6mnEM2EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 150/184] mm/damon/core: avoid overflow in damon_feed_loop_next_input()
Date: Tue, 12 Nov 2024 11:21:48 +0100
Message-ID: <20241112101906.626013119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 4401e9d10ab0281a520b9f8c220f30f60b5c248f upstream.

damon_feed_loop_next_input() is inefficient and fragile to overflows.
Specifically, 'score_goal_diff_bp' calculation can overflow when 'score'
is high.  The calculation is actually unnecessary at all because 'goal' is
a constant of value 10,000.  Calculation of 'compensation' is again
fragile to overflow.  Final calculation of return value for under-achiving
case is again fragile to overflow when the current score is
under-achieving the target.

Add two corner cases handling at the beginning of the function to make the
body easier to read, and rewrite the body of the function to avoid
overflows and the unnecessary bp value calcuation.

Link: https://lkml.kernel.org/r/20241031161203.47751-1-sj@kernel.org
Fixes: 9294a037c015 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/944f3d5b-9177-48e7-8ec9-7f1331a3fea3@roeck-us.net
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: <stable@vger.kernel.org>	[6.8.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1450,17 +1450,31 @@ static unsigned long damon_feed_loop_nex
 		unsigned long score)
 {
 	const unsigned long goal = 10000;
-	unsigned long score_goal_diff = max(goal, score) - min(goal, score);
-	unsigned long score_goal_diff_bp = score_goal_diff * 10000 / goal;
-	unsigned long compensation = last_input * score_goal_diff_bp / 10000;
 	/* Set minimum input as 10000 to avoid compensation be zero */
 	const unsigned long min_input = 10000;
+	unsigned long score_goal_diff, compensation;
+	bool over_achieving = score > goal;
 
-	if (goal > score)
+	if (score == goal)
+		return last_input;
+	if (score >= goal * 2)
+		return min_input;
+
+	if (over_achieving)
+		score_goal_diff = score - goal;
+	else
+		score_goal_diff = goal - score;
+
+	if (last_input < ULONG_MAX / score_goal_diff)
+		compensation = last_input * score_goal_diff / goal;
+	else
+		compensation = last_input / goal * score_goal_diff;
+
+	if (over_achieving)
+		return max(last_input - compensation, min_input);
+	if (last_input < ULONG_MAX - compensation)
 		return last_input + compensation;
-	if (last_input > compensation + min_input)
-		return last_input - compensation;
-	return min_input;
+	return ULONG_MAX;
 }
 
 #ifdef CONFIG_PSI


