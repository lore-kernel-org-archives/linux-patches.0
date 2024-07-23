Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B6713D896;
	Tue, 23 Jul 2024 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759983; cv=none; b=TcPwEkGoqxkLvTZ4ZI7n3FbJDW7a1NfehVTK5/AcEOJfIx7arRY2d3XIDspaSfLEbOqq8GpCgrzbsmpBsEilX6prt968cuNpoX93bjxc1PCj1fwEoW//azcaFkuGXb7AeYaVjdv4RFcq5U4veX6CkoHAuHcbASYqwjGV8FzaHRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759983; c=relaxed/simple;
	bh=/a2VGOh8/7YdD6r24cikY1SonOSdSaD9iwNG8mlhHZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADMzgUEfAe+50n9tbYZ95Xh3zfWnYB4rL+JpW0OBVAa+kst4IjS49uK+PYWljr1JW1coa6UfpLQLNaeEoqVLIoJ0sgP8YMaoZgpg0K70cOocc/I6YGL9mZ1DqMz3eFshQn/+I2k9UjWTp3nUrc3I2SpugwOsw7oVOvRsTY8eMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ1vw4o4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ1vw4o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2429C4AF09;
	Tue, 23 Jul 2024 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759983;
	bh=/a2VGOh8/7YdD6r24cikY1SonOSdSaD9iwNG8mlhHZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ1vw4o48W2Bw5Wjc2jcy9MOwNG/VQ7SPNMlXlbr7YwaoiRPJUyY/ynXXMo8KNDgA
	 58dLi5IWRmahOJ3sS7K+HJ5FfwANT/1I5U7x+gBEJaV/27kdufzMZaTDkecxeEEpLa
	 l0bWjDVtrWQvkpGPNWoc7lecs7VEGrQJxV3PIqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 036/163] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Tue, 23 Jul 2024 20:22:45 +0200
Message-ID: <20240723180144.867564832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit 73254a297c2dd094abec7c9efee32455ae875bdf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/register.c b/io_uring/register.c
index 99c37775f974c..1ae8491e35abb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -355,8 +355,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -381,8 +383,10 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return 0;
 err:
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 	return ret;
 }
-- 
2.43.0



