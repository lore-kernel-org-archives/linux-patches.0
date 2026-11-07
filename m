Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063324;
	b=5a2ehBZOkDyg3UZtbZa7cFKckB4ozJQX5nnLDf/wgwlHeWGS22K33NXDZM0hPNaEfW4O
	 7PwqAR0gIuphHmKaQnq55N6whlJPKdmRmJhrVo0po7OqU6svEYPD3QhFCiLJklu94HwHa
	 hk/ZNZKumA88mXi2Z3pRfuuTRvotCIFPUaQH/ohbRpm7Nyl5XiWQnPirL2JGR1VqK67lF
	 yHJQCLReV72V3NzxWnOtwOOFfdGwb2EsQCu/BaLsk1UJrPHUUfJfzrlJdyOkJ3SeopdCl
	 TuZSb3Fci82dJLz76BMMZlpNjbGFog7k9CFLeH3+4IxmkP6i/AKlGbJ21pcpb0xHc2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUrpOhPh0nqQwVeiFhEwCSfmrrMCwTr6Px6u/fWwCok=;
	b=AECjZf9xwJbPFGY2URl2n8ubjn5W7YPRtXuBlr4gs+KIOpALn9I9U3GI7xKBaX+FgJeJ
	 srzgIjWBEirU+QBHfFcwavRAvijmj2C+YHlAe7ejKk3o53qCBd2fx3Ral6h6wb8QmwizA
	 IXbtV09CXfQQUvFWUYP5khYYqoAv6YSr+r7kd9xrhqfZwsmE9CnVcsNHCSJ3yLlOzoC6v
	 au10f2xYMvCy6QirV7FNnfW9bd6+DhM/YS8WZyVRK8VkuBiLmLj+SkmKKdWwCSPaPejS6
	 hAysLEVdI7iBU0aARupFM+ZZyi7BJmo22mHMoivtq97f/fTUnGeoOP3xoWUODlFZmfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zqAU/7la";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE61606D810;
	Sat,  7 Nov 2026 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqAU/7la
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7631F008A5;
	Sat,  7 Nov 2026 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063323;
	bh=sUrpOhPh0nqQwVeiFhEwCSfmrrMCwTr6Px6u/fWwCok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqAU/7la3DKHkAbEokKZ2GT/rVaec/apxB8HyHUdsA87o/VKczXItDrto2A0Uy00I
	 fT58XGe5sL601cyjciXgMKLDRWukwA9RpDlGCmFjPfhmCxKH7Xw9IjMRssVrJPOQzW
	 p4XKE68UK3LqNOuQaOs6DjkgqPoYjmVlnsQMzLz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/869] dm-bufio: fix a race leading to an unsigned integer underflow
Date: Sat,  7 Nov 2026 08:53:10 -0500
Message-ID: <20261107134910.815093996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 005d2ec5723cd4ac740de678274623f1fadd6a6e ]

The function __scan tests "count - freed <= retain_target" and then sets
"atomic_long_set(&c->need_shrink, 0);" It exits with the condition "if
(!atomic_long_read(&c->need_shrink)) break;" It may be possible that
between these two statements, another thread sets &c->need_shrink to a
non-zero value. In this case, the function __scan continues and it may
possibly the "freed" variable is larger than the "count" variable. The
expression "count - freed" underflows and the function __scan will
continue to free all the buffers, even those that are below
retain_target.

Fix this bug by immediatelly exiting if we set
"atomic_long_set(&c->need_shrink, 0)"; and don't attempt to re-read
c->need_shrink afterwards.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 6d76511953a25..07e2f0fccefe5 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2402,8 +2402,10 @@ static void __scan(struct dm_bufio_client *c)
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		while (true) {
-			if (count - freed <= retain_target)
+			if (count - freed <= retain_target) {
 				atomic_long_set(&c->need_shrink, 0);
+				break;
+			}
 			if (!atomic_long_read(&c->need_shrink))
 				break;
 
-- 
2.53.0



