Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625796;
	b=g8HotMXAHUU+KRk4ouySAILuVfTwOxLh/FbNmyMCePcvARaKrd3ulsKZu61PrxjgfzRD
	 7bCrDcyTaEpRTv5xtFFS+8hNw4cZBlfxFIech2bQX3jPI9c/PamNvlS9xAyqsKUXOFm2C
	 ggdGoHgUMZZwehHpW3SumcrKUN2cGycegiNlTqYZ6aw01ZNUgy+vxdngn16jZ/cFUGxXk
	 Kkdh0PnZD/7ZERCDz/Q0et60BsX++ugiDZYjIMm0hoJ8zJqOWk8+1Q6Ly//+4LoZeajra
	 IxkblZZ/Qgf2dFU+cUoqea/OIXfsSmkeQzZaD0foq1MOEbcwRV0LUpLd4kdpGWi2h7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SNfEpA0F6/tgg0b0A9OA1PuWtJCQCBgMAPwRCbsf/+M=;
	b=Z/ACrh1UL6TROoVPVhmoNBBtrqtOHNH8cXyoNS1mHnTqlm+84NS8ZI5t2MG3hoXTncXU
	 Mc9DjIovyaV2JP+BWpzIxHKK7zF/gNOMFKwN7GOqwgNJT40upgORruFK1Jm8S+rMJLNVn
	 dtNHEmCV8OgzLXq6CHdb/rURUXIKawBtF8am7KePOIwpHtL5NsWahQjlzCKKRfXDoMsDR
	 FgNRT/am1nb8rYYmwqnVoKiHoXaVs3i51oBCyzL50Dfj7ao3B+isrZSYfNzDLvTAm9anf
	 7nxiuTciSg2gYQI19VKl6mKGPP4ZXmOaLkKBsDo9QN6jTKfeTyhI+BH5D/RXkhDbqgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=krt80RJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C02606A330;
	Wed, 25 Nov 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=krt80RJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE85A1F000EB;
	Wed, 25 Nov 2026 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625795;
	bh=SNfEpA0F6/tgg0b0A9OA1PuWtJCQCBgMAPwRCbsf/+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krt80RJNFzrBC6xguqNuN7O7rIkIdwVT8vCeWaTV62/cezPba0nJZQ7tcAjso6dRG
	 s7r3mBkrGzejIa6N6i7NrxQPzHcstSjLye3fimN7wGE8m0UEsqxuUa3mBOL07oz2fd
	 lJP8A2m6/BivCQBsrlVFS68ZVLiAkHnEfBVlCrAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 634/816] xen/pvcalls: destroy the per-socket workqueue on release
Date: Wed, 25 Nov 2026 15:36:22 +0100
Message-ID: <20261125143903.859223908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 6b3feb6bfa9ac384f7a3ec25c40b9b4d3da96d25 upstream.

pvcalls_new_active_socket() gives every active socket its own ordered
workqueue:

	map->ioworker.wq = alloc_ordered_workqueue("pvcalls_io", 0);

and nothing ever destroys it.  pvcalls_back_release_active() flushes
map->ioworker.register_work and frees map, but the workqueue and its
pool_workqueues stay allocated, so a frontend leaks a workqueue per socket
it connects and releases - a loop a guest can run as long as it likes.

Destroy it right after flush_work(): the IRQ is disabled and sk_data_ready
restored by then, so nothing can queue new work, and the rings are still
mapped while it drains - pvcalls_conn_back_read() reads map->ring and
map->data, which xenbus_unmap_ring_vfree() takes away a few lines later.
pvcalls_back_ioworker() does not take fedata->socket_lock, which the
backend_disconnect() caller holds here - only the socket's own
sk_receive_queue lock - so draining it from this point is safe; the
flush_work() just above already has the same requirement.

Fixes: 5db4d286a8ef ("xen/pvcalls: implement connect command")
Cc: stable@vger.kernel.org
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261110125002.46683-3-yhlee@isslab.korea.ac.kr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/pvcalls-back.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -452,6 +452,7 @@ static int pvcalls_back_release_active(s
 
 	atomic_set(&map->release, 1);
 	flush_work(&map->ioworker.register_work);
+	destroy_workqueue(map->ioworker.wq);
 
 	xenbus_unmap_ring_vfree(dev, map->bytes);
 	xenbus_unmap_ring_vfree(dev, (void *)map->ring);


