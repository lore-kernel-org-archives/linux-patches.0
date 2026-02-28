Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBB82DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301792; cv=none; b=Vf311XzgV8f6ebZwgUzaT/xvZPU7VvXnTdXDrhYa9t7dujGVxyYf7deeZQIWBh5yEEpGc08wONC3Gjge4bG3Ukq1il/643+arI29sAlQc1UAZD8/1kTdBktxXi/4JS75Dm6tyiIqsODeK0yPxoQbVl3tkNVQVkFUaxsz8TN9nvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301792; c=relaxed/simple;
	bh=KfqdNIh7DPuUYajNio88cSrY7kv9+33s5rBAouYWIIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTDmH6vEvEDV5+ooojXmDx5vNTsy2Pxg3YYqXsKHBmPbL1AZvKMH+jgyfIM/pM9NvoUTeB2WByyQGjVICtVg267CRr9hBQe4guX2Q4Kbh8QGo+/GCWn9LnT+pz6fkmrVtuiSZXKjc5LaCAersMiZVmVVQRUv6Hht08vM6mpkIj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcQYXXyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcQYXXyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED933C19423;
	Sat, 28 Feb 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301792;
	bh=KfqdNIh7DPuUYajNio88cSrY7kv9+33s5rBAouYWIIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcQYXXyfPhl7PfcySBu0lE/Mz55Q83g0lcQx9odHER2TeKhPCXez6cmoF1X76ApQj
	 m+wtUyZfaXX1mZmEZ+1dMQECG1WOgBbwtwcRtRCDhthM95TFi5fFDihsk0Qnuk42C4
	 ax3VPTjIUNA/zM/Tc66k6SjcRyImTEX7B0wF7qOXNKxqoUIk0BZ65j7V935g9MJAtU
	 O4brQrPN1U8HAWjVZZl/1lDcJzzCAWLcXiacghad8NWFlc1mRY6Wy24y6XsUlmqpgP
	 XlEpm6lsBrdWfCwAdcU1N/EEfc0r8QIRmV04hQ8neg08JjIVuIgT/8wzA3QWmzRiL+
	 6zCL+KWLtL45Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/385] dm: use bio_clone_blkg_association
Date: Sat, 28 Feb 2026 12:57:04 -0500
Message-ID: <20260228180011.1568201-202-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 2df8b310bcfe76827fd71092f58a2493ee6590b0 ]

The origin bio carries blk-cgroup information which could be set from
foreground(task_css(css) - wbc->wb->blkcg_css), so the blkcg won't
control buffer io since commit ca522482e3eaf ("dm: pass NULL bdev to
bio_alloc_clone"). The synchronous io is still under control by blkcg,
because 'bio->bi_blkg' is set by io submitting task which has been added
into 'cgroup.procs'.

Fix it by using bio_clone_blkg_association when submitting a cloned bio.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220985
Fixes: ca522482e3eaf ("dm: pass NULL bdev to bio_alloc_clone")
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fd84a126f63fb..ec48fcdb19ed8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1386,6 +1386,8 @@ void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone)
 	if (!tgt_clone)
 		tgt_clone = clone;
 
+	bio_clone_blkg_association(tgt_clone, io->orig_bio);
+
 	/*
 	 * Account io->origin_bio to DM dev on behalf of target
 	 * that took ownership of IO with DM_MAPIO_SUBMITTED.
-- 
2.51.0

