Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D86A381A5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvPLnvf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F61AC4E779;
	Wed, 15 Nov 2023 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081558;
	bh=LiY6bRoS7JqboZp3Ns1p/Il326v06zpiLmQbHhqEM/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvPLnvf0nD82fZDFdUawF7FqOqOgRE6oZ1YgZxd4Y8vz4qEYKBpnyJ+VoOrKoTEfB
	 kfqPGA2af9nxpbauZn4r7rXPJCsCiNkiTQie45Isc4PnkA/ssMi/AUfg6krjUNoEVh
	 sJ3oe9Cuofvhf7Nu/S5G35WnG2H/u9VEnvnsc6kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/244] pcmcia: ds: fix refcount leak in pcmcia_device_add()
Date: Wed, 15 Nov 2023 15:36:31 -0500
Message-ID: <20231115203600.319732186@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 402ab979b29126068e0b596b641422ff7490214c ]

As the comment of device_register() says, it should use put_device()
to give up the reference in the error path. Then, insofar resources
will be freed in pcmcia_release_dev(), the error path is no longer
needed. In particular, this means that the (previously missing) dropping
of the reference to &p_dev->function_config->ref is now handled by
pcmcia_release_dev().

Fixes: 360b65b95bae ("[PATCH] pcmcia: make config_t independent, add reference counting")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
[linux@dominikbrodowski.net: simplification, commit message rewrite]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/ds.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5bd1b80424e72..bdbd38fed94d2 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -573,8 +573,14 @@ static struct pcmcia_device *pcmcia_device_add(struct pcmcia_socket *s,
 
 	pcmcia_device_query(p_dev);
 
-	if (device_register(&p_dev->dev))
-		goto err_unreg;
+	if (device_register(&p_dev->dev)) {
+		mutex_lock(&s->ops_mutex);
+		list_del(&p_dev->socket_device_list);
+		s->device_count--;
+		mutex_unlock(&s->ops_mutex);
+		put_device(&p_dev->dev);
+		return NULL;
+	}
 
 	return p_dev;
 
-- 
2.42.0



