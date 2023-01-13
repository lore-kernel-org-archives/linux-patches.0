Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713DAD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 17:33:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B409A6BED3;
	Fri, 13 Jan 2023 17:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1673631232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I5p1sl5UkonA67eiR2ZIh8ljw7OWOp0Jz6f3VzMJyV8=;
	b=Aia1O321cPJ5o45Ya6hlaVP0P8WgdptZEyEAPHSz9nPii0NE4xth+RqbdF62zhtXgoV0Dr
	7CDghpl+16iTIPcuWJXZ/Hh6TPOr0xR1rf0QTi9JMZNtI/Hse1JbwU1LQd/qFSPOFwOE1z
	SQ1f1qSkXQ+9RbZPR6WtIDJWSVTv/Gs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1673631232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I5p1sl5UkonA67eiR2ZIh8ljw7OWOp0Jz6f3VzMJyV8=;
	b=3q0ttxkohrkzr0a6ThUGePUVcRDDWzjIVS582Cxk2Fu2xmI+YinzLJM3pjovCkLxwe/5xB
	R9qxBsgXMvbIlCDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7FEEA13913;
	Fri, 13 Jan 2023 17:33:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 6GeHHgCWwWP0dAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 13 Jan 2023 17:33:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: patches@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	regressions@leemhuis.info,
	Jiri Slaby <jirislaby@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@kernel.org>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	stable@vger.kernel.org
Subject: [PATCH for 6.1 regression] Revert "mm/compaction: fix set skip in fast_find_migrateblock"
Date: Fri, 13 Jan 2023 18:33:45 +0100
Message-Id: <20230113173345.9692-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.

We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
stalling CPU for long periods of time. Investigation of tracepoint data
shows that compaction is stuck in repeating fast_find_migrateblock()
based migrate page isolation, and then fails to migrate all isolated
pages. Commit 7efc3b726103 ("mm/compaction: fix set skip in
fast_find_migrateblock") was suspected as it was merged in 6.1 and in
theory can indeed remove a termination condition for
fast_find_migrateblock() under certain conditions, as it removes a place
that always marks a scanned pageblock from being re-scanned. There are
other such places, but those can be skipped under certain conditions,
which seems to match the tracepoint data.

Testing of revert also appears to have resolved the issue, thus revert
the commit until a more robust solution for the original problem is
developed.

It's also likely this will fix qemu stalls with 6.1 kernel reported in
Link 2, but that is not yet confirmed.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
Cc: <stable@vger.kernel.org>
---
 mm/compaction.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index ca1603524bbe..8238e83385a7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1839,6 +1839,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 					pfn = cc->zone->zone_start_pfn;
 				cc->fast_search_fail = 0;
 				found_block = true;
+				set_pageblock_skip(freepage);
 				break;
 			}
 		}
-- 
2.39.0

