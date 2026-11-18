Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042546;
	b=WksCPwm0QT0ur3L+4MwQJLQ429PFzB9MwA4RhgflKOpeI85/1SgU+oN0PHa4K5lq7z0z
	 DT7deYEayrAETckLxrG5x59DIIjZxC07zzQFh6D2CI+dKQVh6kbh5OtE+QIBsu2572XNx
	 Lt0J8cGPoY/yisInEAdrXreJmhXgnHzW3Z5mmUTrS0k8AEfTm7alvV8Rfj3mE7wq1xA67
	 cTkJvtEs4xhRW55Gh+FIxzBdUpWB4BtDAQtewVogyu5/xX6qSUi4Dymh/v2AsXjp9rfzW
	 CHtZ1p+kwkX7xZw2VZXGpPaa9X2UAGBodpKgUgIDapGPVcfCukhUWyqjPeipprHEkRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ISZJLAsjFv9U/NC82l2S25vncXSAnci8ps3ntd3UGQ=;
	b=p+mabDxhhRhLEmU2XVrPUmrj6byT3xyXSfh+uWX4KmSoDXFHF5PZ2CWNURuqy781vgdx
	 +TeY16T/9qnJua29YpVsyvCbRZEkd5KhMQ/U2qGBsb50JXO9tbfcZylisrJa+J6vk2BGR
	 Ii3yJ8K8bNZMWgO7RJSP/MAB30n/I9tpF+ODuBPtsooNE8geJWGXUJOyz6gbgLOIq6/dT
	 hicLgQsYHRJEGP6VFTU4/Um1zAidUWO5RdGnffQAHdoWLAaRDbLQiXXAMwICWTU5kfNXZ
	 IsaY6rHy0SVVKevenqxWNDdnOfzWWLynMcDagTfxUPoxFcsTN0uLppEI9f/t0VoaVEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z916f6Ld;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C0F606A325;
	Wed, 18 Nov 2026 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z916f6Ld
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F51F000C4;
	Wed, 18 Nov 2026 22:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042546;
	bh=6ISZJLAsjFv9U/NC82l2S25vncXSAnci8ps3ntd3UGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z916f6LddoyDB4oL1MYfWpPlMGJpH+GC4QvkrIJYp4RfQHSq77OCxW7O9qyVZS2iL
	 2dJX6jcZrbTOgY/ZB247PtEuzUyArXi86WXS15G6H4uNjuLArZHXnEW8Dlc9RUpSud
	 L/ZrNBPoXgePAhbvShcN568ECQBMmCFE+suFnivE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3210/3318] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150456.044976288@linuxfoundation.org>
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

From: Qing Zhang <diasyzhang@tencent.com>

[ Upstream commit cead6beb89256ae7145b65fbe8e8a5fedba4a47c ]

Readers of nvmet_ports_list (e.g. nvmet_subsys_disc_changed()) hold
nvmet_config_sem and assert it via lockdep.  The writers --
nvmet_ports_make() and nvmet_port_release() -- do not take the lock;
they rely on the parent directory's VFS inode lock for serialization,
which is an implementation detail of configfs and not a guaranteed
contract.  Align the writers with the lock the readers already require.

Also move list_add() in nvmet_ports_make() to after the port is fully
initialized: the old position published the port on the global list
before INIT_LIST_HEAD(&port->subsystems), so a concurrent reader
could traverse uninitialized list heads.

flush_workqueue() in nvmet_port_release() stays outside the semaphore
to avoid a lock dependency on nvmet_wq.

Fixes: b662a078576e ("nvmet: enable Discovery Controller AENs")
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 7ef0464845ab5..ff034f346bd6c 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1757,7 +1757,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	kfree(port->ana_state);
 	kfree(port);
@@ -1814,8 +1816,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -1846,6 +1846,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 	configfs_add_default_group(&port->ana_default_group.group,
 			&port->ana_groups_group);
 
+	down_write(&nvmet_config_sem);
+	list_add(&port->global_entry, &nvmet_ports_list);
+	up_write(&nvmet_config_sem);
+
 	return &port->group;
 }
 
-- 
2.53.0



