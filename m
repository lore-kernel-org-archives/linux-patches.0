Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022123;
	b=SpCQQeKVnmmFY9PUVcrPmWdVgKyjGga8FjJC4bb2g7Ek2ZLJrZK5Aia5rkxBbRjAz+xP
	 abIsb6zo23haa7MopiA5pgsZlzpyUcqzqj1HgGacvRGHLnhYcichC7R6I71S3YfmPHq9U
	 hGM7npXIdjL6JK6DFC68utv7Fxb9VQ8G7mcCH+WYJ1ERwURmhnBv9OMS+vaWPEv7oIGBK
	 nljzf9e07NVXWZlnepNRu5/OZF2U8eTywDfo7/FlhStgIXXUKrAowpBeDMEj5phaVdiqe
	 l68b2ULoJLQCtj/OthSRUgihH6Y0MV+9CWUD9VF/9Mk4L7Ss7NsetuArewOMge22hCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8Dwm74kOldtiRJH+yaW2h/6+hI/H1bg98nhqGXs2Io=;
	b=GI48dW7qbfrIrLE90X0DGf4YLjsyu6pL8Zk9ck6L+CCo1SMn4mqRslKmscAxGOeJlo5S
	 YsNfhTmELscRVszWKTNkEdshOfyOLYtkXAlPRMbqxg6hJ7ceQR5g05R0OP4XEK/6WAnCz
	 vk13wiUN8yHLw5TAQEoXW+eG/iTmrSd/VFG55YaWG8IbjH14i84gzBMTRfFgaL1QOgygB
	 8vl7IO4+4ZwcSfZC1H0bJMe2w18p7i44uFtEJpeiVFtJ5QnwyuM4uG9rQxk34Tz8frX/Z
	 2I+5Ot96a8adbV0TZZ6w+yF9Pa9S/OUTc4rTs9eY3HBT4UGk8ZsA6Eu23aMaNRShNPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vK9TWiDT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74EC606A334;
	Wed, 18 Nov 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vK9TWiDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014F01F000C4;
	Wed, 18 Nov 2026 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022123;
	bh=n8Dwm74kOldtiRJH+yaW2h/6+hI/H1bg98nhqGXs2Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vK9TWiDTd/e6g8ALF2k0dgBay2smsPR+7AstHRj8NFB0qeOfz56hKUPBNq2Ka6XqW
	 o0/yNhBaVuK6lowBIyfSFg2WbZs7UVPKIGS9S5lQsq5yRACg1m74nEcks9uk1kTO5Z
	 u3pIx9fA7TszQn89YLY/+puxwpQaCZE3UiQl6Dyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2551/2651] blk-throttle: pass the I/O counts of a dead group on
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150416.341089491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 587edb931fdda032bcd63fdfb0db4ded75159ee9 ]

The recursive io_service_bytes and io_serviced files sum up the online
groups plus what dead descendants left in aux_cnt. That worked while the
counters lived in the blkg. Since commit 7ca464383aec they're in the
throtl_grp and nobody passes them up, so the files go backwards when a
child is removed. Add them to the parent in throtl_pd_offline().

Fixes: 7ca464383aec ("blk-throtl: stop using blkg->stat_bytes and ->stat_ios")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-26-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 4f10fe05744be..80a5e4b2872f9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1670,7 +1670,18 @@ static void tg_flush_bios(struct throtl_grp *tg)
 
 static void throtl_pd_offline(struct blkg_policy_data *pd)
 {
-	tg_flush_bios(pd_to_tg(pd));
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct throtl_grp *parent = blkg_to_tg(tg_to_blkg(tg)->parent);
+
+	tg_flush_bios(tg);
+
+	/* the recursive files of the ancestors go on counting what it did */
+	if (parent) {
+		blkg_rwstat_add_aux(&parent->stat_bytes, &tg->stat_bytes);
+		blkg_rwstat_add_aux(&parent->stat_ios, &tg->stat_ios);
+		blkg_rwstat_reset(&tg->stat_bytes);
+		blkg_rwstat_reset(&tg->stat_ios);
+	}
 }
 
 struct blkcg_policy blkcg_policy_throtl = {
-- 
2.53.0



