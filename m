Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D021E98EC;
	Tue, 11 Mar 2025 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707538; cv=none; b=BdAlLYmH1oI25j71HpjT8fDSu0psQ2WNOE0kbi6zFe4e1HSVtncUqKvW9yH2+JyI9zXFRRtCZc/9DMgWBm8Vz6niHmZFUu+A7J2Ste9f+MhqJshwgrwVsxK6Vz0JOJNhYwSJClFiCTeD1tJAEfqBJyxRiqfoC+oJuKcmHh6oWDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707538; c=relaxed/simple;
	bh=7hlwXxezaY8wMXZqnCdKndvbmCW3Gca8SfxLhMauflw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5JA7P6zId7rT8znquYghxp7CHJEqw/b5SSzzNhyTLnDtd3iZNym5dO0IvwCU+rVYIPHXYWC8EvUpdEF4tt6sPBcRq9hYtNL7EUtQrAMJ3T/+FnxiRT67fhLludmeikkRO5nGJDPN4VNuX6TnIV+0aKv701g/oou2ULJDoXFlSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvIvSyM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvIvSyM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A179C4CEE9;
	Tue, 11 Mar 2025 15:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707537;
	bh=7hlwXxezaY8wMXZqnCdKndvbmCW3Gca8SfxLhMauflw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvIvSyM4ibF0p5QbBygIH65uRwNdhR3YhuCz1fgZZTJBVwiI6gCCXKOCVMjuxvKUK
	 2fcgTNq5JjlIStAXxApxwd6d2KjUT1tsPx6fL+Z6wxeROTD/KLZ5nf9UztY32Yk//q
	 1UPX/5ssyGVCK20kxXIwq9RnNLfd8q9cMS8b7x5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/462] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Tue, 11 Mar 2025 16:01:29 +0100
Message-ID: <20250311145815.048981232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d37dda3d26fc..7397f764c66cc 100644
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



