Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705662;
	b=nNinKTGwNy08Lm+Z3piZgBU8Uclv3IlScVNc6vxw003bRyTGsfzjsaAwdUhtl26uFQ5+
	 17jj/wEKLVL5/Hf2GTC/ntkr2UxjhoRQqZjx8R6VQ+Dg8IP9mvtWfoI/Gg0hDhXKN2JBB
	 NH0suVY2U5IRbe28MO2jR4QWC7XArOQvX7GfbpOj7SKc9tWmUr/rhWYk2oI7h3v/OtQrp
	 ukr3AwBiuUc4aMMRz5u/q6x0Bm6zjH0J5Dbvamms7dbCi9htdJiy9gU9lHX1jsmSmx3aL
	 DsUT1EAx8+aG3hI+81QUzRID80GENdxdWwjv08KSdTNa3Y69ZPTzLMm4OUrdkn2L/fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=16nCsy5I7RgCiCpicn4vtu+6nzyfKOECxEGozk74L+8=;
	b=mpze0Xu0RX3vbpJ0/r1XGCbA9TvFY7leBITGNXdh/mZZI6nxH01ZGrDKsfO+VjQlQ9Tl
	 OihVB3TDALoAXV0241a058pxdhShXChtgnM8ke9Ccrfn1aAuanhO60pztqm6PHj8FnTHN
	 a+acKEmwQGFVPu3JHYKL6S5vY6Jip+urAMR1QzTPJE5pRlOZZrg5OI21iSQFI3o/EfoLQ
	 rBzcqcIHvi1BhIo35JqcIoMxiRj+1tCgn2P7BUtpR0k+rzXKhw73TeB7K7Ar7J8U5TQnz
	 9oPmnauv+hMYvrN40P4xClCFSYQFymPeWhwhEnsR/tmmXoRCWOwlj7mmuwS5T7d1LIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DA9NwpO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6D606A326;
	Thu, 26 Nov 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DA9NwpO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6951F000CA;
	Thu, 26 Nov 2026 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705661;
	bh=16nCsy5I7RgCiCpicn4vtu+6nzyfKOECxEGozk74L+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DA9NwpO/cHDAlOK9XHvrXbBuz1Om/kmFimvpWKpzpadssqnXkkdHC6ThKjH0Lxoo/
	 0zYv9onWff59WkLLpTVIgfy4gnJR6mu4Ninw6eGZtdt81Na8IHvVxdqAGbA/3Viafa
	 rC30uHv5F/nl4s+oNI7DXsZ6sAtr1WFyOCEa/ceg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 218/319] xen/pvcalls: destroy the per-socket workqueue on release
Date: Thu, 26 Nov 2026 15:39:46 +0100
Message-ID: <20261126144011.667273142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -448,6 +448,7 @@ static int pvcalls_back_release_active(s
 
 	atomic_set(&map->release, 1);
 	flush_work(&map->ioworker.register_work);
+	destroy_workqueue(map->ioworker.wq);
 
 	xenbus_unmap_ring_vfree(dev, map->bytes);
 	xenbus_unmap_ring_vfree(dev, (void *)map->ring);


