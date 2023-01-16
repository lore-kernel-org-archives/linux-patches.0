Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608086FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34E5C433D2;
	Mon, 16 Jan 2023 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888366;
	bh=EOIkK71oPEcYimMfZ+unnaVKkHdMnF3btNm6vMz2ayY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgFTZw7peEkMM3MNYlTkN7OxKZP2zkXLIwBiybQULi5QIiVwO1ypWGuLjhAusJM3n
	 hsQhDzoxPPGokh7RXkcxRSEqFyHB2O2Ig1K2I94m1mjtpUOq3r8RLgdyjeq/TBtNct
	 +eHYwnPIjv+W7JOvGxPfhD1tFThQj74dWwW2ANGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliav Farber <farbere@amazon.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 4.19 502/521] EDAC/device: Fix period calculation in edac_device_reset_delay_period()
Date: Mon, 16 Jan 2023 16:52:44 +0100
Message-Id: <20230116154909.653542693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eliav Farber <farbere@amazon.com>

commit e84077437902ec99eba0a6b516df772653f142c7 upstream.

Fix period calculation in case user sets a value of 1000.  The input of
round_jiffies_relative() should be in jiffies and not in milli-seconds.

  [ bp: Use the same code pattern as in edac_device_workq_setup() for
    clarity. ]

Fixes: c4cf3b454eca ("EDAC: Rework workqueue handling")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20221020124458.22153-1-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_device.c |   17 ++++++++---------
 drivers/edac/edac_module.h |    2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -424,17 +424,16 @@ static void edac_device_workq_teardown(s
  *	Then restart the workq on the new delay
  */
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
-					unsigned long value)
+				    unsigned long msec)
 {
-	unsigned long jiffs = msecs_to_jiffies(value);
+	edac_dev->poll_msec = msec;
+	edac_dev->delay	    = msecs_to_jiffies(msec);
 
-	if (value == 1000)
-		jiffs = round_jiffies_relative(value);
-
-	edac_dev->poll_msec = value;
-	edac_dev->delay	    = jiffs;
-
-	edac_mod_work(&edac_dev->work, jiffs);
+	/* See comment in edac_device_workq_setup() above */
+	if (edac_dev->poll_msec == 1000)
+		edac_mod_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
+	else
+		edac_mod_work(&edac_dev->work, edac_dev->delay);
 }
 
 int edac_device_alloc_index(void)
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -57,7 +57,7 @@ bool edac_stop_work(struct delayed_work
 bool edac_mod_work(struct delayed_work *work, unsigned long delay);
 
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
-					   *edac_dev, unsigned long value);
+					   *edac_dev, unsigned long msec);
 extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);


