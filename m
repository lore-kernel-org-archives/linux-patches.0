Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6572A185924;
	Fri, 15 Nov 2024 06:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653498; cv=none; b=ez8wlyH+pCsezE2kOVGZp17X2YRIzPsiQX2ncrlkV6TRMKol/x1Ei36hlU/os2wygspJeniO7eWlIe8W98wt42bRxNGUFKh4iIZhoKN3a2Mj5lFi2rPmI5aEelMeHue2yuBAjbh4ZAM0PfTHsKsw9bOkQgk7QjT2ILd8dwkpJqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653498; c=relaxed/simple;
	bh=cR9RGk++wTU7TOw0RtfzT2XHw88gASrF4vXtFoATw9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo6e8KE3YF3YyXbbiiz5d6JLR0XpSHY+NV7Cg3ThiXXos6dRVfuwENto6RCGM3lvHKy6MGghrU8sSYl6bbg0Fn6/NnXW+vLlxBbBFIfV2gaLeeHo5r/zgbWNOPGXhULmGBOOCeInr0CgY1v0tCQxfm0yloxMfKSZRl1xzQzGmpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHVXiBIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHVXiBIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA01C4CECF;
	Fri, 15 Nov 2024 06:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653497;
	bh=cR9RGk++wTU7TOw0RtfzT2XHw88gASrF4vXtFoATw9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHVXiBIrzsakEecYzA0xaoN6LrGXYkjaa6ydTDJ5iIjUY5k4tkoWRhPtlWCIiqND0
	 nU7g2nfdL3MWEJlb4IwXEXVF2ESY89Oy/8w/7DUhvlVpJALhYxEXAn5RbklC0VyX9e
	 /Y3p9qO8cLJZmztO6IC7r/KSPU0m15XOuSkPMZ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 40/48] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Fri, 15 Nov 2024 07:38:29 +0100
Message-ID: <20241115063724.410699530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4358,8 +4358,10 @@ static __cold int io_register_iowq_max_w
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -4384,8 +4386,11 @@ static __cold int io_register_iowq_max_w
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


