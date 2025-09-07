Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82CA15C158;
	Sun,  7 Sep 2025 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277031; cv=none; b=CqBQEmwPJ/o1GZPEQ5XiA8c27MUxcSHAgpLILuwG/eYhCOgZ+SXdw5aGuGLhNLJYDPJPejbIJCOFoRJKSQih8N7zfl/XXByruUh09Yt0LFyP5bGTmgeaXmTWgjDzYjedYIUuht2KzbqvZPrwv2UEbEXXQwOABvDddlh3C5V+F+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277031; c=relaxed/simple;
	bh=Nhq4xNU1rVQYLqAsihWyS3qR8fDdpaS1bd2mEGWA22o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N60WNJvYUrAA5oT4RjlcbDoiGF2uiaTuIEGZ+wlo1HZIrDZB244dHJ5QkOBlDPK7wk2/HGDc3O9Z0oj1CNi6XXTose6s1kaann/oNc6Jewfhz9BZ4sFTwjJS2vnjQT45hwgnN/alMYItjfu0Dn8BfmyAE2gwmDaakYVltNx/Aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PzhQOqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PzhQOqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29006C4CEF0;
	Sun,  7 Sep 2025 20:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277031;
	bh=Nhq4xNU1rVQYLqAsihWyS3qR8fDdpaS1bd2mEGWA22o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PzhQOqRnAXYSPYHfllAA62HxgKk143tmGnlPW/Q+gf8X1flEq6WByvKuqK3wX6GQ
	 0yBiaSju0O/x8UjgkVF+PyLcSD+ZEk6Q1h0ZUy3dwSYBQzP9WtxACHBK/elXuAtyaB
	 B6+LTVBL7BOMZy7FyMo7EhH9w4+IYy9Dogoig1pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/175] net: skb: add pskb_network_may_pull_reason() helper
Date: Sun,  7 Sep 2025 21:57:38 +0200
Message-ID: <20250907195616.331267586@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 454bbde8f0d465e93e5a3a4003ac6c7e62fa4473 ]

Introduce the function pskb_network_may_pull_reason() and make
pskb_network_may_pull() a simple inline call to it. The drop reasons of
it just come from pskb_may_pull_reason.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ead38147ebb ("vxlan: Fix NPD when refreshing an FDB entry with a nexthop object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b2827fce5a2de..314328ab0b843 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3153,9 +3153,15 @@ static inline int skb_inner_network_offset(const struct sk_buff *skb)
 	return skb_inner_network_header(skb) - skb->data;
 }
 
+static inline enum skb_drop_reason
+pskb_network_may_pull_reason(struct sk_buff *skb, unsigned int len)
+{
+	return pskb_may_pull_reason(skb, skb_network_offset(skb) + len);
+}
+
 static inline int pskb_network_may_pull(struct sk_buff *skb, unsigned int len)
 {
-	return pskb_may_pull(skb, skb_network_offset(skb) + len);
+	return pskb_network_may_pull_reason(skb, len) == SKB_NOT_DROPPED_YET;
 }
 
 /*
-- 
2.50.1



