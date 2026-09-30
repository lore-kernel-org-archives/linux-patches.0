Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA552B1FB;
	Wed, 30 Sep 2026 17:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790510; cv=none; b=oB+cTMLSpU7OcUmANGY8lJAdxr1EfG6Y+LNsWeYPrNFuFpqk/t5shPDYm2wONL9TY5A/oBA4HEYQJ1Bz5HRnVZnJJFA0GdrOFRiLcIdV35CvOmUtI/HyhrFePmMrhfHJi6E0Ih2Q3sqXcrGG8mXwkVSPQdaYW6pd33/pDdvXd5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790510; c=relaxed/simple;
	bh=5EDJ2j5O/xFQxMfQywXyKsdezJ0Llyed6cDYozaWtqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5sUlUNQMzEN1QgZP06FaZ7SXLgYyOxV973tfhnBu5KodWX+xf7KhNIiwFfYH2XW8HPC/bn3EcShv28jEutCFSXWwqxaRC/eEtLN1hIxTJQbesqKZPXOwp0YN1hVMdW46Bl3fc+iE831Q3MjO2lFvxngrTczJlVBxdzOkOWThCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0EDTOcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0EDTOcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802E01F00898;
	Wed, 30 Sep 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790509;
	bh=jTnjnpj7w90kfOaqMeia8xj41VMVya4Y93k0YTSbD+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0EDTOccXyO8FMr+IBBTvIVNvnQOYa249F87kGpG14yFgdueX3xOjbEemstO/wjGQ
	 oogC9hbC6IoORol3tdtslQeqD1Hg0VBcBbfe+UBxrl7kl6PCRJQ6n7hHMLHFy8NgGK
	 KUsdVYR9FlJA8q8HSWhvWvJBF8xlDRN5wxdW16pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 854/877] rose: fix dev_put() leak in rose_loopback_timer()
Date: Wed, 30 Sep 2026 17:29:25 +0200
Message-ID: <20260930152433.169419666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


