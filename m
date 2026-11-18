Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022064;
	b=fdZnRRz7ptcaE6rrZIj1JxluIS0+LBR9ikEfqb4SqDMTS0FKNfGp/AAwKE9CFOHunoVg
	 4P4zrw3VPGCDBKQyMnj6QZQXKU062lY0h/VL7SoQMrb+IC+1Ov7umshlxQltH1G+ulFfe
	 w962xtxekQ7I70jNtFlev5gWo7UuqW8JvoDY6IX28zsSPZiW3CA41CXkNpPZO+vahZP8r
	 RwK1CeGS4+umV1i/SB+slCeFWWIEC/VZlYlakm8sc8zIMWdj1oinlmp28dny8ahXQFCG0
	 OlzZMhiLzas0yKEVUjHGWygb2jYn7ziId8Ndkz94UorgXguwFybsv1tD9R5+tVvu1pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4/hpjzlh/6XLHmYbw1101bPoVmLh5H7oiL3ieObrdk=;
	b=BI32NTQaBTQcW0nJUlefH1x5etOfCmPnd4TPHw6Ofrw3FUAt6JaZzJO0VLm4x1TBs8QT
	 TGaaSzTyUmGv8O3NSV5TI2EkdWPwpN/30XSHCXGJWWQzoDoJ7pDj/W5CHBvFGWHMP99/W
	 2leCze8Iwknk3zKkMFt7IAAjE0dIV9/70d7qMhDa0j/LViOZc1iOrK7oObwGHPkGfHs45
	 aCidJzdT5RoRMRHKLdIybJ3BzU7X+A8E7B9fCCNVWksZRkItMIANr85sGE48z1FSLDkvj
	 a/lmb+knwdjiQOI4pcxN2AAuGneclKRB0ncNw+R0aY/nL22BgcB0YBWIv6DxKNPc4vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRBz40nW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1095606A31C;
	Wed, 18 Nov 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRBz40nW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD091F000C4;
	Wed, 18 Nov 2026 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022064;
	bh=L4/hpjzlh/6XLHmYbw1101bPoVmLh5H7oiL3ieObrdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRBz40nWj1nOZ/XO5VGBgkQD/zIoZZFHHfmpp3KO+TqXoPRldyTzxOkniUJps4yI3
	 bP7mxnlAUDgs+JChPQq9Qtry2hgpEhJSfwtl5AyGvOoJHLz3v4JRLIfTxPEiqqozMy
	 VKWQ6PXcfX78v+xvXVWSUXu/m1+Gp2IYzB8ci8Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2528/2651] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:02:48 +0100
Message-ID: <20261118150415.647424757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 61107bcfc895e..0c9d02299bcf4 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -2011,7 +2011,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	key_put(port->keyring);
 	kfree(port);
@@ -2072,8 +2074,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -2107,6 +2107,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
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



