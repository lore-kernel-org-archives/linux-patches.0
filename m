Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767BE1BF7E5;
	Wed, 20 Nov 2024 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107704; cv=none; b=APV1U8Sme7n0Q88HCUJs2ZscfTl+2DqWg2/rMlU/IuaMlJ0XhClKYp91hs/SglXVEFeNJnGezcHrsk4M6UH2mql/0VdtJqU+3PFp3uDciFr5yHpofXZDCy8ZYZMFkWi/1dWqJx9P2Dpv79TY5OZ1oy60vwxZnY33F1txMshnABA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107704; c=relaxed/simple;
	bh=Lg3QSXIuqv1TNCqPulAV0h5wUOjZ53Ix+q58CEOisj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I78SzMdQLg24jvsvsyE28tggE5dsd07YWPJ34oxRmD9qHYdtmfHKzNT1eWeZSR3a9At+k2++dAHIHwWWS/2Efdks60bDgRBA+PdT59fmSa6MdvlhTEgi05wujlPZaDiPdGmG9e4ueSuN3hKi2NvIwYrMwmUnp/M73RLqzwHu8ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtbjASMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtbjASMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4961AC4CED1;
	Wed, 20 Nov 2024 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107704;
	bh=Lg3QSXIuqv1TNCqPulAV0h5wUOjZ53Ix+q58CEOisj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtbjASMX/trFWQoz2Xeg1amOP38fYVTDgbdhSE9iXX0g2tfV0Ofc+dXLxQM+I6JfZ
	 EXsaLJ02v+tyUXkPfmPmffY5HE56/JsO24Exm45KQvZaEnq5nfnkjUZM5R10KUk/re
	 0U4XWHR1cABRwxcWqF+plWndOwDgG+HJ20qNMV8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 68/73] null_blk: Remove usage of the deprecated ida_simple_xx() API
Date: Wed, 20 Nov 2024 13:58:54 +0100
Message-ID: <20241120125811.238796471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 95931a245b44ee04f3359ec432e73614d44d8b38 upstream.

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/bf257b1078475a415cdc3344c6a750842946e367.1705222845.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1764,7 +1764,7 @@ static void null_del_dev(struct nullb *n
 
 	dev = nullb->dev;
 
-	ida_simple_remove(&nullb_indexes, nullb->index);
+	ida_free(&nullb_indexes, nullb->index);
 
 	list_del_init(&nullb->list);
 
@@ -2103,7 +2103,7 @@ static int null_add_dev(struct nullb_dev
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
 
 	mutex_lock(&lock);
-	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
+	rv = ida_alloc(&nullb_indexes, GFP_KERNEL);
 	if (rv < 0) {
 		mutex_unlock(&lock);
 		goto out_cleanup_zone;


