Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA91DEFF7;
	Tue,  8 Oct 2024 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392917; cv=none; b=HrPkUef9XsM3oGGo0EcH31pe7aRt/yUUM27lYlNUDgsvLaKA6IY5b5P9XnLYaiLv75IYi0GOWxGo7l01X6/N+/vqlLqpURl7xUkiprMeGUOtyJ0HgUHPz5hgLnOByqA1aJATDBw+qMWswzxbKPNMxiFdbP2ZFAwHl4mewwxzq6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392917; c=relaxed/simple;
	bh=DbJUlqVE7BbUxFv141qubAf0WD/NgKtlMfAL9aU8sOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYJYatQsUlk9aEfjcJdGGOXvRuxRLhhvfJgdWAoU8w/ltXJaBSWZlbVSztcj/9wNH9/82kyeca/7CoQnH21dMTG6tOxH0GU2pgXd0wS5VU93A5aEQ4TptD2A6q4v6o5SbwZ/s7XlrBkRhrbri0sZ7VZqoQXKu9ta6tsFTOTU8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCWjdp62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCWjdp62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA31C4CECC;
	Tue,  8 Oct 2024 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392917;
	bh=DbJUlqVE7BbUxFv141qubAf0WD/NgKtlMfAL9aU8sOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCWjdp62q88wJb2ICkOO38kOQRjh5SREfNXMIjAboOfEhAo62j4ximg7Vbkotaic4
	 6IzgR6aWQMiTDqbg7/TJbvW8CEPlwX73Hw4H4TuFbbqFF3+4TtmqS7d97kyT1TaAWe
	 coN4DpwYgeV7P4clkd5ziqlUg5UcQK53pIJ8QvRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 558/558] pmdomain: core: Reduce debug summary table width
Date: Tue,  8 Oct 2024 14:09:48 +0200
Message-ID: <20241008115724.189586572@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c6ccb691d484544636bc4a097574c5c135ccccda upstream.

Commit 9094e53ff5c86ebe ("pmdomain: core: Use dev_name() instead of
kobject_get_path() in debugfs") severely shortened the names of devices
in a PM Domain.  Now the most common format[1] consists of a 32-bit
unit-address (8 characters), followed by a dot and a node name (20
characters for "air-pollution-sensor" and "interrupt-controller", which
are the longest generic node names documented in the Devicetree
Specification), for a typical maximum of 29 characters.

This offers a good opportunity to reduce the table width of the debug
summary:
  - Reduce the device name field width from 50 to 30 characters, which
    matches the PM Domain name width,
  - Reduce the large inter-column space between the "performance" and
    "managed by" columns.

Visual impact:
  - The "performance" column now starts at a position that is a
    multiple of 16, just like the "status" and "children" columns,
  - All of the "/device", "runtime status", and "managed by" columns are
    now indented 4 characters more than the columns right above them,
  - Everything fits in (one less than) 80 characters again ;-)

[1] Note that some device names (e.g. TI AM335x interconnect target
    modules) do not follow this convention, and may be much longer, but
    these didn't fit in the old 50-character column width either.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/f8e1821364b6d5d11350447c128f6d2b470f33fe.1725459707.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/core.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3182,7 +3182,7 @@ static void rtpm_status_str(struct seq_f
 	else
 		WARN_ON(1);
 
-	seq_printf(s, "%-25s  ", p);
+	seq_printf(s, "%-26s  ", p);
 }
 
 static void mode_status_str(struct seq_file *s, struct device *dev)
@@ -3191,7 +3191,7 @@ static void mode_status_str(struct seq_f
 
 	gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
 
-	seq_printf(s, "%9s", gpd_data->hw_mode ? "HW" : "SW");
+	seq_printf(s, "%2s", gpd_data->hw_mode ? "HW" : "SW");
 }
 
 static void perf_status_str(struct seq_file *s, struct device *dev)
@@ -3226,7 +3226,7 @@ static int genpd_summary_one(struct seq_
 	else
 		snprintf(state, sizeof(state), "%s",
 			 status_lookup[genpd->status]);
-	seq_printf(s, "%-30s  %-49s  %u", genpd->name, state, genpd->performance_state);
+	seq_printf(s, "%-30s  %-30s  %u", genpd->name, state, genpd->performance_state);
 
 	/*
 	 * Modifications on the list require holding locks on both
@@ -3242,7 +3242,7 @@ static int genpd_summary_one(struct seq_
 	}
 
 	list_for_each_entry(pm_data, &genpd->dev_list, list_node) {
-		seq_printf(s, "\n    %-50s  ", dev_name(pm_data->dev));
+		seq_printf(s, "\n    %-30s  ", dev_name(pm_data->dev));
 		rtpm_status_str(s, pm_data->dev);
 		perf_status_str(s, pm_data->dev);
 		mode_status_str(s, pm_data->dev);
@@ -3260,9 +3260,9 @@ static int summary_show(struct seq_file
 	struct generic_pm_domain *genpd;
 	int ret = 0;
 
-	seq_puts(s, "domain                          status          children                           performance\n");
-	seq_puts(s, "    /device                                             runtime status                           managed by\n");
-	seq_puts(s, "------------------------------------------------------------------------------------------------------------\n");
+	seq_puts(s, "domain                          status          children        performance\n");
+	seq_puts(s, "    /device                         runtime status                  managed by\n");
+	seq_puts(s, "------------------------------------------------------------------------------\n");
 
 	ret = mutex_lock_interruptible(&gpd_list_lock);
 	if (ret)


