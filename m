Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D6F33CFD;
	Fri, 24 Nov 2023 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSQWG1cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6795C433C8;
	Fri, 24 Nov 2023 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849763;
	bh=NclvZZpwvAsw+47Jr6QGR1skV9Ox1dXkEHgCHhOnb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSQWG1cUtRCC5N6U4elbqlHlpG8d+aR5CbeXE2rhIS+Zd7uO8P3L4V/pp0W0QnBcD
	 ImnBnoXZr4I5+OmOxK4LwQffmfB2FED+/iROzZRFfukBRsyeBEWGUt2sKlb6jDexID
	 qlWkHQrCoVoMUY7Qfn/1aYEyW3RKFt8+aRGeE15k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 311/530] cpufreq: stats: Fix buffer overflow detection in trans_stats()
Date: Fri, 24 Nov 2023 17:47:57 +0000
Message-ID: <20231124172037.502387737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit ea167a7fc2426f7685c3735e104921c1a20a6d3f upstream.

Commit 3c0897c180c6 ("cpufreq: Use scnprintf() for avoiding potential
buffer overflow") switched from snprintf to the more secure scnprintf
but never updated the exit condition for PAGE_SIZE.

As the commit say and as scnprintf document, what scnprintf returns what
is actually written not counting the '\0' end char. This results in the
case of len exceeding the size, len set to PAGE_SIZE - 1, as it can be
written at max PAGE_SIZE - 1 (as '\0' is not counted)

Because of len is never set to PAGE_SIZE, the function never break early,
never prints the warning and never return -EFBIG.

Fix this by changing the condition to PAGE_SIZE - 1 to correctly trigger
the error.

Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Fixes: 3c0897c180c6 ("cpufreq: Use scnprintf() for avoiding potential buffer overflow")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq_stats.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -131,23 +131,23 @@ static ssize_t show_trans_table(struct c
 	len += sysfs_emit_at(buf, len, "   From  :    To\n");
 	len += sysfs_emit_at(buf, len, "         : ");
 	for (i = 0; i < stats->state_num; i++) {
-		if (len >= PAGE_SIZE)
+		if (len >= PAGE_SIZE - 1)
 			break;
 		len += sysfs_emit_at(buf, len, "%9u ", stats->freq_table[i]);
 	}
-	if (len >= PAGE_SIZE)
-		return PAGE_SIZE;
+	if (len >= PAGE_SIZE - 1)
+		return PAGE_SIZE - 1;
 
 	len += sysfs_emit_at(buf, len, "\n");
 
 	for (i = 0; i < stats->state_num; i++) {
-		if (len >= PAGE_SIZE)
+		if (len >= PAGE_SIZE - 1)
 			break;
 
 		len += sysfs_emit_at(buf, len, "%9u: ", stats->freq_table[i]);
 
 		for (j = 0; j < stats->state_num; j++) {
-			if (len >= PAGE_SIZE)
+			if (len >= PAGE_SIZE - 1)
 				break;
 
 			if (pending)
@@ -157,12 +157,12 @@ static ssize_t show_trans_table(struct c
 
 			len += sysfs_emit_at(buf, len, "%9u ", count);
 		}
-		if (len >= PAGE_SIZE)
+		if (len >= PAGE_SIZE - 1)
 			break;
 		len += sysfs_emit_at(buf, len, "\n");
 	}
 
-	if (len >= PAGE_SIZE) {
+	if (len >= PAGE_SIZE - 1) {
 		pr_warn_once("cpufreq transition table exceeds PAGE_SIZE. Disabling\n");
 		return -EFBIG;
 	}


