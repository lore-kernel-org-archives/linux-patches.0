Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075ED1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBFCC433C8;
	Fri, 21 Jul 2023 18:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965720;
	bh=jlCYr7ahEk2pT0jHIZlgB0En+ajZ4AmaPnaZAjp2u4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjygJb76D27xgeuMYs+Nrg0RniRhOMheE4Ol/7X7aU/tJQdtaEIkWtP/XCyLrF0rp
	 xZsoyoIygClDU9PrCw8TPVWNWCHmc97kmcgeUwwpWxMD1kY6i/L0eJVkfI9XUGRAho
	 yvGt/LpG3RS4asDDwwpJPCvRJDahsqesm0Y2GjD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/532] lib/ts_bm: reset initial match offset for every block of text
Date: Fri, 21 Jul 2023 17:59:54 +0200
Message-ID: <20230721160619.454296420@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 6f67fbf8192da80c4db01a1800c7fceaca9cf1f9 ]

The `shift` variable which indicates the offset in the string at which
to start matching the pattern is initialized to `bm->patlen - 1`, but it
is not reset when a new block is retrieved.  This means the implemen-
tation may start looking at later and later positions in each successive
block and miss occurrences of the pattern at the beginning.  E.g.,
consider a HTTP packet held in a non-linear skb, where the HTTP request
line occurs in the second block:

  [... 52 bytes of packet headers ...]
  GET /bmtest HTTP/1.1\r\nHost: www.example.com\r\n\r\n

and the pattern is "GET /bmtest".

Once the first block comprising the packet headers has been examined,
`shift` will be pointing to somewhere near the end of the block, and so
when the second block is examined the request line at the beginning will
be missed.

Reinitialize the variable for each new block.

Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infrastructure strike #2")
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1390
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/ts_bm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 4cf250031f0f0..352ae837e0317 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -60,10 +60,12 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
 	struct ts_bm *bm = ts_config_priv(conf);
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
-	int shift = bm->patlen - 1, bs;
+	int bs;
 	const u8 icase = conf->flags & TS_IGNORECASE;
 
 	for (;;) {
+		int shift = bm->patlen - 1;
+
 		text_len = conf->get_next_block(consumed, &text, conf, state);
 
 		if (unlikely(text_len == 0))
-- 
2.39.2



