Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656E342BE8B;
	Thu, 16 Jul 2026 14:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212267; cv=none; b=pCr5XyWDF4J1b1dpIsPpIcmjYUx/ylBkU/aHMIeZOA+q3zXkzmhczsdjvvcvnpGHqOSlRJ4u3kkOi5DmrG5xYVRrD4GxtboWXOwBFLbRw6/sOXiS475L1d3b75yovppKAL9i9UqRVxbolvon+4RrugNuBVKXOItSppwhREZ4GMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212267; c=relaxed/simple;
	bh=aq3gInE8sPqECHMTU/g5DV/deNVrn4x/gmhyv6KhSnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/VmEf0MelKV07RXeLO7ktUquxe0qmMOgoHD5ChhqTvMCMp6kNaX7PXSsolDN5MKFK13Ue90KTwb/ZtbFKn9MZ2n64eCkKgNRWsCY1GOA+fiuyF+yuEV+RyFAMtlSK6IkKN67g38JQbDsanmTuAvjHxlaRidM7b/I5QDH7Rbh/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icWEVpAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icWEVpAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18E61F000E9;
	Thu, 16 Jul 2026 14:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212266;
	bh=2Bqe84/Kb934ivYbnCrevjwucHWNsD1fW+DzG+RwiNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icWEVpAg5Ts+5Szlfe2zsFrUYLUo0OEL8kWHLJN/AHiNqO4pmZ4s7rQ2+H3qCdhyQ
	 B6GKRHuC4CJ7/jq3ALDd7EEJ19w48ZyLzPxLivy4YoZD5szoipdBcjYoM1B8rXrD9h
	 3w+UnhiFo0QtzCO+GU/pgwRNAWbP7Co6H+ekwjjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 262/349] nvme: target: rdma: fix ndev refcount leak on queue connect
Date: Thu, 16 Jul 2026 15:33:16 +0200
Message-ID: <20260716133039.213568368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit badc53620fe813b3a9f727ef9526f98567c2c898 upstream.

nvmet_rdma_queue_connect() calls nvmet_rdma_find_get_device() which
acquires a reference on the returned ndev via kref_get(). On the path
where the host queue backlog is exceeded and the function returns
NVME_SC_CONNECT_CTRL_BUSY, reference of ndev is not released, leaking
the kref.

Fix this by adding a goto to the existing put_device label before the
early return.

Fixes: 31deaeb11ba7 ("nvmet-rdma: avoid circular locking dependency on install_queue()")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/rdma.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1597,8 +1597,10 @@ static int nvmet_rdma_queue_connect(stru
 				pending++;
 		}
 		mutex_unlock(&nvmet_rdma_queue_mutex);
-		if (pending > NVMET_RDMA_BACKLOG)
-			return NVME_SC_CONNECT_CTRL_BUSY;
+		if (pending > NVMET_RDMA_BACKLOG) {
+			ret = NVME_SC_CONNECT_CTRL_BUSY;
+			goto put_device;
+		}
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);


