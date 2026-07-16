Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB7B3F822B;
	Thu, 16 Jul 2026 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209871; cv=none; b=Ht8fqVJimX/FiWAQSHupCIb0RbgqtIgiv/YAFn3lR7cWUjHMmo/83XdEVvC3ZvHFXk5YxVTkzvH1xPFt+M5xKo8FIGBeFlrZugOX/1iQvpTN7CRTAHTxPLfHt8yyJTT3s3snPNNK/YXf93m4HAUEPf2duzB91dLwbPQsm+84H3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209871; c=relaxed/simple;
	bh=iJgwTRyuUUulNNwlE3yhyXEo8IXEjlTk9LZkTJlKkxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVi9sOs+Kt1Eh49Mg5SUa7SMbOJblfFWZz7waKYBa9nglNhNr1q5VWMLw0Q+qo4k9T+dMNCHnymZg54IuHT9UEYdukNDLnRH6HiGPz8NZK7QLZKK39Duz5C7+PVECXiliCvrDtn9FcczQd863SSgA/3+r40MwKUOmaVBQlsx3Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amK0RAyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amK0RAyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02E01F00A3A;
	Thu, 16 Jul 2026 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209870;
	bh=YxDchpKlM8HUHqD3Oyycl4GydfLzChmVwrSW33DvJPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amK0RAyGr3WGXZ/8GW6mZXZECD34oSMr7vkhC8i/44NrYkeic9tLxgtXb8Xh2WP2W
	 wrXoKHQrFFzAA4ZdP3M3BqP+nuhVZ9wS1BlpcMvr72pPZKfmCf6AbrelLG905jfzwm
	 CEC+Bq0s6tkgz6raMGRZAKrzD2aPaBOqwNJVwiec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 348/518] nvme: target: rdma: fix ndev refcount leak on queue connect
Date: Thu, 16 Jul 2026 15:30:16 +0200
Message-ID: <20260716133055.437541023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1598,8 +1598,10 @@ static int nvmet_rdma_queue_connect(stru
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


