Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036830;
	b=NgYqqAmxIKgeJORDm7pZlR35QdWmipb8KaYL+l+RImKjetWuRNHoRFHo1EqtzxUonS2k
	 eVPt5mqWNqoaP0dDWvGOo3rP+6sNF7Y5qa+C9W/nvLge6pHPohTZrzm8LymuLRh3GIOik
	 905KqilbVO9/h3z5KIYT7LcVWE5/Ti6sRHOM5cPN7O/qdujEz/lQUF3gDDGfvxKWYhF2M
	 jmgz6ntHv4+vQEm57sCbpWrQHdjXCOyJMIbKBtUesoaHAO7+LEce2zFAT3h7hPc6sKTVo
	 +EDwXJo6DFoAGVm6eQG5IJL52nU+5f4i83GXcM8PBDWCbMa6ZjnQCJZvx6qhFFk8kbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9IMeeS77bFz8WTJUtmq99XBVBylrmArHKnbFphPdlTo=;
	b=aEzdL0IeGaBFcH5BR8J/nJsjNTbz5VSnnCzXwatEsVTLTdI0LuKycMQxjW+JIUFx5O9f
	 fvNOINHsr/JnI60CbORS+NTqs0SLdW4eQSY02gHdrN6FUh91AZTTSkutYa3PZdWdGYp52
	 ODgxNfofHhJj9evd//tcNtlPiBm00fjcoUodjE9Pjp9e1CB7uclNQvOViVsMMWAz7ISpa
	 1OuCO6BOZiByxwUwpGavSMKv7WvUoaczr/DPuDOFbvegh0pewFuM7EWusb+OanxISf+xB
	 +fLldNTg5rxwGYikHxHl9ER5Pm5KOZwBxjmOO9lfodNYIfTz9civK/BlJ6Fv53YapwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUH4OMSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19EA606A320;
	Wed, 18 Nov 2026 21:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUH4OMSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B4F1F000C4;
	Wed, 18 Nov 2026 21:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036830;
	bh=9IMeeS77bFz8WTJUtmq99XBVBylrmArHKnbFphPdlTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUH4OMSoz1s2lIlKJcu261QtJ2MQIw3s/mQF5g1t0AGLV5CAmsRJa7E0QM1qwO0m2
	 zS/yelg8TQorbaHgRCQMbq1SpwlxOcO/jCEKn9BfntrJCo0ollKrP8WLGCcuPuoTL2
	 0yyFsu9wVph183y2WKKKQJyVjCXuatEocifh5kF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1158/3318] f2fs: flush SIT journal during filesystem resize
Date: Wed, 18 Nov 2026 15:29:40 +0100
Message-ID: <20261118150354.846954567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit a6ede405455106bf42164ec96fd84008c5aabdd9 ]

During a filesystem resize, SBI_IS_RESIZEFS prevents new SIT entries
from being added to the journal and forces existing entries to the SIT
area. However, f2fs_flush_sit_entries() returns early when there are no
new dirty sentries, leaving existing journal entries behind.

After the main area shrinks, a later checkpoint can access a journal
entry whose segment number is outside the new geometry and trigger
f2fs_bug_on().

Only take the zero-dirty fast path when entries may be written back to
the journal. This lets resize drain existing entries through
remove_sits_in_journal() even when there are no new dirty sentries.

Cc: stable@kernel.org
Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3ee0926843557..50a362256fab4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4315,7 +4315,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



