Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E6C5FF19;
	Tue, 23 Jan 2024 00:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970167; cv=none; b=Xa7qMNZQFDRL6qtdY1a0MwHqE9OBDW0LhS6cyAykvygqh32HC81N15IUN3OVagRVFmtmimPH/d05X0w0DZnm63mNcUREj4srr1sz6D28qydKaHHwD+/6bqjWglcKJ1rPBLHlIy1/BR/E2AIGEQ5sLpCc8+1KbyfmgAEcce6wdjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970167; c=relaxed/simple;
	bh=Mg8OTdClf5f9sV7eEO1Pw+W3SSbscxMN15WWynBCn7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1/JY/oVgNaQdMhtkWpAiwItKdKTNyRXlellxg0FCqhvBFL4ve0OALgrI7t78CH5Fd4DM3Vg9TX9eGtWlJyOBPGMGxgjRnocFPN27+9F1ZY3fqNn3mWKS8UxC/rCeDCw/A1pU8dJ/JFyN9/IaiVtisZDLEk2EA2R5Q8YATApnc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFXRaFWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFXRaFWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09735C43390;
	Tue, 23 Jan 2024 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970166;
	bh=Mg8OTdClf5f9sV7eEO1Pw+W3SSbscxMN15WWynBCn7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFXRaFWrvp1sx2ssN9SSJ9hRv6zyVBTjqE86nWlZdoprw8ySVypO4qPxm4mmE7cRM
	 FL6IlDqFd1vrGDyO8yGFRQUYpvfhQIWa7EJOzTB4Pf0fgFT50vddS4SgJoe0ZILVvG
	 IpHrGyedTST3wZzipry65WWT73QbXYwe4Q+aENRE=
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
Subject: [PATCH 6.7 604/641] net: tls, fix WARNIING in __sk_msg_free
Date: Mon, 22 Jan 2024 15:58:28 -0800
Message-ID: <20240122235837.134025724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e37b4d2e2acd..31e8a94dfc11 100644
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



