Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C451F17BB1C;
	Tue,  3 Dec 2024 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242512; cv=none; b=s0EslS2Zb05aYdlVV6kjk6E+MNuVIIcZyIlEFqzQfDTApFIxMsIc3MT/e+01peM7IytpxWFM80bZBsnkM6hdGP6HbWklgsOZUMJuDeYlJ8v19SVZQ5ryH2lGp2pBFs9N5NQlU1zO2073+SkfnuR7k6agGVdQmC1AIT5K2pkMNKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242512; c=relaxed/simple;
	bh=Qfx3xqa0+dY0McnI/OkVOX5EDheaC0sgEgeKeLMA0MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVcujK6R+nXbvizBdWi/2DxOipfsbXJOmCl4hktvW+G5e4hSuT7EoxoTpVsxWYbSXYw1I3dMyaK+A+5EUqGLPMD2dVjw3lQ2ds0UiEh87E7dArro1nm8LmTVMOM7W97NgG4cgsZqVPrNDB4y6LQspwwcx1FFyVwmK1mOq9sT5e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ucu2SFjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ucu2SFjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4244BC4CECF;
	Tue,  3 Dec 2024 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242512;
	bh=Qfx3xqa0+dY0McnI/OkVOX5EDheaC0sgEgeKeLMA0MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ucu2SFjVPcTmHTLLLrVbHgalj3jyfRAVlIumxi/pew51Wos71D20GiGHucS6AjBrf
	 HSbwZFGRyt9Gwk0w4vREm/4UkroeMgcSyU5OTGYzLceRjlR4sBzxmJ9ldwAEsRkKsV
	 buQQwMTpeknheKYFN4sqgTdJFFqaxdT804STNQM8=
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
Subject: [PATCH 6.12 727/826] blk-mq: Make blk_mq_quiesce_tagset() hold the tag list mutex less long
Date: Tue,  3 Dec 2024 15:47:34 +0100
Message-ID: <20241203144812.121495171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


