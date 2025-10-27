Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60732A3F2;
	Mon, 27 Oct 2025 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593309; cv=none; b=NCTUlP52cjgwtdgSnYNX12+1NFY2v6YasiuoSiGYKMjutw/G7Q02kh/xsvdKVC5DIs9AGKvIbbQBJiPpns+cPlRr8IUTzezPlrhsn+PvnSbmQmCZ26yI5m5uU9td+ndO8D/eqD6TDnQ00tyJU5N4ZyHPLRBtDXzpBsdVILlQlhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593309; c=relaxed/simple;
	bh=7cb4UbzG1S4Tk5KBbms/mtmfK57bgyRzYYcu2SMK9PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz+j073llB0jKHFJjD7Pi4jLIjWh7+dJ9XI/f1xrfVS48fXYjnueOUvLiO2fjT3e7vrMqswQm+xE58R2vhOAGGuc3TexwL86WQ6CDJ9g/u8BIecqwoTdlFPPAnrnR27fc1WTKeUBjnyDO2Jjl6NuycZWJMhgDUL17yo5UNhsucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta1w11Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta1w11Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2404C4CEF1;
	Mon, 27 Oct 2025 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593309;
	bh=7cb4UbzG1S4Tk5KBbms/mtmfK57bgyRzYYcu2SMK9PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta1w11UjEpNJrTpJL1HHBouFF2R8R+EeMsMnFTlfCEifihkmAmODqDCmLSQbXtQ8e
	 F+tzjbs0PGR0jIOCnaLLi4lV2tuNfyx/6cD/6X4qj7FQC8PGc+V7AM77RZpEVDKdFk
	 YAcBIpNgxIVW4QtQ2DyWwQ9C+A27fZCvebm7rVBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>
Subject: [PATCH 6.17 093/184] rv: Fully convert enabled_monitors to use list_head as iterator
Date: Mon, 27 Oct 2025 19:36:15 +0100
Message-ID: <20251027183517.404836055@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 103541e6a5854b08a25e4caa61e990af1009a52e upstream.

The callbacks in enabled_monitors_seq_ops are inconsistent. Some treat the
iterator as struct rv_monitor *, while others treat the iterator as struct
list_head *.

This causes a wrong type cast and crashes the system as reported by Nathan.

Convert everything to use struct list_head * as iterator. This also makes
enabled_monitors consistent with available_monitors.

Fixes: de090d1ccae1 ("rv: Fix wrong type cast in enabled_monitors_next()")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20250923002004.GA2836051@ax162/
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/r/20251002082235.973099-1-namcao@linutronix.de
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/rv/rv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/rv/rv.c b/kernel/trace/rv/rv.c
index 48338520376f..43e9ea473cda 100644
--- a/kernel/trace/rv/rv.c
+++ b/kernel/trace/rv/rv.c
@@ -501,7 +501,7 @@ static void *enabled_monitors_next(struct seq_file *m, void *p, loff_t *pos)
 
 	list_for_each_entry_continue(mon, &rv_monitors_list, list) {
 		if (mon->enabled)
-			return mon;
+			return &mon->list;
 	}
 
 	return NULL;
@@ -509,7 +509,7 @@ static void *enabled_monitors_next(struct seq_file *m, void *p, loff_t *pos)
 
 static void *enabled_monitors_start(struct seq_file *m, loff_t *pos)
 {
-	struct rv_monitor *mon;
+	struct list_head *head;
 	loff_t l;
 
 	mutex_lock(&rv_interface_lock);
@@ -517,15 +517,15 @@ static void *enabled_monitors_start(struct seq_file *m, loff_t *pos)
 	if (list_empty(&rv_monitors_list))
 		return NULL;
 
-	mon = list_entry(&rv_monitors_list, struct rv_monitor, list);
+	head = &rv_monitors_list;
 
 	for (l = 0; l <= *pos; ) {
-		mon = enabled_monitors_next(m, mon, &l);
-		if (!mon)
+		head = enabled_monitors_next(m, head, &l);
+		if (!head)
 			break;
 	}
 
-	return mon;
+	return head;
 }
 
 /*
-- 
2.51.1



