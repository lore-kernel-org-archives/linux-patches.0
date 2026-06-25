Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A69B2DF142;
	Thu, 25 Jun 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392967; cv=none; b=WUdbtYdxN0aWLcJ6K6HCQw81knFc9UiLoW+29PLbo0o3ZEuEnfWAQF0wYtk73qLDn5eluIfpEx2KdOmqNeXlfgz0RHJaCKU/cwKgKGACEbZejEnhTIWr7MQ9GF+2HBty/QU6zA96z5cx3K/+HKcFw2NcnuU59Vqg2ht6M3ZRUAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392967; c=relaxed/simple;
	bh=rUfA0pA8Xa/zAJrpbgX9pNFP2EdD54C5ecv/iJ7mzAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnCOa+O50g2lLjhtXpitWqxHP7dYa59xy55gbaKtpXSnUbeUYeo8kPOj7IRmQ2D/rngS9nHmmKtLtqvEx6DOSa2ID7ZO4JgJxDUbWmWRPui3cbQlYpepcXKP+P0TDzixINTorWERW/VO4F2iACaHc1seaOC8iisQaGKrdhtwES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAnh0HmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAnh0HmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B411F000E9;
	Thu, 25 Jun 2026 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392965;
	bh=j6fz2ELBCmcVIkJoUp0M/2P77tWjJivYilRPOoad/qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAnh0HmG4RGmUSFL+AjPAXu2r7rKq9aUqZqbTN1HmCfqTJtmCM2Tl2HJAX6PHG4zx
	 kbwucgT/t7vgojUdYKlYKfnMyXvWUdLXoZZHkAM3cUZgo1/2NZeZnPUQ/7eBoiXtSE
	 Y6VjiniAjfw2RxJ9UFltEzFMkzMkFZcy5jh8W1Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 16/49] rose: fix dev_put() leak in rose_loopback_timer()
Date: Thu, 25 Jun 2026 14:03:28 +0100
Message-ID: <20260625125639.767732237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit ff91adc54db2b62c7cdf063ff761eceb5adf2215 upstream.

rose_rx_call_request() always consumes or returns the skb but never
releases the device reference obtained from rose_dev_get().  When
rose_rx_call_request() succeeds (returns non-zero) dev_put() was never
called, leaking one reference per loopback CALL_REQUEST.

Move dev_put() outside the conditional so it is called unconditionally
after rose_rx_call_request() in all cases.

Also remove the dead check (!rose_loopback_neigh->dev &&
!rose_loopback_neigh->loopback) that immediately precedes it: the
loopback neighbour always has loopback=1 so this condition can never
be true.

Fixes: 0453c6824595 ("net/rose: fix unbound loop in rose_loopback_timer()")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,22 +96,15 @@ static void rose_loopback_timer(struct t
 		}
 
 		if (frametype == ROSE_CALL_REQUEST) {
-			if (!rose_loopback_neigh->dev &&
-			    !rose_loopback_neigh->loopback) {
-				kfree_skb(skb);
-				continue;
-			}
-
 			dev = rose_dev_get(dest);
 			if (!dev) {
 				kfree_skb(skb);
 				continue;
 			}
 
-			if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0) {
-				dev_put(dev);
+			if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 				kfree_skb(skb);
-			}
+			dev_put(dev);
 		} else {
 			kfree_skb(skb);
 		}


