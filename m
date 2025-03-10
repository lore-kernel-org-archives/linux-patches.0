Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEE6233731;
	Mon, 10 Mar 2025 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628109; cv=none; b=Gak+kKBNCrGlvs4bIoZOFOAvw2xBKS1hJOWf/VaOUzPRR80xvHdzA8u2N0a3rzKSKkWZJQD0iyFn2EqAW7bwDSIeNYIVQA1lEbti/npca3H2EN7dIJLkUgWVRzdWDL8tEmnHvRefSrrCcEvGUD9ePpi5YFRfvoSizuswoYJ1bdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628109; c=relaxed/simple;
	bh=Wxhu1vm6SGgoNkidjzBs30BcwJBv6SKNz4KV4EW9OOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8deFsZnc9isle5XAKVF2zi0MsOJWZK1NDON/LhPG4H1Z3RqMxmP++ny52nnqUqbP90D0mz8O7jKF+BUJfDKFA28WVAAP2YqezT+d0e6OowpOdAfi0rZkx8w4pQ7HIssl0AFNwAvrwUGz196u+gJlpu/IoYBkj2ym2xYFaaFv6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0p4HYn83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0p4HYn83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54500C4CEEF;
	Mon, 10 Mar 2025 17:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628109;
	bh=Wxhu1vm6SGgoNkidjzBs30BcwJBv6SKNz4KV4EW9OOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0p4HYn83yYKWIWotol/vNkp16EHILAaD+hfz5mf/VbieMAdPRBX2iLsStTZyQ98tN
	 P6wz3cC8sXSnSqTSsc4qz1VEVoFygHwrj+K04FNFXrRUtCy+mBGH+W1lk2UxszlXCY
	 4KwDAwFEQj5ZRy75A7LmX2Sm8RupVFkVjhBVUdU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/145] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:06:24 +0100
Message-ID: <20250310170438.386993394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



