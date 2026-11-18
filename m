Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016173;
	b=0nxLYOLh84+CsQIcsXZimNkUjKEgXiMFGoIrKTM8cyPgr+D5EniPvXns2XxjCtaYSrQk
	 4ta94qGHjb3uWJLtPGeyPT+ndhpuki1FtbZUQydW3J0IgV9GnJDeHaCf7WVpiHUsW2NjQ
	 /EMfb5DUagEWIfpcvru+kjV7/V7VjztScgYfh60SsSEL00/Dc0TtGCjoLdMCoghKnafyF
	 OX2Ev/o0cFy8ou5cHkg29BusRNbAnxCRJArToFbNbLYpwsCZLdalbWnznS7EZy+cdtiz5
	 4ourewfngnYXB2YPtlmBpUkJFO7uUSHxQxlFcoebz+fYKanKD2mF2/Pq9O9R1riUcJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsnXl62hq4aEKiUibd5eAuJ72KUiEjJBNj4td/2uMAY=;
	b=LAJf82I0A+aFgWv0GTNqlfmGIFniRj3+uhwYbPZPJ6L7R5YGFp9jaiWPVRPAn3fjJmSD
	 8xMcVuXtAu4QI8vteqVoPYd60z7Tzab1RxQ+a0ScNznp7msTNzHOW429/a4KiqGDlzMbA
	 SMw0x1jbRsdaIH6XFpQuuA2KDZnIG4/cJ7U0Jn6VJKKiYFhhrtzTtlyzGLffO+wkzkzzS
	 XZKr0C+6sfeGP4Yw2NEN2F5k/C53QK82kws4SMQeUl0s5geyJeNZ/FVPAUUtk+PKkJ1/C
	 DH2BMN7KTp/zWaF2V8wJhyJ8n6+f6RvCZctrhGrDg5+NSbaqK5Jgbitf/6vTZ9qIUKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0W3mO7hX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EF9606A31C;
	Wed, 18 Nov 2026 15:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0W3mO7hX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A85F1F000C4;
	Wed, 18 Nov 2026 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016172;
	bh=GsnXl62hq4aEKiUibd5eAuJ72KUiEjJBNj4td/2uMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0W3mO7hXQtRXdMV4F4Y5AF/jdvk2NX3wqoDtVgqMLpDi1Fk8GKDey3rMorA1YlBol
	 +6x66kKVAxqYzlhTXDmRhJZtiLDuExHH3pCGddlPd27QPfQIi4xfBektL6tDOwogwH
	 OVLgMVJf+ncYwT8g8zCvBfmhDoNZslZvBXxhAW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0436/2651] virtio: synchronize callbacks after device reset
Date: Wed, 18 Nov 2026 15:27:56 +0100
Message-ID: <20261118150303.522929049@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit dd75508e6fe77116589c49658d0d18897688dc0b ]

virtio_reset_device says:
	Note: this guarantees that vq callbacks are not in progress
but in practice, only virtio pci correctly synchronizes the cbs.

On other transports, a callback that is already executing, keeps running
while the driver tears down the state it uses.

Add virtio_synchronize_cbs to virtio_reset_device fixing this for all
transports that correctly implement synchronize_cbs().

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/all/20260818040433.66986-1-kmehltretter@gmail.com/
Fixes: c46eccdaadab ("virtio: document virtio_reset_device")
Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Karl Mehltretter <kmehltretter@gmail.com>
Assisted-by: LLM
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <8ae2995ee649adcfe1398f7f1c4fc9f7028c3db1.1789204858.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index b6c9e927bef57..a8588d7ad109f 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -264,6 +264,8 @@ void virtio_reset_device(struct virtio_device *dev)
 #endif
 
 	dev->config->reset(dev);
+	/* Flush pending VQ/configuration callbacks. */
+	virtio_synchronize_cbs(dev);
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-- 
2.53.0



