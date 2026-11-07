Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062700;
	b=3i3FnBpPUaoXdR61Frn1/gV2JbCG02BIoJlmbjcdl8Zqfi49EHVE5HihEXMnFuGBDeRj
	 oEepdg+FBAQqUylZv8iN6l0HmBPZaeAbWUkCCwzGUC9yOk7t1dwVGTAo8HuLD7GjaGoeq
	 XmVwAzn09qHhGYvhFVNNSiJj5sWmvYGqwmWz9wp+AADD6tH7sxDHv1vuc+vDR4mFFCXqE
	 OBqDGgid9Iw5IgZHKfuFKSeYuoRD6cJAIESFrNPVGjJvBXPvXkk/NQccU4NxGRzxFPUQ0
	 9LcldajjIeqNyBSVtyjz6Z6ZnhALHDUrpHlA8nitGuuHxw4t06B+3oH5GoT4Vjg8uEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0wzeTcRBnWsM9ouKePO356YuJTyRq1O/5/bFQ+SC1mI=;
	b=p4IS1aeJoc+AuaANMigtnqgQd71Wng0E267u66LU+EubKi08OCTI0XCoUni8xLcN8i9s
	 IFwmFJRg/12mMfTSUgqara1DghCKTIQT7UMF/bvvAf05ZPhtq2lEG7FOy9nDHcb5KUqhn
	 EhGoUEd6qMa679wd3aFEzKTMRQtNCitNDfbF9rc4jMexUSJE9/9K+tZF9Dw6YxaUypmAS
	 jHW3BOeytg8POwFcABKcZhq9izIP3wTZP2Wq6eLlUDN/Ci5o10BcZB8NmBl8IWLB6zdzr
	 wxtWWPq8ZJ564sHxqXZU99xUT3i2RMqKMnn/6mG/Fq3gJfPrL84iHoz1ElsHTroDF7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyeSsTAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724F606A326;
	Sat,  7 Nov 2026 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyeSsTAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671101F0089F;
	Sat,  7 Nov 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062699;
	bh=0wzeTcRBnWsM9ouKePO356YuJTyRq1O/5/bFQ+SC1mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyeSsTAYRn8BlOh1NN8azRP9fYFMJf3SemFSR9maJLpOgSlPCFlX88AMJkv7zX2f+
	 eEMgiKjqj0UqDQHmvqCN8NBQdvKCqX7nFsholUCmzIZP4SAHE8rnBZcH0XljALrkdm
	 WuZl0k8n6hUBUvZ5Rez9Mhwf35WYemUp5jB754y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Marek Czernohous <marek@czernohous.de>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/869] drm/nouveau: cancel the DP IRQ work before freeing the connector
Date: Sat,  7 Nov 2026 08:45:07 -0500
Message-ID: <20261107134852.943850020@linuxfoundation.org>
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

From: Marek Czernohous <marek@czernohous.de>

[ Upstream commit f60849975a886d70883bcb6b3658c0fa83c6971f ]

nouveau_connector_destroy() tears the two nvif events down and then
frees the connector, but never cancels the work the IRQ event queues:

	nvif_event_dtor(&nv_connector->irq);
	nvif_event_dtor(&nv_connector->hpd);
	kfree(nv_connector->edid);
	...
	kfree(connector);

nouveau_connector_irq() queues that work unconditionally:

	schedule_work(&nv_connector->irq_work);
	return NVIF_EVENT_KEEP;

A DP IRQ arriving just before nvif_event_dtor() therefore leaves
nv_connector->irq_work on the system queue past the kfree(). When it
runs, nouveau_dp_irq() derives both nv_connector and connector from the
work_struct and dereferences them, and goes on to take
outp->dp.hpd_irq_lock.

There is no cancel_work_sync() for irq_work anywhere in the driver, so
nothing else covers this. Add it after the event teardown, where no
further work can be queued, and before anything is freed.

Reported by the Sashiko review bot as a pre-existing issue, in its review
of an earlier nv04 FIFO series of mine, and confirmed against the source.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260812231330.705425-1-mczernohous@gmail.com?part=1
Fixes: 773eb04d14a1 ("drm/nouveau/disp: expose conn event class")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Marek Czernohous <marek@czernohous.de>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/178682366002.3748010.4096452389040554615@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 7c6d91ee2722d..f9662e067c56c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -397,6 +397,7 @@ nouveau_connector_destroy(struct drm_connector *connector)
 	struct nouveau_connector *nv_connector = nouveau_connector(connector);
 	nvif_event_dtor(&nv_connector->irq);
 	nvif_event_dtor(&nv_connector->hpd);
+	cancel_work_sync(&nv_connector->irq_work);
 	kfree(nv_connector->edid);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
-- 
2.53.0



