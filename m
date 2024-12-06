Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A419F145A05;
	Fri,  6 Dec 2024 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498248; cv=none; b=jJRL84UBMWXpgk6LJAdIXfEXSvOZXCiuecG9e4Wb3a/zvCjyLsqeA788LnBIsGw9UdFF2BPMKvSfQrpc6nVb/0rH6WRxHGEFCuTT1sSdFHIfzmcteCHZ069UJeYxJy6MCkOU2+Xu7zPAJCzC9uKu32v/SSdcug67TZ/CymwOKoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498248; c=relaxed/simple;
	bh=0RhRAVRRsdvx8XL9/Ct0+N9fwfXv/7UeNE6bpKquq1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azc8h2+md09Rkr1ewvZ4qIdV1rfGkhK9A07yZ8lwZxTKJq88wm2hZWrhKe7stMPcFIT94B4AZy6d8fR7WeaUX1x3knjnof/t6WFI6M8BPfGa9ndzI4kj/+ZkzE2U4sbDNhMjPxFFwIhdF8FaxLP6mqa2it2U77NevWrxLYGzg7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk/J/Tli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk/J/Tli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC55C4CED1;
	Fri,  6 Dec 2024 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498248;
	bh=0RhRAVRRsdvx8XL9/Ct0+N9fwfXv/7UeNE6bpKquq1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wk/J/TliBznLjOl90C1s3qM0UiBbtnXB7GSwE3Uh7bUNYSRAzCLyCUP1gE9ovw6kr
	 OkeU6vXs7bmnh0oO44ZwlWN9ZdpdJkeAclZUEn4pzQZyjIcHOBIyTZ9idUz0Zg51lS
	 inbvQpUuHUbzX92zuutPedxRFghqpg4tPNmLhovk=
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
Subject: [PATCH 6.6 529/676] blk-mq: Make blk_mq_quiesce_tagset() hold the tag list mutex less long
Date: Fri,  6 Dec 2024 15:35:48 +0100
Message-ID: <20241206143714.025580516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


