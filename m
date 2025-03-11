Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125F249F9;
	Tue, 11 Mar 2025 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706291; cv=none; b=YPKors+SK3VCRBLd2Z7ZC0IEoT1SLom2ZG7Wo44p6NVkFTpOrEspxZvEYKY+C/w3TJq6B76YdofnK1i2l/CImVVy2MN64iXYD0+dRe0jTjy/dflQ34+3jytDQW7U9a6MfIUAJBoK/aKWaFLDCaTTzrr2T1vDOtkP5XjpwQ11XGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706291; c=relaxed/simple;
	bh=k66JOkOZIb8NJU0xJjMESxT9V5J5u9RkOPAYDnPmMw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkhvv96zF9Ygs+dW/pjfZ5N+LlqPPJ9o0keFOVA9Ny1EFJeEe1k4cj1dE9qhsyARPQ0iZp+SGMr7Gx40vK2D2v5TseDHSfB/wG8tGY/I6BSdsIUZu1tOZptQPOWefpsXu9znVRvn8YQUi2cti8XQ8OOx1q27B/MOsFVv1/MGd08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0ZmDY7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0ZmDY7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288B2C4CEE9;
	Tue, 11 Mar 2025 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706289;
	bh=k66JOkOZIb8NJU0xJjMESxT9V5J5u9RkOPAYDnPmMw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0ZmDY7RciysqrACCS/DI1wWm0P5zC6iva64j02SgcSRLdYU/I9tPuSoMxtzX2xEb
	 ibYItrIGBIEGxSiHjfDFyXlQQJYw1hXuSAcv77EgaTjdSjbH0ROE7FJ8hwow54TGT+
	 k3/wjkkil5+ktg+t3RRUkzSjerGa5PIhI/YSmgVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/328] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Tue, 11 Mar 2025 16:01:19 +0100
Message-ID: <20250311145727.190728807@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 5da15a9c11c1c47ef573e6805b60a7d8a1687a2a ]

Add missing skb_dst_drop() to drop reference to the old dst before
adding the new dst to the skb.

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250305081655.19032-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index dc01cdb043498..d54259b03a4d8 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -96,6 +96,7 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 	return dst_output(net, sk, skb);
 
-- 
2.39.5



