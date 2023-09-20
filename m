Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB92E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A46C433C9;
	Wed, 20 Sep 2023 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211809;
	bh=qFv613Qiwy9+VVmHC1l8WL+djE5bSoO9LA0huFAHIA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2O4+dh5/7R3Jn5oEYrs5ru1YQm1oBd77QPWKRPhwbr7MtXJr0Iz7BVb3kkminnRs
	 vBSXjwPXkUacN52Zj5G9ymNNI6faU5WJ3mRMqJ1inh/poqTL/YZQsPvWR4p3eaBEYb
	 icMD7W7DHKdu4UiNXds5ljWsOkQoC2SD8JndQXtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Yang <wenyang.linux@foxmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dylan Yudaken <dylany@fb.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/273] eventfd: prevent underflow for eventfd semaphores
Date: Wed, 20 Sep 2023 13:28:04 +0200
Message-ID: <20230920112847.780028922@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Yang <wenyang.linux@foxmail.com>

[ Upstream commit 758b492047816a3158d027e9fca660bc5bcf20bf ]

For eventfd with flag EFD_SEMAPHORE, when its ctx->count is 0, calling
eventfd_ctx_do_read will cause ctx->count to overflow to ULLONG_MAX.

An underflow can happen with EFD_SEMAPHORE eventfds in at least the
following three subsystems:

(1) virt/kvm/eventfd.c
(2) drivers/vfio/virqfd.c
(3) drivers/virt/acrn/irqfd.c

where (2) and (3) are just modeled after (1). An eventfd must be
specified for use with the KVM_IRQFD ioctl(). This can also be an
EFD_SEMAPHORE eventfd. When the eventfd count is zero or has been
decremented to zero an underflow can be triggered when the irqfd is shut
down by raising the KVM_IRQFD_FLAG_DEASSIGN flag in the KVM_IRQFD
ioctl():

        // ctx->count == 0
        kvm_vm_ioctl()
        -> kvm_irqfd()
           -> kvm_irqfd_deassign()
              -> irqfd_deactivate()
                 -> irqfd_shutdown()
                    -> eventfd_ctx_remove_wait_queue(&cnt)
                       -> eventfd_ctx_do_read(&cnt)

Userspace polling on the eventfd wouldn't notice the underflow because 1
is always returned as the value from eventfd_read() while ctx->count
would've underflowed. It's not a huge deal because this should only be
happening when the irqfd is shutdown but we should still fix it and
avoid the spurious wakeup.

Fixes: cb289d6244a3 ("eventfd - allow atomic read and waitqueue remove")
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <tencent_7588DFD1F365950A757310D764517A14B306@qq.com>
[brauner: rewrite commit message and add explanation how this underflow can happen]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index a96de1f0377bc..66864100b823c 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -178,7 +178,7 @@ void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
 {
 	lockdep_assert_held(&ctx->wqh.lock);
 
-	*cnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+	*cnt = ((ctx->flags & EFD_SEMAPHORE) && ctx->count) ? 1 : ctx->count;
 	ctx->count -= *cnt;
 }
 EXPORT_SYMBOL_GPL(eventfd_ctx_do_read);
-- 
2.40.1



