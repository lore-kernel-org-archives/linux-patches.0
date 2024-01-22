Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B2BEAEF;
	Tue, 23 Jan 2024 02:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975789; cv=none; b=j99ng+FDdgP0Rpa+Ieii36b3CY38GwSmB/nMPYgFPjcVqWFSLSCPpiXKHLj/3zkRP1NL6BmUU1Ff/UfzlGlZe3l0fqJ+WA3y5f8znRkUutHTkutXJgOHQXrkD6/WqOf9SOUX3wjKVzhqZi5HPc5wY9Sd1xmYczpc+9WnNZD/arA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975789; c=relaxed/simple;
	bh=N6lCFlOUfK84rG1zDggH6ln4Qzu8KBJFlDrTHvjIQ8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2Khh67Z7nM+OSYlO8g4jfQsrAGQAYaSFmgAx3AI1YPyHLVM+Q+m3f2XoklyuD5viaRfz6cwwPeaj7NpgQfLkfxCm8hdPjodlGE4Jmaun+/wNjlgwJK4Vt1dEGHQouUDOdwNFW4EnAD8QW7i2f8DRneVEGolpRywzOKeAsT18VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQfllzLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQfllzLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E41AC43399;
	Tue, 23 Jan 2024 02:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975789;
	bh=N6lCFlOUfK84rG1zDggH6ln4Qzu8KBJFlDrTHvjIQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQfllzLIyFezA76tzwSYWSRUjyOSuWoQEI15SaJswLEQt3OY/sRhirzFmccyNa0Av
	 /WmGA8MxkPsljbRm0U8VYzmVRyzKTqPuo3ztUa+pu92t1LD3nBFFIP++vhQWJSOrrg
	 obifxXBWVfqU8NnFQBvte8zHMkpEZqkgiAi5Y6oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+f2977222e0e95cec15c8@syzkaller.appspotmail.com
Subject: [PATCH 6.6 546/583] net: tls, fix WARNIING in __sk_msg_free
Date: Mon, 22 Jan 2024 15:59:57 -0800
Message-ID: <20240122235828.842083183@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit dc9dfc8dc629e42f2234e3327b75324ffc752bc9 ]

A splice with MSG_SPLICE_PAGES will cause tls code to use the
tls_sw_sendmsg_splice path in the TLS sendmsg code to move the user
provided pages from the msg into the msg_pl. This will loop over the
msg until msg_pl is full, checked by sk_msg_full(msg_pl). The user
can also set the MORE flag to hint stack to delay sending until receiving
more pages and ideally a full buffer.

If the user adds more pages to the msg than can fit in the msg_pl
scatterlist (MAX_MSG_FRAGS) we should ignore the MORE flag and send
the buffer anyways.

What actually happens though is we abort the msg to msg_pl scatterlist
setup and then because we forget to set 'full record' indicating we
can no longer consume data without a send we fallthrough to the 'continue'
path which will check if msg_data_left(msg) has more bytes to send and
then attempts to fit them in the already full msg_pl. Then next
iteration of sender doing send will encounter a full msg_pl and throw
the warning in the syzbot report.

To fix simply check if we have a full_record in splice code path and
if not send the msg regardless of MORE flag.

Reported-and-tested-by: syzbot+f2977222e0e95cec15c8@syzkaller.appspotmail.com
Reported-by: Edward Adam Davis <eadavis@qq.com>
Fixes: fe1e81d4f73b ("tls/sw: Support MSG_SPLICE_PAGES")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 27cc0f0a90e1..dba523cdc73d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1052,7 +1052,11 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 			if (ret < 0)
 				goto send_end;
 			tls_ctx->pending_open_record_frags = true;
-			if (full_record || eor || sk_msg_full(msg_pl))
+
+			if (sk_msg_full(msg_pl))
+				full_record = true;
+
+			if (full_record || eor)
 				goto copied;
 			continue;
 		}
-- 
2.43.0



