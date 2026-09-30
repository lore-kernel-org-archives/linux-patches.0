Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB435187EF;
	Wed, 30 Sep 2026 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791061; cv=none; b=VQPCs+oQJKFO6ddqAFPY0tj4dInp7ppDnwbzP6X6O1Yw/SdiTftZpWXiL+o88j4QzUjj0GsUynbR8VOurOplnMy9WsYqk1OtERJf8ODQbikhRc//sqesk/IuZds5tDtrbB3aGCVnzDfytYGpgpkAVtH35Tw8SUy0Zq2JtopwjD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791061; c=relaxed/simple;
	bh=fyknMMkbYeJDiyR4Vm0LjMUm4r1fVd2aAwqKtdZi5ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgUBs3zwFkxI/JpvpmL7NjdOxS7OI1rFDpD0hgvsqTQ7ZK3MIGrbJ9b6fyfnS7lasgKwMUYxbapo19xag0mnYPAxLW9kaAvii2M1mGtrsE7PBb1RUhibctn2ABEs41v7znN1VHxfTKkTrH3sJ21TEWuOWdD0vBsnWi+wGcjtbXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFv++VT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFv++VT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5686A1F000FF;
	Wed, 30 Sep 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791059;
	bh=TDbb8wsT2BSAx9F5E62wi28RC6OgABPi57yKcn/3SjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFv++VT6knxtFHhDd96N8Py0gb0cl+lIKBvFkjEvcCTgAbk+Y91j8Wy5+LTwDikHr
	 tnUsfVImod8bbI5f9YCv97wa58xZar4+dTk6A8uwk5qgoghZxw5lvvOiebkKI3QiO9
	 bsNeY4liVqpNPFEyNmimbaLrsAjozSf5+4gGEWuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/752] md/raid5: let stripe batch bm_seq comparison wrap-safe
Date: Wed, 30 Sep 2026 17:20:38 +0200
Message-ID: <20260930152401.836201132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 00e93faf4cea9e8802ac5dfee0952d84fc95c40f ]

Once the 32-bit seq wraps, a newer bm_seq can look smaller
than old, so .. covert to wrap-safe calculate way.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7ecc339f34a27..901d1c8218746 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -911,7 +911,7 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
 		int seq = sh->bm_seq;
 		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
-		    sh->batch_head->bm_seq > seq)
+		    sh->batch_head->bm_seq - seq > 0)
 			seq = sh->batch_head->bm_seq;
 		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
 		sh->batch_head->bm_seq = seq;
-- 
2.53.0



