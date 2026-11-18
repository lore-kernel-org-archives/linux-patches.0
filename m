Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056899;
	b=QaZ03nKaPZJa817LHj8ipyuv9ZVZ/P4fqFBsblVad7ytwvQJc9/twKR1BSpzIeVfQpAQ
	 qYEmc+EVUqQmn138DFxJ4eOIHcuLCEMq+4SUJvFOCo5KBn32m1W8iCb28HfSFcJlFkYNQ
	 xzJ+Hg4y0a+Nz6KWQEj7cinyZGfg2VnwmOtsl4FlKC/yOy6M51tGSPUyZTdRUSUrjDZTc
	 oTmeRm10fj7rhUzIKu5M10fZtkRz3132R8Mct6GaCk9ZaqM+e013nlfffAEkhgalZX7Rb
	 BdxPKOmnCO2Qj3nmpkEeD9O7YSuvR0mexaMT2KPUJpwIeYh4Cuxwsu78NkfJReGMYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ktx7Mh81nomg1SNHlmXct06O8r6tttAVqlbcB7IFxGs=;
	b=j5e8LE5Nno3rtbAMlN501LnS5GlrvEm6c8uJr2De9Qa68EGB4g3zLDoCaZ846R2JsaEl
	 bAj787yWL/1hFWPuEGMHkf3pExiotjGBe5bHRbnDfe3LoOjELVp8N9ta8hiOhAU+gdjDn
	 OhDivGwjze7xCxC10saCTlBkR6RNa8wV90baLzSCbVgGpFuuN6CkfM0Pg4QQ3tpwxdCUT
	 eea2dUt+jm+IpOnGUtTK4rtVDmcCToHORBZPQCQn8ukQMuKkEIRv7PTOLMY5inPwpQPV+
	 CLh7VMBtYEfEoqAKyoUZqWSj6tq4+gZtvhSe6LBDAolJe7Ya436g4UaLsxhSTStCLJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3EWqU3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF7606A320;
	Thu, 19 Nov 2026 02:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3EWqU3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270E31F000C4;
	Thu, 19 Nov 2026 02:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056899;
	bh=ktx7Mh81nomg1SNHlmXct06O8r6tttAVqlbcB7IFxGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3EWqU3NzeBv8xhqjbUfXSrzAxdvDDyNWsRVl5/0hyQlPUwgLJlCbz3567+M8tPVG
	 ShmI9HxuK095DIX4/pwuvrOu+hSxMIF0+UDOJ7DANUDWdNR+OCuhNjqptt/o+1MRtC
	 ow5Zu3Duisr9Nz9JT4Ul5T0SjNq//+hBOdN1ASgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2151/2214] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:03:47 +0100
Message-ID: <20261118150136.524739348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a7b9410161e9..1549137be767f 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1570,7 +1570,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	kfree(port->ana_state);
 	kfree(port);
@@ -1627,8 +1629,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -1659,6 +1659,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
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



