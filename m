Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836CE19DFA7;
	Wed, 18 Dec 2024 11:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520423; cv=none; b=bSY/HomC0A4WSfI2KK5rFXwxMZHWEHmk8QIETJSXff9sxRmyJkEN8jUYSgsIhHqwMrhxSn6BT2y6gj3R6HXfqvgeg8mudvL0bIErw6e/kr5GqZrT9JOEjzvpn2qwjXmbT6IPwHxIixcteuAnqwy6PFOM2vynKyK8qTba+KbW95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520423; c=relaxed/simple;
	bh=oFO6f2vLIX6tz36grittk65OSBJQMGeVT8ObtjtT3LY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tGuBU3qKJRKY59QZYiIkN7mML1o/zImEDGxPwEht0qGYi1NNVg5Vy/r391VJ2FKWIppl6WYO3T3XSTRekyenMPpAXvlKhi6IFSzD/6pdcJOZYfpej9CSe2V37Q7xErD5f5App1kgj1jvx0IMRI8jiFqzutXZhLnIMKk+TJD9+3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DhJOJfNv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DhJOJfNv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zfPvADUsyhBuK258g6VAKZDD4++/y+8fJPzRmJpcJ/A=; b=DhJOJfNvsbRqDEfw1v84v3ET3K
	mYo61AI6SCiSU0Cq8LREA0iKwAWrkDncNlO5XcvdVL5zhQz2dFJKI2TXDPj1GS8eWZDM9y4wAPAj/
	Cc3KEuAhNwIszlK1ALh6FUxOX5oxV5X/CHjtwDO6Sab/UdfN8I6OKzx354jD6e3/2kv04DogaR+OU
	6vh0gDhGvP4hSnV+IUR4GxfurlxVi8vvLt1TR2By9O2amnzkeK+E4TBaZdTj8uWrPpnCmQ4duGOg4
	RH/bF68zVMr4HTEo4nFpQr6kBWFmk3nmv0Z+I5qCv7pl8tLG2sNX1MMFHG7TNYWO5olnSGq6WdSWZ
	hs1F2ChA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNrzp-0000000GPhZ-0KB7;
	Wed, 18 Dec 2024 11:13:41 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com,
	martin.wilck@suse.com
Cc: linux-block@vger.kernel.org,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests] nvme/053: provide time extension alternative
Date: Wed, 18 Dec 2024 03:13:40 -0800
Message-ID: <20241218111340.3912034-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

I get this failure when I run this test:

awk: ...rescan.awk:2: warning: The time extension is obsolete.
Use the timex extension from gawkextlib

I can't find this extension either, so just use systime() and
use system(sleep) for the sleep command.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tests/nvme/053 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/nvme/053 b/tests/nvme/053
index 3ade8d368be6..65a7b86519bc 100755
--- a/tests/nvme/053
+++ b/tests/nvme/053
@@ -27,13 +27,14 @@ rescan_controller() {
 
 create_rescan_script() {
 	cat >"$TMPDIR/rescan.awk" <<EOF
-@load "time"
-
 BEGIN {
     srand(seed);
-    finish = gettimeofday() + strtonum(timeout);
-    while (gettimeofday() < finish) {
-	sleep(0.1 + 5 * rand());
+    start_time = systime();
+    finish = start_time + strtonum(timeout);
+    while (systime() < finish) {
+	sleep_time = 0.1 + 5 * rand();
+        cmd = "sleep " sleep_time;
+        system(cmd);
 	printf("1\n") > path;
 	close(path);
     }
-- 
2.43.0

