Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB41315D54;
	Sun,  7 Sep 2025 20:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277366; cv=none; b=UpeB0Pu6RK1Z5jHk9sox2hEZ19gsOzfepQY6wvtC0A1kbfz0n66pACHaxsZ+pz8vKOtR48AJu5RehAQ04ECmfBHqHmpMJanjhW30liJ9Rob8EtJNDoxwZAeb1kJCQChfTisGJ4jAGuDt7nSc8U3frrTmPI0rQaCN8ToiSyIm34c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277366; c=relaxed/simple;
	bh=HWjArLJjF0dMCGA+SbAuHdznI9KinTqMzptIsYHIVRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBkymNcyOIUGwAekWL3JaL9FINtuEX6I7/kAwZmYGE9LHB1fhCryXEPqvj+JU1Mi4zt0zoxs40sQFvFt2Z8/GeYx8NkC2a3Kab1BfaEcGMAPIMug1e/k1LbXLZ6o8HMUREO3p9R5tW1XSuW4SHQ1BNDK4Jb9AFJEJv6Cpx4nBMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmYLzYFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmYLzYFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4242EC4CEF0;
	Sun,  7 Sep 2025 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277365;
	bh=HWjArLJjF0dMCGA+SbAuHdznI9KinTqMzptIsYHIVRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmYLzYFReiT1xMzwW2WtKFqvT5RNVHasWhtdnTnRiAqv88yO6aDfSt6UtAV/VkO/i
	 XE6fq65ecaOQRhyyzfkJfeXlceTYiLnBtMJO6nbmakHrQgYX3yAnn88rrHqWApw7fK
	 mv9KwBZXEZ0LDQNRAAB6VPoiFg5siAl407XpfWMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/175] md: prevent incorrect update of resync/recovery offset
Date: Sun,  7 Sep 2025 21:59:22 +0200
Message-ID: <20250907195618.810448982@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 7202082b7b7a256d04ec96131c7f859df0a79f64 ]

In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
call to md_sync_position() will return MaxSector. This causes
'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
which incorrectly signals that recovery/resync has completed, even though
disk data has not actually been updated.

To fix this issue, skip updating any offset values when the sync action
is FROZEN. The same holds true for IDLE.

Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
Signed-off-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250904073452.3408516-1-linan666@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4b32917236703..d263076442924 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8996,6 +8996,11 @@ void md_do_sync(struct md_thread *thread)
 	}
 
 	action = md_sync_action(mddev);
+	if (action == ACTION_FROZEN || action == ACTION_IDLE) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		goto skip;
+	}
+
 	desc = md_sync_action_name(action);
 	mddev->last_sync_action = action;
 
-- 
2.51.0



