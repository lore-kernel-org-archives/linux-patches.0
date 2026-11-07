Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063578;
	b=A6HD3kzC9/EluL+jl5/jw/HKqDCTzvnZgZsovgET5eh3RlWWd2UdZ+GXBhH+win/ii32
	 k6wlhEgZiSJQRKoC8G6ONYbQ8wzJBTasDynKOxWkff4ReRnEYDLt97oyh+TzmGvlJaxMD
	 d4tej+hXOE4SRCewGgWsxZzZ0Sxpyg6E7fv46tL3UpA4hHjE2X0ZvC0RxeGvb3yqe28dQ
	 Lohsg5rYVlOH7q0KR0w/79mzCaSMMIQvtYs/iaJ0pxeHUGSXOBwYp85iSYGGo3U5vR1Uq
	 eM+IEVW2nENH/W+TBKRzk5W8T/Wi1Quk/TuH0Uh2gDEPA24lk0zu9Bij8rqUZL+8PfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VhfUWgjd3XYU/6nkhbUBA/VQN2Q007WEJuHmjwCiamg=;
	b=KugbmrRj2tkU6DO5VJ34pcZRinXhAW6lk5BCzJcHjmSFptYBZLhk3EnxoEWFyW1YvNax
	 ivWiDejoq8E5PeA6Xsa/AbqLLAabTVwuY+2zl+dSS25/6PoYsfRRxOj4Xr44siIECGjeg
	 h4WBT9K6BxEReUsUsaJGPgUMKCoejhqKBpZXPEXq+CsiaqdZX+mzZ6Tp3sdLXvZoi6Hqa
	 W+x5aGVxfw9IVbmijMoiBjxtRtB1EKZVXk6XV813m76cRisJGVQpQOCQF0O9F3pCyalX1
	 QawEzBXXSTfkScSdMZnTkyW4cw/03DYLnbvy5IiXk/V1utFyeyrF0gmEUkRL175YvfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtlOBmMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5C060A262E;
	Sat,  7 Nov 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KtlOBmMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC2D1F008A2;
	Sat,  7 Nov 2026 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063577;
	bh=VhfUWgjd3XYU/6nkhbUBA/VQN2Q007WEJuHmjwCiamg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtlOBmMvelnqg8SSyKoxII3RbrsPLSBg1nEHVWe9AsNNu2l5ZF9IShJ1lDHgrZ7GD
	 L9L9g+Jtl4jGdWHYTsTY12EqXNjibhtYb/Jw7qQY/ZtNoa1LNIXiEjbr0d3q5z/jbu
	 mDnw8FfqNMskHBeRcoD9HyIxgjFZuFYZ3QtIm8/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Yu Zhang <yuz08559@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 707/869] nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()
Date: Sat,  7 Nov 2026 08:56:29 -0500
Message-ID: <20261107134916.878286669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit 9f426f14051181e251590783e68ce589a63e2b1c ]

nvmet_subsys_attr_qid_max_store() sets subsys->max_qid and then walks
subsys->ctrls to force every controller to reconnect, but it holds only
nvmet_config_sem (for write).  subsys->ctrls is protected by subsys->lock:
nvmet_alloc_ctrl() adds an entry under subsys->lock, and nvmet_ctrl_free()
removes it under subsys->lock with list_del() + kfree() (not kfree_rcu).
The free path takes no nvmet_config_sem, so the two locks are independent.

A controller teardown (host disconnect, keep-alive timeout or fatal error
-> nvmet_sq_destroy() -> nvmet_ctrl_put() -> nvmet_ctrl_free()) can
therefore list_del() an entry while qid_max_store() is iterating the list,
corrupting the walk.

KASAN, concurrent "echo 128 > .../subsystems/<nqn>/attr_qid_max" racing
nvme-loop controllers connecting and disconnecting, panics in seconds:

  BUG: KASAN: null-ptr-deref in nvmet_subsys_attr_qid_max_store+0x10d/0x1b0
  Read of size 8 at addr 0000000000000090
  Call Trace:
   nvmet_subsys_attr_qid_max_store+0x10d/0x1b0
   configfs_write_iter+0x1a7/0x250
   vfs_write+0x5df/0x940
   ksys_write+0xfd/0x1e0

(also seen as a general-protection fault dereferencing a LIST_POISON
pointer at the same instruction.)

Take subsys->lock around the list_for_each_entry() loop, matching every
other subsys->ctrls accessor.  ->delete_ctrl() only queues asynchronous
controller teardown, so it does not re-enter subsys->lock under the loop.

Fixes: 3e980f5995e0 ("nvmet: expose max queues to configfs")
Cc: stable@vger.kernel.org
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Tested-by: Yu Zhang <yuz08559@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index f6ac42eaac0e0..e2032b58191c5 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1662,8 +1662,10 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
 	subsys->max_qid = qid_max;
 
 	/* Force reconnect */
+	mutex_lock(&subsys->lock);
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		ctrl->ops->delete_ctrl(ctrl);
+	mutex_unlock(&subsys->lock);
 	up_write(&nvmet_config_sem);
 
 	return cnt;
-- 
2.53.0



