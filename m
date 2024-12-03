Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C23D204F84;
	Tue,  3 Dec 2024 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240246; cv=none; b=e7v5/Z3rS6KCR3oOASn1Y5k7iSMzs937v6zmC8FNgb3XHsRL7EwbJs0qk5Iv52kWvqdBaRvWJEKTAIvTuj/ZaWHG9fgzoFtgPhJbwQOSlqbzfOFmU41syLLcfO8L81sYpEyUw5CV+PWDmP8WAhwMni81poCM1H4hrSQfn8/YdTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240246; c=relaxed/simple;
	bh=aOue+mhFXTb0ZsrGbKxmnrDIlIQjRhZN5B+qbvGfQk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPhI6V5jPCZ/BFbyuSMUAewmSNgrf5j2xM6KyDCk/vY32IGt7mGXUATI1JjPnTF2EzwvwbGLjSOSlYFiLeUCSO8TavDt8k7z8fq7aNYGIRVu9zUdvIwkXDITFtbWJgQsMvP1oTUoSqcNMKOGL2eKOqHhijLFvxjJic//SHP3zAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GL81Q+bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GL81Q+bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC56C4CECF;
	Tue,  3 Dec 2024 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240246;
	bh=aOue+mhFXTb0ZsrGbKxmnrDIlIQjRhZN5B+qbvGfQk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GL81Q+bcEzAhOC3aEB6VQZVUSM15S0Ac6Yiw6HSY8rMKMeKeP/eSKmkhaHluBjyCZ
	 a3hy4RYA36NiWpdxk5X82Ksb6EhEPmItdqTG4jr+UDdB5jQ2oEeA9bKaZzZoDDb4QR
	 EKxoqvou0mnSu5ZTGD8nW7pA+1UHZWM5EYSGcNIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/826] netfs/fscache: Add a memory barrier for FSCACHE_VOLUME_CREATING
Date: Tue,  3 Dec 2024 15:35:59 +0100
Message-ID: <20241203144744.711400036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 22f9400a6f3560629478e0a64247b8fcc811a24d ]

In fscache_create_volume(), there is a missing memory barrier between the
bit-clearing operation and the wake-up operation. This may cause a
situation where, after a wake-up, the bit-clearing operation hasn't been
detected yet, leading to an indefinite wait. The triggering process is as
follows:

  [cookie1]                [cookie2]                  [volume_work]
fscache_perform_lookup
  fscache_create_volume
                        fscache_perform_lookup
                          fscache_create_volume
			                        fscache_create_volume_work
                                                  cachefiles_acquire_volume
                                                  clear_and_wake_up_bit
    test_and_set_bit
                            test_and_set_bit
                              goto maybe_wait
      goto no_wait

In the above process, cookie1 and cookie2 has the same volume. When cookie1
enters the -no_wait- process, it will clear the bit and wake up the waiting
process. If a barrier is missing, it may cause cookie2 to remain in the
-wait- process indefinitely.

In commit 3288666c7256 ("fscache: Use clear_and_wake_up_bit() in
fscache_create_volume_work()"), barriers were added to similar operations
in fscache_create_volume_work(), but fscache_create_volume() was missed.

By combining the clear and wake operations into clear_and_wake_up_bit() to
fix this issue.

Fixes: bfa22da3ed65 ("fscache: Provide and use cache methods to lookup/create/free a volume")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://lore.kernel.org/r/20241107110649.3980193-6-wozizhi@huawei.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/fscache_volume.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/netfs/fscache_volume.c b/fs/netfs/fscache_volume.c
index cb75c07b5281a..ced14ac78cc1c 100644
--- a/fs/netfs/fscache_volume.c
+++ b/fs/netfs/fscache_volume.c
@@ -322,8 +322,7 @@ void fscache_create_volume(struct fscache_volume *volume, bool wait)
 	}
 	return;
 no_wait:
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 }
 
 /*
-- 
2.43.0



