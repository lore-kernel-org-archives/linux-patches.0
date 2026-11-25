Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621207;
	b=PVPtPAG1jhLjEHHc39lGNBdxpfWTkS2JxRvZcMoktnPiP/Wt8I810q9rWw75Hvc/oQp8
	 84u1hvx5VfHi0sAkyzqSzKQcpQ1zeufe5ymOXpkl7aL1Q0LnWrJHEfXYlhedq3GimdbVK
	 /4VXwS4ou6VSf0N0ZF4e6ev2PNrqgjsh/nsZEsSQGTY3np2JppvAtVMdNQPmrez8Eugl8
	 ph8c/CDbqMV+DuKh8/WGPQpVUDX0wzNver8K8oYoZwMpjhcRAmyyW3vhgnjQVfRlEjlKv
	 lHsazgj5OKPZ+TTZrXmXjWe5Okp5lTN3Khxcgiha/UsS5xHu2l16Rydl4JG3BmnPKBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8AC4EuLNK5f+nEp1w5QOCUIiGPfLirXdOCOc8IXIGrM=;
	b=Je2ixBA23efdQv8yUyUuyMmh+b1NaCk0nU5B6ggG3VboLwpuSB0n4Pp5gjpy8ypH3+05
	 BcWgV0mYMgBuniGOwz+tKKj7z4WVeUj7uBBBbrAJmWbwys4Sg6Qvmp9lPs2Cpc2JyWMlZ
	 lu9il/Z5xhlPj0Y2G4OlLvyAa7B737LDKmL8yWGlawdro/agH3D7G4cNRjpIXQZeMPDvw
	 SsqnOVDFL3hYMzKVMUnMXkgqYPnLYxLFuXLUZTR/FCt+XV3KmBpG+IhkXy2VtVGWfCisp
	 y6Q/JiEpFbve5KSOvvfvtzq8LpxpdEv43816o7ZI+c0hGw4LFJNGtgNP31m9psDuYZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbsjUD7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9499D606A6BC;
	Wed, 25 Nov 2026 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbsjUD7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D185A1F01562;
	Wed, 25 Nov 2026 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621207;
	bh=8AC4EuLNK5f+nEp1w5QOCUIiGPfLirXdOCOc8IXIGrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbsjUD7fUo1kEj7dSgFG1U1FSvaGA4CABRrCQaKdkekLG77NiqAIwwIRqe3kb9CuV
	 BGtgEorNjt8Y3H0EU7ePayeJZSpvQnMPZFnRYL1+F+EwkxWbDJHZuEs3tb6wh+Be5d
	 fChjVodEnyqmCBKUSbIuRt/bYm20PJ9MDRKDfK/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/990] vhost-scsi: preserve event ordering
Date: Wed, 25 Nov 2026 15:25:20 +0100
Message-ID: <20261125143825.677439476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit a9a428115b7d8aa45e12e41899f90f60551bfa82 ]

vhost_scsi_send_evt() uses llist_add(), so pending events are LIFO.
vhost_scsi_complete_events() walks the detached list directly.
This can deliver a later hotplug or hotunplug event before an earlier
one.

Reverse the detached list before processing it.
This keeps delivery in enqueue order.

Fixes: a6c9af87363c ("tcm_vhost: Add hotplug/hotunplug support")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260915094244.7900-2-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index fac400b25dad7..4e078d439836a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -636,7 +636,7 @@ static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
 	struct llist_node *llnode;
 
 	mutex_lock(&vq->mutex);
-	llnode = llist_del_all(&vs->vs_event_list);
+	llnode = llist_reverse_order(llist_del_all(&vs->vs_event_list));
 	llist_for_each_entry_safe(evt, t, llnode, list) {
 		if (!drop)
 			vhost_scsi_do_evt_work(vs, evt);
-- 
2.53.0



