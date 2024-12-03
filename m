Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434E1F757E;
	Tue,  3 Dec 2024 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239768; cv=none; b=KyztVfWGgvG50Rf7W4vFn3s1l8aGuSAvcrey45+/H+v1sBB888rAnTnBgyPCh6pzVxKzfGLZ/GjZO+4b20vAZYikJvZc8MPy4Ua5UAg3MFh91XYpS54N4cxm+DhYoXEdpqCwkT3jhTqS2X+4qNAh3Dy8i4iyh0sutxM1XMvE9MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239768; c=relaxed/simple;
	bh=ev92U3HLxVHtrA1teeFTNI2OtiZj7VLtkq3kejFP3KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkdRPQoT019H9BBErbClx81SLtOaPUZLXKaZ9fZSsop84xh9zekDdiJeDBF+/qAYo+A55soTilDv5OaANtODO+x0eh1GSkXT34CI/OKE44ezRxlrSCQWsXdCadb04mtES11hcZyXVDPn7qV9h7roUQo+g4JIN1X6stIukENMP4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GPvBa90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GPvBa90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086DBC4CECF;
	Tue,  3 Dec 2024 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239768;
	bh=ev92U3HLxVHtrA1teeFTNI2OtiZj7VLtkq3kejFP3KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GPvBa90gR0Z5703Mj8Bq47z/c7C6AWmfE/J44qRUSswjXrS7yRKXlQ686ccLqNrF
	 SGuYwo4ZPPdvMZnSILFcikEHOx0oDMCW+BH+UOR2fGM2uatqQp8PHISfGuzrvzgTX1
	 zzfMLw+ecr436MIzXvyW4L00fNJDMKUhMheVoPeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chao Leng <lengchao@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 728/817] blk-mq: Make blk_mq_quiesce_tagset() hold the tag list mutex less long
Date: Tue,  3 Dec 2024 15:45:00 +0100
Message-ID: <20241203144024.411314631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit ccd9e252c515ac5a3ed04a414c95d1307d17f159 upstream.

Make sure that the tag_list_lock mutex is not held any longer than
necessary. This change reduces latency if e.g. blk_mq_quiesce_tagset()
is called concurrently from more than one thread. This function is used
by the NVMe core and also by the UFS driver.

Reported-by: Peter Wang <peter.wang@mediatek.com>
Cc: Chao Leng <lengchao@huawei.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 414dd48e882c ("blk-mq: add tagset quiesce interface")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20241022181617.2716173-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -283,8 +283,9 @@ void blk_mq_quiesce_tagset(struct blk_mq
 		if (!blk_queue_skip_tagset_quiesce(q))
 			blk_mq_quiesce_queue_nowait(q);
 	}
-	blk_mq_wait_quiesce_done(set);
 	mutex_unlock(&set->tag_list_lock);
+
+	blk_mq_wait_quiesce_done(set);
 }
 EXPORT_SYMBOL_GPL(blk_mq_quiesce_tagset);
 


