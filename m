Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EAB1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF15CC433C7;
	Fri, 21 Jul 2023 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965525;
	bh=eA8JQEgqFu2ZIg0ANlG7K7fOTKvScLuDVLXUVHuDQ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YW0/IKwxu07RDiUmBqrYvmPb3LjCmovyOPxxxTo4RBW3jGcr3lrEI/iIWKrLxEBzW
	 PabjNli09EPn1rH6ulkRLOphjHSVXa91JRBjifL2iBaz0Ai9uvG+4AcUbODGQSMWTV
	 EVSKd+SOrUNwOX2MHZLgnUZUEltI/ofgIGD0JDxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dbueso@suse.de>,
	Li Zhijian <zhijianx.li@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/532] rcuscale: Always log error message
Date: Fri, 21 Jul 2023 17:58:46 +0200
Message-ID: <20230721160615.867877221@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhijian <zhijianx.li@intel.com>

[ Upstream commit 86e7ed1bd57d020e35d430542bf5d689c3200568 ]

Unconditionally log messages corresponding to errors.

Acked-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 23fc8df26dea ("rcu/rcuscale: Stop kfree_scale_thread thread(s) after unloading rcuscale")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 2cc34a22a5060..5c8449a8827a1 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -50,8 +50,8 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@linux.ibm.com>");
 	pr_alert("%s" SCALE_FLAG " %s\n", scale_type, s)
 #define VERBOSE_SCALEOUT_STRING(s) \
 	do { if (verbose) pr_alert("%s" SCALE_FLAG " %s\n", scale_type, s); } while (0)
-#define VERBOSE_SCALEOUT_ERRSTRING(s) \
-	do { if (verbose) pr_alert("%s" SCALE_FLAG "!!! %s\n", scale_type, s); } while (0)
+#define SCALEOUT_ERRSTRING(s) \
+	pr_alert("%s" SCALE_FLAG "!!! %s\n", scale_type, s)
 
 /*
  * The intended use cases for the nreaders and nwriters module parameters
@@ -514,11 +514,11 @@ rcu_scale_cleanup(void)
 	 * during the mid-boot phase, so have to wait till the end.
 	 */
 	if (rcu_gp_is_expedited() && !rcu_gp_is_normal() && !gp_exp)
-		VERBOSE_SCALEOUT_ERRSTRING("All grace periods expedited, no normal ones to measure!");
+		SCALEOUT_ERRSTRING("All grace periods expedited, no normal ones to measure!");
 	if (rcu_gp_is_normal() && gp_exp)
-		VERBOSE_SCALEOUT_ERRSTRING("All grace periods normal, no expedited ones to measure!");
+		SCALEOUT_ERRSTRING("All grace periods normal, no expedited ones to measure!");
 	if (gp_exp && gp_async)
-		VERBOSE_SCALEOUT_ERRSTRING("No expedited async GPs, so went with async!");
+		SCALEOUT_ERRSTRING("No expedited async GPs, so went with async!");
 
 	if (torture_cleanup_begin())
 		return;
@@ -845,7 +845,7 @@ rcu_scale_init(void)
 	reader_tasks = kcalloc(nrealreaders, sizeof(reader_tasks[0]),
 			       GFP_KERNEL);
 	if (reader_tasks == NULL) {
-		VERBOSE_SCALEOUT_ERRSTRING("out of memory");
+		SCALEOUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
@@ -865,7 +865,7 @@ rcu_scale_init(void)
 		kcalloc(nrealwriters, sizeof(*writer_n_durations),
 			GFP_KERNEL);
 	if (!writer_tasks || !writer_durations || !writer_n_durations) {
-		VERBOSE_SCALEOUT_ERRSTRING("out of memory");
+		SCALEOUT_ERRSTRING("out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
-- 
2.39.2



