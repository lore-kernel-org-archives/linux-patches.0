Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050599;
	b=IRRlX3wTwrZISmklc8EgsEwAGkZI2yQ0xOgXHnKcGnQ2GN0TM0y80vHVTM1hUtcPcxF8
	 aUiQWZSpk4Iz5v5LMx5OjQEw+W+vlOxHq1A39QdZJPeG4NXZcOMk0H4Iy4UPTQOQHH8M7
	 /pzD6f1y51w79HaX6QE0V8xbLILGRkwuTSmYtdwVDeGx+h5l0qaWd68X8pZsPI0P7CUBq
	 vtpqJL0qWQHr0RpfltInKRuZSD/+k3kP78kLObQRCjGjbAgeXmlLmMEh7ohuJgC1hHAvK
	 LXKsAnCF47Zv5fGwJjRqgRkEDjSaLluewOc/hd/PQk9G0gSvRTP9ghXMKAkxw2CyioA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwcVbtHlhooZvo05IoyIJxARPTGicb3ZgR9hXN/oc+o=;
	b=Jn/tt/YqTy4vtxLdzluN4XLMZEZ8VbxU1WeAhuQ9ApXcMy7WJVkkDvQcl0YxcxBcOsOU
	 uoYI3U6dJwyZarQR27D0kZgoMANCt8HwzFyaJMJjQ+a/1b2yE41/xrpgPKwpKGvgveize
	 leC22op5kNhWJ2AE0EHFtJmetC1HgJOs5M63fYnyLHNIUfBV+REslrdoKAxet+mpquGkh
	 gpKC0/mL8NVEP7BrtJ008Rr7CgPb1PAfGkPRgnnmKTi8k6FsvA/gkDZuayJUGmRj//0cw
	 E8Gqn/QxUZq/QFU/3fZUrAq2lNqTk6QSF8y4Js8BSu/joL68Mcdc50QwZ3ImdoDvYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg7ZsPd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F9606A32A;
	Thu, 19 Nov 2026 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg7ZsPd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F09F1F000C4;
	Thu, 19 Nov 2026 01:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050599;
	bh=KwcVbtHlhooZvo05IoyIJxARPTGicb3ZgR9hXN/oc+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qg7ZsPd2SImIdhvLcr+dyoGRmcfxnA+p0ySuel5IvhH02tn7hgFXiROq6OVvtPtyH
	 7nZg8nXJyDGMDY2dsxZcX2EfGGhpTVxA+JlZ3tEmytjO4LdUy2dIuXjmTjeGCSMfUS
	 jzcaqZAbwCtqxIA60rHsUCZA3wK0JOSz1J3emhPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Qing Zhang <diasyzhang@tencent.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2766/2857] nvmet: protect nvmet_ports_list with nvmet_config_sem
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150341.197257126@linuxfoundation.org>
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
index cbc3693d5fc0a..25a16d2336f5f 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1644,7 +1644,9 @@ static void nvmet_port_release(struct config_item *item)
 
 	/* Let inflight controllers teardown complete */
 	flush_workqueue(nvmet_wq);
+	down_write(&nvmet_config_sem);
 	list_del(&port->global_entry);
+	up_write(&nvmet_config_sem);
 
 	kfree(port->ana_state);
 	kfree(port);
@@ -1701,8 +1703,6 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			port->ana_state[i] = NVME_ANA_INACCESSIBLE;
 	}
 
-	list_add(&port->global_entry, &nvmet_ports_list);
-
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
 	INIT_LIST_HEAD(&port->referrals);
@@ -1733,6 +1733,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
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



