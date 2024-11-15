Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A846185924;
	Fri, 15 Nov 2024 06:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653939; cv=none; b=NP3ZFEria1fNNVttt6hhfJPW/twmvlXlKfz4qUtrQgiRZhpCZhsKMFF+8YYiAU9lD0tQ1zaBHnhnfCsUGaSz52gtbgX8ejyUmwhAGUnq+9d6arSkkzAqtzWoDObRr/Bq7UqT19vKdik+kO4yG1ZBTudgF7aqw6JpDLZRNvMVBH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653939; c=relaxed/simple;
	bh=ErOCJBN4pZxq8sJm+hVjEkhuQ0SelYqDjJF4aPv+uQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk+sYoKs3xsDRigPBpyU51EilxRekfDR8N1oT2Vzjg1+MjS1IBypcKeCocTbnUUnODoSkH7sok3mnRNunY4KXCAAcNFg/I2IPjmBd61j9n8r1MRl2CrJBiktyX0xQO1VWkzngaEvnSvNd1f47Sk6cE6YT5KwaMnA0p+Wy745QIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwGUpLYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwGUpLYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BB0C4CECF;
	Fri, 15 Nov 2024 06:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653939;
	bh=ErOCJBN4pZxq8sJm+hVjEkhuQ0SelYqDjJF4aPv+uQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwGUpLYJsAUTbwTR5n9Fj0ssy/n1413UndBgfP+oHnFHFhP7GAmIz5SIv1OHF/Hd9
	 Rj5zniiSCHoERll1o+zLD1lgqNvdWbFzlIKFTZy2zh5wn/ZZ07CqonGI4ZzNeWxSFW
	 u95xpq/WDLxu/Wn0ilQI6pwHnIa1GFk2MKqjSUwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 80/82] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Fri, 15 Nov 2024 07:38:57 +0100
Message-ID: <20241115063728.427662850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

commit 73254a297c2dd094abec7c9efee32455ae875bdf upstream.

The io_register_iowq_max_workers() function calls io_put_sq_data(),
which acquires the sqd->lock without releasing the uring_lock.
Similar to the commit 009ad9f0c6ee ("io_uring: drop ctx->uring_lock
before acquiring sqd->lock"), this can lead to a potential deadlock
situation.

To resolve this issue, the uring_lock is released before calling
io_put_sq_data(), and then it is re-acquired after the function call.

This change ensures that the locks are acquired in the correct
order, preventing the possibility of a deadlock.

Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240604130527.3597-1-hagarhem@amazon.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10653,8 +10653,10 @@ static int io_register_iowq_max_workers(
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -10679,8 +10681,11 @@ static int io_register_iowq_max_workers(
 	return 0;
 err:
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
+
 	}
 	return ret;
 }


