Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFB52F281;
	Wed, 30 Sep 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790552; cv=none; b=TnSZbczRMWqXhnwqKT2qak63wYDbI1cCLYMHaCF6LZTooRmEaHaBmGRnRPZ9q1x851SeuAr9Ah698TQKKf/AW9J2Vm//jzSpKl4zYrVvFp4iOsKHj7nXRzJm1uH80CypqvlfXm7ssYMtfvOjKiVQkW9r9tN9uVLt8aEKIez5z74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790552; c=relaxed/simple;
	bh=eQJq4LHWbJeQjjFoVU5EEGpZNEZ7ya2lAKpLRJ8jyAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQEdcX1flIWJQMH78jfdhNIAdnGPrLaSJysFaUR6pB0It1dfEe0gKxpSyZfBn8oi6JQzwHqFnmuYRwn15+IYXQJDtPwRR6+LoMA00kH1LGWufUon14WzAx7rbYx8caLaRAuDrXg8ISGwILcaqt7VQWX0ZcszLkQgkvtHhitwOH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/ZpaFWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/ZpaFWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF07D1F000FF;
	Wed, 30 Sep 2026 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790551;
	bh=m+PANuX7rRJJ/xT86HqA9ouEXc2lxJFetDFfmOlySLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/ZpaFWUjnji6UH8gZM3M8Smfe96Ie1bEyNQ4EjBTVpbBdV2wHD7qtz23+Dc19RDu
	 QcsDAR7xTu2gCuSLjqJUv+ZxFt43fDFne3KiBEDcNFZdzva/Qna/tscyFgrqHI3cgn
	 AwuQLwIyIcjO11vLulwZs+Xv0ifafen+FyOc3BfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 867/877] rose: clear neighbour pointer in rose_kill_by_device()
Date: Wed, 30 Sep 2026 17:29:38 +0200
Message-ID: <20260930152433.443440706@linuxfoundation.org>
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

commit 606e42d195b467480d4d405f8814c48d1651a76a upstream.

rose_kill_by_device() drops the neighbour reference but leaves
rose->neighbour pointing at it, unlike every other rose_neigh_put() site
(see "rose: clear neighbour pointer after rose_neigh_put() in state
machines"). The heartbeat STATE_0 reaping path then puts the same
neighbour a second time, causing a rose_neigh refcount underflow and a
use-after-free.

Set rose->neighbour = NULL after the put, restoring the invariant.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -216,8 +216,16 @@ start:
 			 * looping forever in ROSE_STATE_0 with no owner.
 			 */
 			sock_set_flag(sk, SOCK_DESTROY);
-			if (rose->neighbour)
+			if (rose->neighbour) {
 				rose_neigh_put(rose->neighbour);
+				/* Clear the pointer after dropping the reference, as
+				 * every other rose_neigh_put() site does.  Otherwise
+				 * rose_heartbeat_expiry() (STATE_0 reaping) sees a stale
+				 * rose->neighbour and puts it a second time -> rose_neigh
+				 * refcount underflow / use-after-free.
+				 */
+				rose->neighbour = NULL;
+			}
 			netdev_put(rose->device, &rose->dev_tracker);
 			rose->device = NULL;
 		}


