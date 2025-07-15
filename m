Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251FA2E339A;
	Tue, 15 Jul 2025 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586956; cv=none; b=ZIbRJYy851GaVquuvS0dVCBdMMpWgBpDIYvccdKvnwJr0gspuM7Ez/Op6q4yI1lwEDV1zkl7knPsRrAFE/3UKSOEtsVi8adxLnsxWphW97oRCxpGU5eyb/xW+YZpp8Tw3LFRuUjDEwpjVaL4R1fnOs41ZZIWFjF70VapRJLB280=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586956; c=relaxed/simple;
	bh=cBAVTIDK/Qked8dmjndzDmoN5ss4WXBH7ezYn8E5SYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od3fkKSHCjQXcEeRkVE3NC8fnArluBkRhH8mhmdJe8HtAwjZulLzuw9DHgPVcdLsCSZN4Aei+Z+8QOucHTcUq5fKr6PRD9Lv23f+Q54D2WBcSA60DGjT7+9CAL8fDQxzAyUbMcmvHeYI5DhyEuKAd0zPBgjOZ+oLo5JaZc5lhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAtZtFYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAtZtFYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1A3C4CEE3;
	Tue, 15 Jul 2025 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586954;
	bh=cBAVTIDK/Qked8dmjndzDmoN5ss4WXBH7ezYn8E5SYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAtZtFYXsZErFz0b2dZrbA97TWfKUUECXqT0rmX0yHsnblwqfchZpRdMrKt98WqVO
	 Pd+NihLz80/siW6HSaamzgT/QtTGCPR5DQHBwKK6eHp8hI0lJRAWCR5qqkKTxTY1oL
	 3qCDef4L4d9EjgGl8AXl6EmvbWiyuJgDzUP4myP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggyu Kim <honggyu.kim@sk.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 111/192] samples/damon: fix damon sample wsse for start failure
Date: Tue, 15 Jul 2025 15:13:26 +0200
Message-ID: <20250715130819.342791686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Honggyu Kim <honggyu.kim@sk.com>

commit f1221c8442616a6927aff836327777144545cb29 upstream.

The damon_sample_wsse_start() can fail so we must reset the "enable"
parameter to "false" again for proper rollback.

In such cases, setting Y to "enable" then N triggers the similar crash
with wsse because damon sample start failed but the "enable" stays as Y.

Link: https://lkml.kernel.org/r/20250702000205.1921-3-honggyu.kim@sk.com
Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/wsse.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 11be25803274..e20238a249e7 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -102,8 +102,12 @@ static int damon_sample_wsse_enable_store(
 	if (enable == enabled)
 		return 0;
 
-	if (enable)
-		return damon_sample_wsse_start();
+	if (enable) {
+		err = damon_sample_wsse_start();
+		if (err)
+			enable = false;
+		return err;
+	}
 	damon_sample_wsse_stop();
 	return 0;
 }
-- 
2.50.1



