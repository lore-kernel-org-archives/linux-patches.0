Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065216;
	b=naphqVynlRPMNmZ5KTh3uKIAu3blMCYTWNOnVNnoCaXnT3/ZyKTfzHMbDrFnaBKyy5J2
	 2aPpRtOEDPOFTVp/2J01/Q3z3beV6k83J+vPP6v3nFz4glhnmOfGGwMWmJH8QjW+5vaGc
	 ZwaGkIURn67AO0b5uKh8nbtU/XgjxtKnHBdfFdqsIZS+Xx9xHbt/zofQ5JHr+xqQEwJsc
	 o7QYCBH+SKiTNQyZrKAUmWTrV9CwITbVhn09SS1qpodAaRyt3WHceaeiyhPenME3kWNYn
	 Q7i29Afpv1kxLkOgNSrWYNz7Bgh+32bm4jofjL3zSZnOV/6a5Ju7rHGfSsKqPy55YxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBepUiAOrwhRfhFIxvlkmM59TTUh+LVMYlTIBRylMLo=;
	b=cW9QNv33tMaClR/VbwfdYiXCmGH29jQMZGvCQy8/6PC+wsiOSH6rwFGpM7NCXfQelyAp
	 YyWiPaGmNy200vqrKEIBUdSGt2WZ293384oXJTW+BBz2memN5lKtW1Ytv077UrTqYIt+O
	 uvR2bkQMExUaGgeV+dmOz7/sa0gy997uqwqiK7DxFvW7imjGpQm6P4IcjWK9tHqdDtEWG
	 5KprMoJZ5Pb4UCeSlPFl9OWCIFOBzIRG48pIplSN/LX7Y/Oz9x0eysdGlnby+6iAYcYfm
	 0+yolJILMTbN/nLCQVW56xhMH3IqXpUp4Hsu0j2mnWIzwclqNymzjqdj6H3VnfdBFnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2RiUjZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B15606A32E;
	Sat,  7 Nov 2026 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2RiUjZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D11F0089F;
	Sat,  7 Nov 2026 15:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065216;
	bh=hBepUiAOrwhRfhFIxvlkmM59TTUh+LVMYlTIBRylMLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2RiUjZUJJpATxfZ8ftVLxvXpGzifYaSRSzDG88v1BhRdCZYvQoupMNfNpcFmr+8C
	 wHk/ZblNFMgg0q+hzeLI8CCueKhC1tHg0Em9avIkZCgrI+3V9PcQcG6rvmWk31RY54
	 NHs5MOyjYCCOV89u/CsU8eWZKN0Xd3M2Seb4rfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Yu Zhang <yuz08559@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1010/1257] nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()
Date: Sat,  7 Nov 2026 08:55:06 -0500
Message-ID: <20261107135007.235696142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b03b5d1c2dc3d..83b86180c50f8 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1689,8 +1689,10 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
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



