Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D37530569D;
	Fri, 15 May 2026 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860823; cv=none; b=aU49L7FEN7DBCcQd4Ir4MAL38ZWqCDyjKmDpbriCOvU+4KFUokgxbpGZSdxyI4SHMYUKoqeB/53s5+/nvTpFnna8AGDZJwPFgKpFsXRe2lFaIqYtFjFAbjtosbO19YMGHXXFlJmNX+MMgFamkJlVSr5kRcKZW5P8ge1jPftiko0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860823; c=relaxed/simple;
	bh=gwjeDNFeogAnU36a0RsU6HAzTMqIh875A+9xT7o3uvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIr03tOZT/TbzX1PwnX3YIc8oJlZDjTpwETZYF0WiRBp0NBQ2dj2U7BZaZCdfueUVwb3oPJu+j05T0lv7VWlhMzr91tqFJm0eq/IAmEIXFhpC5SfVYO+FjTdkHdZDHRmpzjerOdVKdllQrK/pK8uXeTHmRmkvNyZCg7q/JTP0YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOyKEiTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOyKEiTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D693DC2BCB0;
	Fri, 15 May 2026 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860823;
	bh=gwjeDNFeogAnU36a0RsU6HAzTMqIh875A+9xT7o3uvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOyKEiTdp7PC+ikXHNJ8+qhZjVaQ2MYd4kRZcRxrc5CijZ+TOiyLfCYs0TZ2+4KVD
	 pWVudoVkO8/7pghkqwHPGzYC4FkyLlrc7eNYyw9VlSJj2Z2Mj5QwSwBOMK5Ucf+smr
	 QTXmbnVvw5BRdwOEiYeyEpiwbSzgvSyqSN6EDqOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 092/474] mm/damon/core: use time_in_range_open() for damos quota window start
Date: Fri, 15 May 2026 17:43:21 +0200
Message-ID: <20260515154717.030603236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 049a57421dd67a28c45ae7e92c36df758033e5fa upstream.

damos_adjust_quota() uses time_after_eq() to show if it is time to start a
new quota charge window, comparing the current jiffies and the scheduled
next charge window start time.  If it is, the next charge window start
time is updated and the new charge window starts.

The time check and next window start time update is skipped while the
scheme is deactivated by the watermarks.  Let's suppose the deactivation
is kept more than LONG_MAX jiffies (assuming CONFIG_HZ of 250, more than
99 days in 32 bit systems and more than one billion years in 64 bit
systems), resulting in having the jiffies larger than the next charge
window start time + LONG_MAX.  Then, the time_after_eq() call can return
false until another LONG_MAX jiffies are passed.

This means the scheme can continue working after being reactivated by the
watermarks.  But, soon, the quota will be exceeded and the scheme will
again effectively stop working until the next charge window starts.
Because the current charge window is extended to up to LONG_MAX jiffies,
however, it will look like it stopped unexpectedly and indefinitely, from
the user's perspective.

Fix this by using !time_in_range_open() instead.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20260329152306.45796-1-sj@kernel.org
Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
Fixes: ee801b7dd782 ("mm/damon/schemes: activate schemes based on a watermarks mechanism")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1048,7 +1048,8 @@ static void damos_adjust_quota(struct da
 		quota->charged_from = jiffies;
 
 	/* New charge window starts */
-	if (time_after_eq(jiffies, quota->charged_from +
+	if (!time_in_range_open(jiffies, quota->charged_from,
+				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;


