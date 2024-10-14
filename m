Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C61C1CACE1;
	Mon, 14 Oct 2024 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919638; cv=none; b=BU1y9YpujXb7JXppZza4Nyd3iGp2szZEApcqXWv4hBs8aHU8AjR5WaH4gDPsnmhd89PD58Xi2wY0IVlk0Og+v05yJYlJhea7Bf8eBtx0+QKvmHaCmsAZgioBHpehBJRBx2qbO/G9e6fj0loGvXm9Jd7b3/N70aZzxrbtRPQvcIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919638; c=relaxed/simple;
	bh=zbLMyyPxT7ruyuc1dvltKZUe5TjHvg9rdqnWsH2/ymM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFIgPaRr228I2nq3XsKg9eb9fDAhSJ3sxWCFgyb+oFi/HgAyRBJO679ahAQJskREgF69HU7y7TKJCUwpuKGiK8BWU0sQF41HaXIojzMFNMX/3GGgrXDgkenaY+zNv3qt3vBEPmSxYM5pvVxGI4wGRA3Ru2oG7UXM0G/tA0S2GkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikLec7of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikLec7of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DBCC4CED0;
	Mon, 14 Oct 2024 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919638;
	bh=zbLMyyPxT7ruyuc1dvltKZUe5TjHvg9rdqnWsH2/ymM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikLec7of7fJhN1fKV7Tk4PpAZxaZShokFRZWZqGBdSECzqTGsMbUrwKNA8bUnrZVl
	 0tkrEA8urvS02hUZ3LzuaLyO8uh1EvUmJQKmD8rWi6GeTId/sONhEV6Gk6KX7QMt6d
	 IVj2dYBQYv4541yWJzQjXzapJmzrkIGYQn3kkW4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yong <wang.yong12@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 634/798] delayacct: improve the average delay precision of getdelay tool to microsecond
Date: Mon, 14 Oct 2024 16:19:48 +0200
Message-ID: <20241014141242.949100876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yong <wang.yong12@zte.com.cn>

[ Upstream commit eca7de7cdc382eb6e0d344c07b1449ed75f5b435 ]

Improve the average delay precision of getdelay tool to microsecond.  When
using the getdelay tool, it is sometimes found that the average delay
except CPU is not 0, but display is 0, because the precison is too low.
For example, see delay average of SWAP below when using ZRAM.

print delayacct stats ON
PID	32915
CPU             count     real total  virtual total    delay total  delay average
               339202     2793871936     9233585504        7951112          0.000ms
IO              count    delay total  delay average
                   41      419296904             10ms
SWAP            count    delay total  delay average
               242589     1045792384              0ms

This wrong display is misleading, so improve the millisecond precision of
the average delay to microsecond just like CPU.  Then user would get more
accurate information of delay time.

Link: https://lkml.kernel.org/r/202302131408087983857@zte.com.cn
Signed-off-by: Wang Yong <wang.yong12@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3840cbe24cf0 ("sched: psi: fix bogus pressure spikes from aggregation race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/accounting/delay-accounting.rst | 14 +++++------
 .../zh_CN/accounting/delay-accounting.rst     | 10 ++++----
 tools/accounting/getdelays.c                  | 24 +++++++++----------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/accounting/delay-accounting.rst b/Documentation/accounting/delay-accounting.rst
index 7103b62ba6d7e..79f537c9f160b 100644
--- a/Documentation/accounting/delay-accounting.rst
+++ b/Documentation/accounting/delay-accounting.rst
@@ -109,17 +109,17 @@ Get sum of delays, since system boot, for all pids with tgid 5::
 	CPU             count     real total  virtual total    delay total  delay average
 	                    8        7000000        6872122        3382277          0.423ms
 	IO              count    delay total  delay average
-		            0              0              0ms
+                   0              0          0.000ms
 	SWAP            count    delay total  delay average
-	                    0              0              0ms
+                       0              0          0.000ms
 	RECLAIM         count    delay total  delay average
-		            0              0              0ms
+                   0              0          0.000ms
 	THRASHING       count    delay total  delay average
-	                    0              0              0ms
+                       0              0          0.000ms
 	COMPACT         count    delay total  delay average
-	                    0              0              0ms
-        WPCOPY          count    delay total  delay average
-                            0              0              0ms
+                       0              0          0.000ms
+   WPCOPY          count    delay total  delay average
+                       0              0          0.000ms
 
 Get IO accounting for pid 1, it works only with -p::
 
diff --git a/Documentation/translations/zh_CN/accounting/delay-accounting.rst b/Documentation/translations/zh_CN/accounting/delay-accounting.rst
index a01dc3d5b0dbb..7b8693ccf80a9 100644
--- a/Documentation/translations/zh_CN/accounting/delay-accounting.rst
+++ b/Documentation/translations/zh_CN/accounting/delay-accounting.rst
@@ -92,15 +92,15 @@ getdelays命令的一般格式::
 	CPU             count     real total  virtual total    delay total  delay average
 	                    8        7000000        6872122        3382277          0.423ms
 	IO              count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	SWAP            count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	RECLAIM         count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	THRASHING       count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
 	COMPACT         count    delay total  delay average
-	                    0              0              0ms
+	                    0              0              0.000ms
     WPCOPY          count    delay total  delay average
                        0              0              0ms
 
diff --git a/tools/accounting/getdelays.c b/tools/accounting/getdelays.c
index 938dec0dfaad8..23a15d8f2bf4f 100644
--- a/tools/accounting/getdelays.c
+++ b/tools/accounting/getdelays.c
@@ -198,17 +198,17 @@ static void print_delayacct(struct taskstats *t)
 	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
 	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
 	       "IO    %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "SWAP  %15s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "RECLAIM  %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "THRASHING%12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "COMPACT  %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n"
+          "      %15llu%15llu%15.3fms\n"
 	       "WPCOPY   %12s%15s%15s\n"
-	       "      %15llu%15llu%15llums\n",
+          "      %15llu%15llu%15.3fms\n",
 	       "count", "real total", "virtual total",
 	       "delay total", "delay average",
 	       (unsigned long long)t->cpu_count,
@@ -219,27 +219,27 @@ static void print_delayacct(struct taskstats *t)
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
-	       average_ms(t->blkio_delay_total, t->blkio_count),
+          average_ms((double)t->blkio_delay_total, t->blkio_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
-	       average_ms(t->swapin_delay_total, t->swapin_count),
+          average_ms((double)t->swapin_delay_total, t->swapin_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->freepages_count,
 	       (unsigned long long)t->freepages_delay_total,
-	       average_ms(t->freepages_delay_total, t->freepages_count),
+          average_ms((double)t->freepages_delay_total, t->freepages_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->thrashing_count,
 	       (unsigned long long)t->thrashing_delay_total,
-	       average_ms(t->thrashing_delay_total, t->thrashing_count),
+          average_ms((double)t->thrashing_delay_total, t->thrashing_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->compact_count,
 	       (unsigned long long)t->compact_delay_total,
-	       average_ms(t->compact_delay_total, t->compact_count),
+          average_ms((double)t->compact_delay_total, t->compact_count),
 	       "count", "delay total", "delay average",
 	       (unsigned long long)t->wpcopy_count,
 	       (unsigned long long)t->wpcopy_delay_total,
-	       average_ms(t->wpcopy_delay_total, t->wpcopy_count));
+          average_ms((double)t->wpcopy_delay_total, t->wpcopy_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
-- 
2.43.0



