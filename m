Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155591863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93174C43392;
	Wed, 28 Dec 2022 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239221;
	bh=fJx0AkQabyF5+jsQf/zYDxdUel1nIZr325rimG8VT1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyiCXT+GcuFDVU4DvwU+AzkxqIYXULTF9UEX5/XZJuItI1OIjeQNEr9DQOrB6fXEg
	 y0mOJZXZ6VaUTr6G1+R+TC/KBP+YPVlmCv9gXJSiy97gGJlmT7EBqV1ddXRwxpneVH
	 hDcy98PgX9er8UI9VsBPEAY1Y6ltA4fh19JkNZok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
	Colin Ian King <colin.i.king@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	wuchi <wuchi.zero@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/731] relay: fix type mismatch when allocating memory in relay_create_buf()
Date: Wed, 28 Dec 2022 15:34:04 +0100
Message-Id: <20221228144300.520334245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit 4d8586e04602fe42f0a782d2005956f8b6302678 ]

The 'padding' field of the 'rchan_buf' structure is an array of 'size_t'
elements, but the memory is allocated for an array of 'size_t *' elements.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20221129092002.3538384-1-Ilia.Gavrilov@infotecs.ru
Fixes: b86ff981a825 ("[PATCH] relay: migrate from relayfs to a generic relay API")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: wuchi <wuchi.zero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/relay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index d1a67fbb819d..6825b8403877 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -151,13 +151,13 @@ static struct rchan_buf *relay_create_buf(struct rchan *chan)
 {
 	struct rchan_buf *buf;
 
-	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t *))
+	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t))
 		return NULL;
 
 	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
-	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t *),
+	buf->padding = kmalloc_array(chan->n_subbufs, sizeof(size_t),
 				     GFP_KERNEL);
 	if (!buf->padding)
 		goto free_buf;
-- 
2.35.1



