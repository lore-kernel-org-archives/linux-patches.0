Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E7F426D2E;
	Wed, 23 Sep 2026 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174892; cv=none; b=Ddy/tB1bPM/mZFoup4kLBVk/gPlRYsnNtNJkgBDJ125L3F7gjMbNQ8czk5DkiWGv24gVDlifemQickUWvj/wmbUjs6W5G88UR5E3ZccsSPIg6kvQ7SXm7/SYNu/QBq9IpWrbV86W0RctxncbiafOGHrzQDfvr3Np7sQH9ESF9VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174892; c=relaxed/simple;
	bh=CYc9I2CJuE93DnLfJxul6kcZWqPh9D9Ijm+/fc8mNxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=advgmmMB5mkqM2FMda5o/hZgd9/d/M5W/YoCRGYc02TJ3sP772yllzt0/Nb3URyKuOENA00IOaIHbpK9UFc8tXzpzkcl7x1GqypZWdKQDoLnkJjoWcVY1cGjRx0sYKb8LFDhkaNuKN3fdkiJzAxhSMBBmsQjBA073c0klJbRA1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gb0uHmIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gb0uHmIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE401F000FF;
	Wed, 23 Sep 2026 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174891;
	bh=iBdLYKbo0DWtRYiamcfyRsxjM+dlToigi8wlfvX2HRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gb0uHmIf0T/ccq3n+QZPtb3mWc2AqJoCXFBTwGjUr3oDMWA7WMMzzcvVtVkw4+Wqt
	 Tc5G5CVRO9cMaAKeR2vQHz82cgoGuMX0t8RzRhRvu1X5g7MYxlgW3DjySQ1pkIXVkS
	 Gok1GIMwuu1J0ePTf63Ss5r9dunKtEccQ1ks/n10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 258/398] memstick: ms_block: destroy io_queue workqueue on removal
Date: Wed, 23 Sep 2026 16:05:32 +0200
Message-ID: <20260923140650.103309421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit 90af7fde083e1b22c349c3a8b1626728e44e474c upstream.

msb_init_disk() creates the per-card ordered workqueue msb->io_queue with
alloc_ordered_workqueue(). It is torn down with destroy_workqueue() only
on the init error path; msb_remove() never destroys it. msb_stop() merely
flushes the queue, and neither msb_data_clear() nor put_disk() free it. As
a result every card insert/remove cycle leaks the workqueue and its
kworker, exhausting kernel memory over repeated cycles.

Destroy the workqueue in msb_remove() after the disk has been removed and
the queue drained.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/ms_block.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2205,6 +2205,8 @@ static void msb_remove(struct memstick_d
 	msb_data_clear(msb);
 	mutex_unlock(&msb_disk_lock);
 
+	destroy_workqueue(msb->io_queue);
+
 	put_disk(msb->disk);
 	memstick_set_drvdata(card, NULL);
 }


