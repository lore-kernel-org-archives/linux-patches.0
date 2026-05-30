Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D93148DA;
	Sat, 30 May 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161231; cv=none; b=FD5qVrDS2bXLP+htKLhKcczK214x2itkMNFnSfUUgvlTP/K6N/7AhpH6aXT2uiM8+xQmAFSSCq3qMKsNDTCgNQgNGyYu8itD2Af/HgKlqipMEMrGbMNPMg3WI870AcL0BfwN3QO7qKR+5S7wH0YmhK8PAejJyzx1Yk5umb7Pgro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161231; c=relaxed/simple;
	bh=e1FoCwN6zW+BbEJm+Ix8TTAhuBoUtH/eNDvKgG+n1RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrqhVP0ecgdZFXrRuyP1MX+dfBtZR734cZtUExQqgLfvjFA83T6yji+/A0P1AkQYaiDe2f6kreH2IxThT4TS5hbYazpbioPJu7xIJegY2HLpwUhhVSkvvqRNegokSQhGzrYuh1DJRVLr6Rr2Ts7dtLGpQTubqwn80sUT8WuCY/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUu1yLP9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUu1yLP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B5D1F00893;
	Sat, 30 May 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161230;
	bh=4zvXf9xdHpOMVULEqDE1aoWSLUei/qcOp5llj/2zn3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUu1yLP9ua1d6xODqla1N835ePGzfMv/bnspU6yAbFcJM6CfuEB4jWLsKvSQ7dWak
	 UST4GkYUGfnXCCdxhZpWtQKvdIk34foR2CfWVKhgOfDbSz4sCNuzrH046CN5sdH9vH
	 oxMa/xcz4wfnG6ai2XI26bYhgoafy9wMsFS8ZXHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 562/969] dm cache: fix missing return in invalidate_committeds error path
Date: Sat, 30 May 2026 18:01:26 +0200
Message-ID: <20260530160315.905861333@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 8c0ee19db81f0fa1ff25fd75b22b17c0cc2acde3 ]

In passthrough mode, dm-cache defers write submission until after
metadata commit completes via the invalidate_committed() continuation.
On commit error, invalidate_committed() calls invalidate_complete() to
end the bio and free the migration struct, after which it should return
immediately.

The patch 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
omitted this early return, causing execution to fall through into the
success path on error. This results in use-after-free on the migration
struct in the subsequent calls.

Fix by adding the missing return after the invalidate_complete() call.

Fixes: 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/dm-devel/adjMq6T5RRjv_uxM@stanley.mountain/
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index cd48cefe0409a..e47033fc53106 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1502,8 +1502,10 @@ static void invalidate_committed(struct work_struct *ws)
 	struct bio *bio = mg->overwrite_bio;
 	struct per_bio_data *pb = get_per_bio_data(bio);
 
-	if (mg->k.input)
+	if (mg->k.input) {
 		invalidate_complete(mg, false);
+		return;
+	}
 
 	init_continuation(&mg->k, invalidate_completed);
 	remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
-- 
2.53.0



