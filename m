Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F8C79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021D4C433D6;
	Wed, 30 Nov 2022 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834544;
	bh=NCRGAT2Gx7skLD4WtpLnyquFa8TS3jhU4BXj/V3O31I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzHE06OzJgUcdtYYgtpAywS/PaF6N72MFKijeFJ868Xhb/wZ67O0pwSm8UaESe2mw
	 rfZtmdlbnBm9dqPExt3EhgnLVZCiORUhLFU87A9SWiJ8xiOLFDxAGnReIP7drv7CMn
	 cCdgfbHrHOfaPCOWgNyzQxvyYTj7nZcK/rtCzaSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 265/289] dm integrity: clear the journal on suspend
Date: Wed, 30 Nov 2022 19:24:10 +0100
Message-Id: <20221130180550.107773552@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 984bf2cc531e778e49298fdf6730e0396166aa21 ]

There was a problem that a user burned a dm-integrity image on CDROM
and could not activate it because it had a non-empty journal.

Fix this problem by flushing the journal (done by the previous commit)
and clearing the journal (done by this commit). Once the journal is
cleared, dm-integrity won't attempt to replay it on the next
activation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index f26a6cd09e0c..e97e9f97456d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -263,6 +263,7 @@ struct dm_integrity_c {
 
 	struct completion crypto_backoff;
 
+	bool wrote_to_journal;
 	bool journal_uptodate;
 	bool just_formatted;
 	bool recalculate_flag;
@@ -2375,6 +2376,8 @@ static void integrity_commit(struct work_struct *w)
 	if (!commit_sections)
 		goto release_flush_bios;
 
+	ic->wrote_to_journal = true;
+
 	i = commit_start;
 	for (n = 0; n < commit_sections; n++) {
 		for (j = 0; j < ic->journal_section_entries; j++) {
@@ -3100,6 +3103,14 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
+		if (ic->wrote_to_journal) {
+			init_journal(ic, ic->free_section,
+				     ic->journal_sections - ic->free_section, ic->commit_seq);
+			if (ic->free_section) {
+				init_journal(ic, 0, ic->free_section,
+					     next_commit_seq(ic->commit_seq));
+			}
+		}
 	}
 
 	if (ic->mode == 'B') {
@@ -3127,6 +3138,8 @@ static void dm_integrity_resume(struct dm_target *ti)
 
 	DEBUG_print("resume\n");
 
+	ic->wrote_to_journal = false;
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
-- 
2.35.1



