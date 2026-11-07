Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061382;
	b=R7x3UYG4PskoBpz4QJw4tqROc8xF4u9O2VZZHXayN9bhtibzEpvhbQhr2JOFHVDJSLXE
	 5NgqH7dEGdMpNR53gu9NAAizZEnpxCs+DDOTHzsme5UgqPRCGMt2X8BRLN/tILoabBXVB
	 +euKSdsuWdeARcqc4VuUzNukUPTwZpktoDjQTuKJ5WKYmwubFMzczOuOVLz9jIjt5K0cT
	 KyZxH7DCcZxYYgoCJyetU16hdV4ZvPUZl1VjDIfQmnzWqWkcHxkeHQkGFHGNk/WByIwdY
	 lAjThaaJbi3ANV+HSv6yrhbjgAd4iQ2iRxunXnBUNTP48tDF0pl34DNf9IYvarnllJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90ojAt9qa1CFrmECrew4qeXkLhYbhm2xkJoRaUHWjZM=;
	b=4tk0f1NJ0HUnL2iSttjgGoIU/U6uuR/qLr5HxCKA0P6JrZL37/jA5nxdrtwkjWg0qBQe
	 rRr97myBhm5g6J39eBa/hT/iIAiNJ8VlexMVJ5iRoSzKk66P4tkytWtD9svhxUkwgvWQK
	 Fy5+QDTg6Cft19FrNCNx7Rkdv6CRxzJZQZNkVipJ3AcZGhgyqOhdoy9umD9++x8FUwjPv
	 ZxWIE7ldlLmdeipSrHhR88MDCnjKKExkLxm19pkzRhLoxKGEv2tGFpv77MQY0ZOFtCqFE
	 AMci6t8z3C/atxeTxKl2r3uolewLzAF3q4mx2+8ds/i0Mn9Hbc8TIJjK2STsOYB/J5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxkYSQnv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D1606A33B;
	Sat,  7 Nov 2026 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WxkYSQnv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5876F1F008A1;
	Sat,  7 Nov 2026 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061381;
	bh=90ojAt9qa1CFrmECrew4qeXkLhYbhm2xkJoRaUHWjZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxkYSQnvnO2273DkSKxmu3pyvEp2o840sGw/wQKOqoDhVkZt89NSSzAO1Ab/mjaZT
	 HboOU8e1ezGS+LinueNtJkiVKrbAEylxKs6YCTeexBQnX7KAwTrgBNg+ddUOWa5lvb
	 KiZeyT2TNmFsE73OLbIzmzoLIxnkiS0YM+H0SCbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0504/1536] dm-integrity: fix NULL pointer dereference when the R flag is used
Date: Sat,  7 Nov 2026 08:42:00 -0500
Message-ID: <20261107135011.603223500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 7d4d4f3b668d708d94f62ecdd33ac330a6fd8a84 ]

If the dm-integrity device has the SB_FLAG_DIRTY_BITMAP flag set and the
user activates the device in the 'R' mode, a crash in dm_integrity_resume
happens because the function attempts to read the journal containing the
bitmap.

This patch makes dm-integrity skip any writes to the device in
dm_integrity_resume if the device is activated in the 'R' mode.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index cc0d49510434b..dbfe8128fcb26 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3723,6 +3723,10 @@ static void dm_integrity_resume(struct dm_target *ti)
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
+
+	if (ic->mode == 'R')
+		goto skip_writes;
+
 	if ((ic->sb->flags & flags) != flags) {
 		ic->sb->flags |= flags;
 		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
@@ -3832,6 +3836,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
-- 
2.53.0



