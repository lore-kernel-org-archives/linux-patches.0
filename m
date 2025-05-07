Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5C428E59A;
	Wed,  7 May 2025 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644721; cv=none; b=pvqmQJeGg1L2m1PzIm9A0Yzr0s7CqEgZASrQqMBS/9PP5MNiqCJATtR2iKjkdVLis43Lm6mT93ZUBleTQCObUKl2GOg1Os9515LXjUS0V1+MIePErwHyr5zdMOynPR4j0KABl3oGUbr0wNjaE9bdaIAlulPYAuiNnQypuPTfJJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644721; c=relaxed/simple;
	bh=BAVYrHt/SK5T6261OVEzoTTGLJs5rWo5gp5wijMVb9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGA2i8aLsqKAzZPfvypz7bng/1NeFQxaenLpe0rAiV+On0GYrF8bgUzVzseLoo2+yFRngvmXHUM1uSag6KQzj7iIPIVCAwHRIqPQtPAtYwkAtYDfp5CtwdsaO+CmNzi72UOvH5e5e5zW85AQTDPfQytxMXKkxp0I21+JWX6Gqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAXUPISL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAXUPISL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CD8C4CEE2;
	Wed,  7 May 2025 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644721;
	bh=BAVYrHt/SK5T6261OVEzoTTGLJs5rWo5gp5wijMVb9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAXUPISLodEwExLeCVOvjOO6lAQCIGUPlx12xEzWTKMmouhyI0ilJpPERIg9xZAxj
	 9ldTSK2GEn+l4JCrn8FQEWSMD5uSyJKGcCvXSJe39RbgQg4vs+Ru+yVnWIxHI+WnfQ
	 VX33JYkTTXVNs6HTOkAWh+x6Jmqba4bcaUtrhJ4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 136/164] blk-mq: create correct map for fallback case
Date: Wed,  7 May 2025 20:40:21 +0200
Message-ID: <20250507183826.480841395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

commit a9ae6fe1c319c4776c2b11e85e15109cd3f04076 upstream.

The fallback code in blk_mq_map_hw_queues is original from
blk_mq_pci_map_queues and was added to handle the case where
pci_irq_get_affinity will return NULL for !SMP configuration.

blk_mq_map_hw_queues replaces besides blk_mq_pci_map_queues also
blk_mq_virtio_map_queues which used to use blk_mq_map_queues for the
fallback.

It's possible to use blk_mq_map_queues for both cases though.
blk_mq_map_queues creates the same map as blk_mq_clear_mq_map for !SMP
that is CPU 0 will be mapped to hctx 0.

The WARN_ON_ONCE has to be dropped for virtio as the fallback is also
taken for certain configuration on default. Though there is still a
WARN_ON_ONCE check in lib/group_cpus.c:

       WARN_ON(nr_present + nr_others < numgrps);

which will trigger if the caller tries to create more hardware queues
than CPUs. It tests the same as the WARN_ON_ONCE in
blk_mq_pci_map_queues did.

Fixes: a5665c3d150c ("virtio: blk/scsi: replace blk_mq_virtio_map_queues with blk_mq_map_hw_queues")
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250122093020.6e8a4e5b@gandalf.local.home/
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20250123-fix-blk_mq_map_hw_queues-v1-1-08dbd01f2c39@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-cpumap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -87,7 +87,6 @@ void blk_mq_map_hw_queues(struct blk_mq_
 	return;
 
 fallback:
-	WARN_ON_ONCE(qmap->nr_queues > 1);
-	blk_mq_clear_mq_map(qmap);
+	blk_mq_map_queues(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);


