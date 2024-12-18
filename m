Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B3C19DFA7;
	Wed, 18 Dec 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520919; cv=none; b=ruGRBSzZ8BBipnPSy5pIZfEQstjzA9We6woARVt/hcWGYiEXK4nU1Z4AF2ModLPXWnSDGTUNAGY5660kHElksVXR1tTF0TwgwHbKAMTjXwACRehy1rXEzn3btch46Dtojbr21LMP1YVj+9F9oYsLjeD25hzv6U5UA2BTkfyXPFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520919; c=relaxed/simple;
	bh=oFO6f2vLIX6tz36grittk65OSBJQMGeVT8ObtjtT3LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlIM9br+Gzdylnjp9Q+tJwg6ZpLnP0vfWyJYno/ggpYsMlOv0NcfVn03LBU1hjiaduSkEzGSDQBw3WnfGwS9KGQI6Pmof9jriG9ZT07411D2JbLeFhjBBidqa4REb4F0vOqz0cbfJfTu6pCjZnAoWyJhI9Da1bpiA+ymIkzToQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ACsTUmqn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ACsTUmqn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zfPvADUsyhBuK258g6VAKZDD4++/y+8fJPzRmJpcJ/A=; b=ACsTUmqnOHlp1Jg15vxzzLpq27
	OG2fR20yS7jopiaIEM8/+LAmA8mKs4BWGsX7KFd/WJUiymDaf3ubopXQ9+hbLbVCxlvpYyuJHx+H7
	qJ/wJ67XETHYwXHmhuE4NdNb2XdWWKuqW1iJdZukEFhqU3QBUUa3IBNN5odB33sxnyShy8WNnDy4W
	UMODkRJIr+8F3VKvTQi7DdkGLJy5XNs763ASDkqSaO9bPiQv0IqaCufIaEE0k/61e2+CFhgtN6N5q
	UQg4fK+mGhLoCN/2yCLTZhee+gPb30KRGVpb6UDdsKUxLRISIaDfkbUySmbjry/6Jv6PrdWDVvbbc
	rX+HLFyw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNs7p-0000000GR86-01PV;
	Wed, 18 Dec 2024 11:21:57 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests 4/4] nvme/053: provide time extension alternative
Date: Wed, 18 Dec 2024 03:21:53 -0800
Message-ID: <20241218112153.3917518-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241218112153.3917518-1-mcgrof@kernel.org>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
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

