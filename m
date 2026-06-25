Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C32E091B;
	Thu, 25 Jun 2026 13:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392970; cv=none; b=eXdvXJODKEYsHHG0Jwwi/Cewj7B3c8qYPWqNC4a/KZ21VWAA5th5Yl3SAtg5QsqjkBEfxymAnxscTweQ+A7w42PYi1pbtRQI6yFPN9hDYW+1qKQxANIamHW8ImMb4g+ddbawpgSiHHu2r7gMIYm0JwnAl7Px8GIgWM8PJwg2HUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392970; c=relaxed/simple;
	bh=jMZSl2knEChKRf+rXJe7NFY9+Y08moeFGO0+VFZni4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgNXwF6AdmqwCkfTmehN3j+guhGCxswg4h45W5144dhXyZdpei8lu5Jl2hCefzOCKS1uJhCn3ytJ8KoWb9+zCmqaPBFFNoxQOzhVEfGHrxqJZQ2ScAt758RaZ+yXxqoUbMMNX5YPhbPMzzdmY6asNmuX5QwTt8wwTNY4iaSUqpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIHvKkZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIHvKkZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3BD1F000E9;
	Thu, 25 Jun 2026 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392968;
	bh=JIRMpL52vlZ6GhFXZs+0aBvXz2AmdmlWZo4MJSUtZ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIHvKkZp53QFprU2nSDkCpQz+qLTgHI3nqcvjaP+XY+x3SjVx1p3r/mEoDbBcTL4U
	 GwO2GsT+z4hjraavAEzdMiVyZONticelaHdhe4FdrZensJMxwM6O3+WfzdZKTJHiF5
	 7RE48oUty90+mO5Qass6KxBicAfa8cEkfsxCFaOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 17/49] rose: hold loopback neighbour reference across timer callback
Date: Thu, 25 Jun 2026 14:03:29 +0100
Message-ID: <20260625125639.904985505@linuxfoundation.org>
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

commit d270a7a5793af84555c40dd1eb80f1d497fdf53c upstream.

rose_loopback_timer() dereferences rose_loopback_neigh throughout its
body but holds no reference on it.  A concurrent rose_loopback_clear()
followed by rose_add_loopback_neigh() could free and reallocate the
neighbour while the timer body is running, causing a use-after-free.

Take a reference with rose_neigh_hold() at the start of the callback
(bailing out if the pointer is already NULL) and release it with
rose_neigh_put() at the single exit point.  The neigh cannot be freed
while the callback holds a reference.

Fixes: d860d1faa6b2 ("net: rose: convert 'use' field to refcount_t")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -66,10 +66,15 @@ static void rose_loopback_timer(struct t
 	unsigned int lci_i, lci_o;
 	int count;
 
+	if (rose_loopback_neigh)
+		rose_neigh_hold(rose_loopback_neigh);
+	else
+		return;
+
 	for (count = 0; count < ROSE_LOOPBACK_LIMIT; count++) {
 		skb = skb_dequeue(&loopback_queue);
 		if (!skb)
-			return;
+			goto out;
 		if (skb->len < ROSE_MIN_LEN) {
 			kfree_skb(skb);
 			continue;
@@ -109,6 +114,10 @@ static void rose_loopback_timer(struct t
 			kfree_skb(skb);
 		}
 	}
+
+out:
+	rose_neigh_put(rose_loopback_neigh);
+
 	if (!skb_queue_empty(&loopback_queue))
 		mod_timer(&loopback_timer, jiffies + 1);
 }


