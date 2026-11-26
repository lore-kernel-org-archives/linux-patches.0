Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704600;
	b=DRUYlzAmZh4pjshDRzr/i8xyjmIV4wl8PC8yQ4GvzO4WNPGCx90298nV/kROdyb175zg
	 IbtCsZfbX5MKXNH4yVSvlu5c6jjsh3r1eP66z7YRwyURMlHyxQu45Z1xyfc8giYfwV6PE
	 dkupdw055OP59u6AUxnhV9nTFYCai0+eqFbew9tz5LxWLuEKR3yTmgxx2BWHAogUqe6ZK
	 l+Dw34+vocBM7SokFDI9oiivXRzOxP39GGUS/ifdQ9nDi4yeprExkDcvoBFLGyvTXEt0i
	 wR1XzDuakT1wrr+NCfQb7VQCiI1ZIyUw3ljAHnYoqVce8wIvXehWgGVSh9EUPpjK5vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IrmzwGFxYj+9GXgt2RsH61GJ7hlDEPW6aGQdXA3ObpQ=;
	b=cIyt8xdv1Q/FhrWDvlYQ00Hb4qws5unfXkz9U/ubGee7bAMXf3IUx1jhiM0qT+O/afMy
	 lPPZ+j6xKSUZIbMW406CUaHFAoPpaRFNH5LLkbuHl3Stw1Ci33ftNp2jFRTfshE2XnBpy
	 YXmWQSGIDJ6M5YIUlqdSyIkMzhSmeMv7ZvzsThK60jEg9G4GW1lIM4iC3WSVkroz5bN+Y
	 h8haPPlGkbkUpG7hKPOKlr3n9iAaSZsm2fL45H62doYfsU36xmHZzYbgpildGo2I57kfP
	 1f8Es/M/kmcVxs1DezXN0N6aeAe6xXV3Xb+iW3OrjVlhCOfzt2eWo7L1mh1B3y+EhgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4A5X4RT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE9606A31E;
	Thu, 26 Nov 2026 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4A5X4RT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F201F000C6;
	Thu, 26 Nov 2026 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704600;
	bh=IrmzwGFxYj+9GXgt2RsH61GJ7hlDEPW6aGQdXA3ObpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4A5X4RTL4puCcsXI2nfsMXYGEY6J8S7Zi9pH5PqOE76N0JxVUpDAOgYEPD9Rx/9C
	 sTbd8a3XMmDO0Wy+nANLIxupWiapJKtp955flDpDDClALpgB6X/fhW0qRWkm/rW6EI
	 akM29X2PQlA7GHLy8M/Ie3UA2/5s5f/jmn86Z8Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <sstabellini@kernel.org>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 179/265] xen/pvcalls: destroy the per-socket workqueue on release
Date: Thu, 26 Nov 2026 15:38:29 +0100
Message-ID: <20261126143617.697877679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -443,6 +443,7 @@ static int pvcalls_back_release_active(s
 
 	atomic_set(&map->release, 1);
 	flush_work(&map->ioworker.register_work);
+	destroy_workqueue(map->ioworker.wq);
 
 	xenbus_unmap_ring_vfree(dev, map->bytes);
 	xenbus_unmap_ring_vfree(dev, (void *)map->ring);


