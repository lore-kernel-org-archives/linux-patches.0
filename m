Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047237;
	b=zZP3u1xq+lq1KLkqLGA3wLaVB0JF5NHj90wd1aX4hmM4YH7rz/wY2G125jutFyp9XQ3W
	 5SIycHznBjg8IIdSir1sF7AptpQq4U2h75RFSLxBaEsKcXm9ND2nB2F19i/aiAwoSKM4A
	 Csm4l5JDnEYBZrgYlgmiIyEct2Z5Vut+xJxBHO+XkXdv6/KEDbi1IxOiHiCRrENvKdWlY
	 3h8Bvpb5zijal6JswxKhyMnmBO6tqP0sybGixWZ/JdLFpqsYPl+7S6RJVz4LLuO0NnFYx
	 msGeMwYM8j7ixCUt0cbB0lp6gd2cSrvcHWLJcJqJaSlSiEIxMWyulRSpRzJL1jwrmWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWml0S2aP//IINTwBsRfFljce0c1vHcZbLEH7hJCFH8=;
	b=vpcoS405UXg3/yokOxF67G4uJttO0T1JnOKWm00H9ecOQ2K3kywiZmVi1AHxmNxAQauT
	 bCccMVMT+fHyO2Yg4ni7nEuPS3adVBm5UUMVOJf2aIzhPypT2Rb2GFFpJSB568RoRe6dd
	 EToZUM2ltn85lFtWY8XqlAEcrN5GHkIDT5vSNt9EyzsAAOFT50b4gL3VXweWfF06kgqGj
	 Jl5Z45sncZkf4gm2e2cwVIaweWWzF6QU3N+84AmG7WRvo8SsmCwUD7kNT7kTmPbkWDtvY
	 Db0nIz8Mgu5CjDNmXO0t9Tebh8jDXKPZMSI3PFbbYX2TZl52SC9L0UGZHQkf7BseCgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFEa7Uag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36147606A31C;
	Thu, 19 Nov 2026 00:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFEa7Uag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309A11F000C4;
	Thu, 19 Nov 2026 00:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047236;
	bh=OWml0S2aP//IINTwBsRfFljce0c1vHcZbLEH7hJCFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFEa7UagHW1XaHN3L/Ig52yIgOAdrcrJSQ+cTxUyHI6aPlobHogNRjU2Lo3ZI+DEN
	 VwBxD/Ra/SC+ickJB852yPjBpiPRKaEXgRSc70s475UeCuwCAX+yf9FD6v4HB1gXEa
	 E4BlGD6Fr5iew6tvIvcjvor6AZNJVI3CZwCNOolI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Yu Zhang <yuz08559@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1568/2857] nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118150257.846358027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c12de188e992..cbc3693d5fc0a 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1332,8 +1332,10 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
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



