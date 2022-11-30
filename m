Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF4F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD9AC433C1;
	Wed, 30 Nov 2022 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833780;
	bh=X9pQl7qPJKt05DQwZOx/8QIpcMaJKUUJ9Xb+hErQcoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyc+8gJtjZsvRX8JysR5O6bSuz/z999Fv7e3NescKz3lJZVlPvh4VkUJw2beNMtUF
	 QLvIdS6cPmRnlcPSIYib8Dcw7RQqJGcdbwLLiJzNvjcCUoWLTfn8YNNj1Lvl02G0io
	 yHo7dXWXAKOwBznMHqe1wU5+NvD6zWBIqgKf8qko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 012/289] selftests/net: dont tests batched TCP io_uring zc
Date: Wed, 30 Nov 2022 19:19:57 +0100
Message-Id: <20221130180544.412360280@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9921d5013a6e51892623bf2f1c5b49eaecda55ac ]

It doesn't make sense batch submitting io_uring requests to a single TCP
socket without linking or some other kind of ordering. Moreover, it
causes spurious -EINTR fails due to interaction with task_work. Disable
it for now and keep queue depth=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/io_uring_zerocopy_tx.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 32aa6e9dacc2..9ac4456d48fc 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -29,7 +29,7 @@ if [[ "$#" -eq "0" ]]; then
 	for IP in "${IPs[@]}"; do
 		for mode in $(seq 1 3); do
 			$0 "$IP" udp -m "$mode" -t 1 -n 32
-			$0 "$IP" tcp -m "$mode" -t 1 -n 32
+			$0 "$IP" tcp -m "$mode" -t 1 -n 1
 		done
 	done
 
-- 
2.35.1



