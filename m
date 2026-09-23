Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02423ACF1C;
	Wed, 23 Sep 2026 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173650; cv=none; b=MDvCI5IgaNflnNXgLwukU/9B3Je6yh4ZS+pirxC86Odb0HzsMYoMdNJagZ6wChkZf3IA8zN44ywqvHA/I6abzh6A/ZxHUj5oqMDoXKTBvWJulHPD/ICuCfVIw+wBDvp7e9w33D1vfXcz34uGh3NLXEiaf51ObXiPGrAZhFH1zzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173650; c=relaxed/simple;
	bh=KCSD11N4uTtxW7zW4BJr2u/eaCkMW+moLsddD+R7W5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFsYPZ39XD7w5GMgetpDZz+X6P5oPaHQEHA/Cbo/MKLukgBdRhx/8udlhJonW5GXgL9qsGXbGOW+/PAFP534ahjRRyEFmHplb1KAHxCsEqSSmJZsZo7IbMB/RVDI3AFW5xN4WivfEAe0HIBcQbYiuVoxr7JybKkpRIpikXbmEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVarAQKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVarAQKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50D1F000FF;
	Wed, 23 Sep 2026 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173648;
	bh=tcSXOvhFThqeo8VaaLGkqpxwllf/+qntjnHtu9PIuWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVarAQKGNYwghVSuaUYbWVzh9E4HqMGAnpQu143ODsFv2h8OzkeffngXYYH6za2AB
	 lYN2Nn1styJyWpVcEuAcYLLOCNF59nTWBZ5Nnikq4xY8TB4Ms+xezYZk4KiZe/rKjL
	 89UcJ4IPNts41eqhv/cwWQ8in6LJUGm6aWECkE0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 312/438] memstick: ms_block: destroy io_queue workqueue on removal
Date: Wed, 23 Sep 2026 16:05:33 +0200
Message-ID: <20260923140652.867085163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2204,6 +2204,8 @@ static void msb_remove(struct memstick_d
 	msb_data_clear(msb);
 	mutex_unlock(&msb_disk_lock);
 
+	destroy_workqueue(msb->io_queue);
+
 	put_disk(msb->disk);
 	memstick_set_drvdata(card, NULL);
 }


