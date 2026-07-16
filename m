Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3FF3B42FC;
	Thu, 16 Jul 2026 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211194; cv=none; b=Io6Mb7XZIdhVTEFFi5TEiukKeNbYG2WbLkSj6wPZVanGFoDX9BsWQ/BNGQM4huf4ayrSMrgWe9elUX7isVj++zO483fbMNoVys8faECLb9uosFY/FsLdbVHtHen+Mhc5ugeme4bTO5hhEjos3YvPJtm6oATtx8BV9dXjK+fLdog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211194; c=relaxed/simple;
	bh=XlJZ5vtcKnGaPosdIbUkSjKldwKk5F7UHkDZMip0O+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrzcjeSJZtlUlwwyY2c3kbFrAgPjY0kS4aQ41xQ4PMfM7NswbhGAeEQd092+cJAfQgxQIyNSseWfq+FQ/vm/HTCdq/A1HcAa6zGbWhJyFXt2cykQOsshH+qA4qWz27v4aQALpRg+KPx54FqUyV3UI2EVZSioofYfMBVGB11pzqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqsskDRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqsskDRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C291F000E9;
	Thu, 16 Jul 2026 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211193;
	bh=bp8oPDIxrj8Elhy5jJVZFTU5wEQs05l4QEF9zAVrz/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqsskDRjlJ7dn1IfESjs4PPESSZvtHva6rY68ZnfvqLdmxoPZ/miQ0OAw2DPT9uxW
	 z7EmbvBLNZllK+l8f+S9REpvBFjei5urI4xxwz3b7F514ooFjtLCB8zlX5Mu/nyO7W
	 Ck/gaZvOjEvgnu9argIoF9xbkcEoYaEcCtIt8In0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 336/480] nvme: target: rdma: fix ndev refcount leak on queue connect
Date: Thu, 16 Jul 2026 15:31:23 +0200
Message-ID: <20260716133052.081895701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1599,8 +1599,10 @@ static int nvmet_rdma_queue_connect(stru
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


