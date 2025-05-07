Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FA714A4C7;
	Wed,  7 May 2025 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643291; cv=none; b=F5Gv2Zf75n58FsAAqBET3ph7G+5sS2Z6uyk+0QSVzhjasXAwu+Ca31gwFRzIHTJRQOH8SDDsnoG8JvvyA5CDnLuYBUO0XXAgSA41v6BgOnljTWqXG2i/J8gfZMtKfh6deGDKXAS2L+p0c1APxc2x15gE2P9a8jzu+BSBBsqYpuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643291; c=relaxed/simple;
	bh=gUOk+U0ZqjsMKGkFaBRYIdT5ifBSGSw4EqNR3Mf2cis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4KQlMkuAex4ZrKLELpVV2SMyb71VkZgXpY7CI5O7G2HLEbkFSIssDufI/3Cm5fK5GVuBAHjMcKziNemEZDQQaQceih/2VBfB9WnTkZ8xTFA/heGB2C6dBDxxotSkfC0CAIfbLoFAUbIHIRfWh3vHY1BDklQcsMzoehvygJ2BuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6XYCWWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6XYCWWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988F7C4CEE2;
	Wed,  7 May 2025 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643291;
	bh=gUOk+U0ZqjsMKGkFaBRYIdT5ifBSGSw4EqNR3Mf2cis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6XYCWWAueTYVvXKWievlnjevqQ62QBFmV6o1TItvu3v4QMPsRdLC6hxbbxpcvIHj
	 XsLOrQ3OYGeSZzsA/A/2Q8OG19BihndDx7TmgxZa32jdXE3Wp5+JscahvLKFX/diIL
	 o1xXMvm1v0fuDrMbtGchlZQ5If+cfbqd4QcSQ/mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 11/55] dm-integrity: fix a warning on invalid table line
Date: Wed,  7 May 2025 20:39:12 +0200
Message-ID: <20250507183759.506637621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a533c3e4246c29d502a7e0fba0e86d80a906b04 upstream.

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4543,7 +4543,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


