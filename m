Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12C2F4D
	for <patches@lists.linux.dev>; Tue,  7 Jun 2022 21:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654636822; x=1686172822;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yqRAsG56rYYj2A4jgXo6P8t9HyyNEcw84/HV/XhestQ=;
  b=Q108itjraEhX9VpNeU3ZbMPAXrXKn5fs8T7/kEXaQSUsxtwZe2h9J+Ff
   MeCOY8YKJiLWM/NCzdy/FbRhDfzZRRyqyuJBv7vEZgyPP5Z3tpQjKjFBA
   dhfAt6ek1E7Pq4sDRn7cuEYaOOkhvvW7T21VourrIDWh+D5SchzXcHdXh
   avoAP2ARJbGqf7YMTTXZo5F8G7RBHr9l1k3CswtW8KTp6gZ/3EM+kLz4o
   5/8uFfFkUowSLirRkfHiE8Fmq0D/t8T0EHfjKjO0li6SseBO4jCi8z7c/
   2BC1hUL0ZDiYHANQ39cQOd9skmxcP8XmO0XBKk6nqjkPHmGh+zBFYGW7n
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="363091754"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="363091754"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 14:20:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="826558517"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 14:20:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] RAS/CEC: Reduce default threshold to offline a page to "2"
Date: Tue,  7 Jun 2022 14:20:15 -0700
Message-Id: <20220607212015.175591-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A large scale study of memory errors in data centers showed that it is
best to aggressively take pages with corrected errors offline. This is
the best strategy of using corrected errors as a predictor of future
uncorrected errors.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Here's the link to the study. I thought of putting into the code
comment, or the commit comment. But these links are sometimes changed
as website is re-organised, making the link stale.

https://www.intel.com/content/dam/www/public/us/en/documents/intel-and-samsung-mrt-improving-memory-reliability-at-data-centers.pdf

The paper has two recommendations:
1) Change threshold to "2".
2) Do very smart platform dependent things

This commit only addresses the first :-)
---
 drivers/ras/cec.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index 42f2fc0bc8a9..5d614c383ccf 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -125,8 +125,11 @@ static struct ce_array {
 static DEFINE_MUTEX(ce_mutex);
 static u64 dfs_pfn;
 
-/* Amount of errors after which we offline */
-static u64 action_threshold = COUNT_MASK;
+/*
+ * Number of errors after which we offline. Default is to aggressively
+ * offline the page when a second error is seen.
+ */
+static u64 action_threshold = 2;
 
 /* Each element "decays" each decay_interval which is 24hrs by default. */
 #define CEC_DECAY_DEFAULT_INTERVAL	24 * 60 * 60	/* 24 hrs */
-- 
2.35.3

