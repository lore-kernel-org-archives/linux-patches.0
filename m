Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642F230BE3;
	Mon, 10 Mar 2025 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626891; cv=none; b=YwhrJtq0oxJbDTOM88QJMbG7vHxp0ZSlCsZSOU3QXtvNPPDStwHik9jbM4plJ6Za65DLNZoRvSTL+KfHrAdWcoZIaQU6+nISetHwlZI1RZAmOCPSCLo0S1f8OlLQyBM+ehdEaJ5pfD/Io/CXJnvboXlsZX862p4/+g+yKDijwQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626891; c=relaxed/simple;
	bh=N87DRX63Opy6Ag09OgvysO5lNcxMwSi8f7QzeigOUoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkkCGaSJP77OmqtYKd3qhB90rQ0qeKg0qChBfWiW+9sWEhh1JmFLIhfeJptd7o6b4wDLvIAPv1bdPJrg1/15d1+poBCAF8f0GYE+m0J9iEaf1j0dnmKVSZSid/OyN4IoqZBZm8CYovjma3iuYWptaMDnqHyN2L9f+99t17SbI+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukXMNiW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukXMNiW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4A8C4CEE5;
	Mon, 10 Mar 2025 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626891;
	bh=N87DRX63Opy6Ag09OgvysO5lNcxMwSi8f7QzeigOUoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukXMNiW0BMtr9+U8pb1YLpNywTfQQXSyS1q+mr4lzz5ZUaW8BhbhN3aDJJubVmf+G
	 29c+u61b2hlODFSfUv91vZQCYH9aMXFdlauwUt1i9d+ps1DHxJUpBgbk3v22Idi0o0
	 ue6ELUjHtSTHUVtaQNfi4W4k55LMeTLntgwKlARg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 149/207] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:05:42 +0100
Message-ID: <20250310170453.720346828@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index ac4bcc623603a..7d574f5132e2f 100644
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



