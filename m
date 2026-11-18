Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036822;
	b=HkBgxMr66Dk6y0cBptIudg1KIz557M6x2qjy6JZB/J7ue+cs+S4kSrg+rSxYqImrsWVH
	 GbF61Rp5PC6m8jVwUr8PKCHMkyMTJbAl2LgTcOXsD1zDAo74/Z7LG+Yis1NUjYHLk4Idt
	 vn4sXx/c6NEjfn171Wys+UiFvy7YRavJVmiSSw98EvioYJrBbcfqu/0IWA8TUIOjqtGtN
	 7u426fHo+K6Nkoqd3LVobw8MhQIO/AcCFhhvbufxA0OeMiu48OCkACotnvJp79ny9Q79O
	 E9yDBw8UI09swzyLAEZziUufTQuYaNZVlQAzQSlzl4B2TLxuqfOo+YESeaZYfolYPdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ratanE5x9z1c4LqjhcBK/t45tnuScgHPy6JFGkVZv/I=;
	b=M1kGa6WAtvV4IYc2xU+gPhnU93mvUlYsEG+VXEvBGCGs4MBVP4gSrv0y58yTv5w5ReY8
	 uW2OmcSTx7QtThZ3xDDtotGz0YnhQccYGfLl8/msjZE+JLHszdiomVg/dBhV/UsuJDiDt
	 CZ5ns/Ibl4CwItGLsQMnnJywJ1DCXwzsYKSvPU2Dd4eugcoroltSakVRY3tflIbnwHg2q
	 zR8C6K8DbLJaTJEAAoGg47+Kj3wBgD9q/UQOoE6hQPDfyJgtw7r5W3BcvuGdsfOWymUDR
	 970bn9QtsP+9p2ponUn3znrblcOReBc2xu4jNiAQK8ifIE4eDz1KGdtHqt4Besd6jpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/+vBz2o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A19606A31C;
	Wed, 18 Nov 2026 21:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/+vBz2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE471F000C4;
	Wed, 18 Nov 2026 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036822;
	bh=ratanE5x9z1c4LqjhcBK/t45tnuScgHPy6JFGkVZv/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/+vBz2ocUs+VNsPG8sHVrpU6vdIMs5OpvKZses+j3fuhJmPqNp1C3l6rEVoV1wIH
	 3fIZy/F0g5XAs/kj5Ilvr3M1vevKCeG548SilimslpuhNVimFf9hPvtcpj7wMJ+9FA
	 rTSiful3a8JnDKi57uRpwOMxNjxRrRkX9upHDzVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Yu Zhang <yuz08559@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1194/3318] nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()
Date: Wed, 18 Nov 2026 15:30:16 +0100
Message-ID: <20261118150355.990341142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b266ed13ab326..0310858e97173 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1443,8 +1443,10 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
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



