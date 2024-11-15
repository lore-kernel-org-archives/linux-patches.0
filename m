Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D5C2BB1B;
	Fri, 15 Nov 2024 06:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653661; cv=none; b=hqJxFAuDDAMHjh9Ne/k/9HtG1S2g+rEY1iJaMfvCBtu5Sl6e04vH9/Br00AaHIhzXNEV6gMrYyz5dOobjhXD4l5DKCRzr0Ll6ebvc6QXbu7lVwSZRjcAg4PsY8yLLQ0qpEcMqTBwKyQKbUjScNCRwjo2rrVY+9z2aF/a0143+EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653661; c=relaxed/simple;
	bh=OOLxeObIzpNSzzFSy587DmuGZ1yFgjzxOHT5lut/0og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+r5j6VUXUjbVAPZ606N5SF5T/A9rePlqNwu3ob1vm9zs/J3utvoZgdC8eMPjFOGR6f9yTLtSslBaPWXUIqBpe5HNftK9D+Ot3XR0lcKQ2M8O8i1GsCyKbzVpMVxRJ+4AT7tYCmYnkDl6+M3OqkmTgXGxZxI24gVn4fhbO8EOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8oYzv+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8oYzv+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4C0C4CECF;
	Fri, 15 Nov 2024 06:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653661;
	bh=OOLxeObIzpNSzzFSy587DmuGZ1yFgjzxOHT5lut/0og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8oYzv+qa3PfEqd2gR0/rI5uFWpK8mfReODJyP+d6g9gPq5SmVvh2e8qCyofU8FJv
	 nm9tKke2Ex6FUJquz5v/4vP8y9t8qj082rBL16EGkm/yFLZqHv30XFr/DBm/YILW/4
	 Yehp82vgJf7XkmpWKai0mOopcN7DqUx5yeUya9eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 30/39] io_uring: fix possible deadlock in io_register_iowq_max_workers()
Date: Fri, 15 Nov 2024 07:38:40 +0100
Message-ID: <20241115063723.695032276@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

commit 73254a297c2dd094abec7c9efee32455ae875bdf upstream.

The io_register_iowq_max_workers() function calls io_put_sq_data(),
which acquires the sqd->lock without releasing the uring_lock.
Similar to the commit 009ad9f0c6ee ("io_uring: drop ctx->uring_lock
before acquiring sqd->lock"), this can lead to a potential deadlock
situation.

To resolve this issue, the uring_lock is released before calling
io_put_sq_data(), and then it is re-acquired after the function call.

This change ensures that the locks are acquired in the correct
order, preventing the possibility of a deadlock.

Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240604130527.3597-1-hagarhem@amazon.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3921,8 +3921,10 @@ static __cold int io_register_iowq_max_w
 	}
 
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
@@ -3947,8 +3949,11 @@ static __cold int io_register_iowq_max_w
 	return 0;
 err:
 	if (sqd) {
+		mutex_unlock(&ctx->uring_lock);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
+		mutex_lock(&ctx->uring_lock);
+
 	}
 	return ret;
 }


