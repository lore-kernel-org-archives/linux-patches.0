Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E06446C18;
	Tue, 25 Aug 2026 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666195; cv=none; b=ib0G1lrW5Pjmj0fWsQwjTUChr/+KR/ulGhkRl/+Yvm6xHy4OJ0gzsA2WQ2ZZIoQX5fGuTVY5usgq3Dj0cARYaRGgMI3CF8+yr8Nhin1xVYaWilBUBcAzgHk7IiuBQRUZWvoWaREF1qiNdrwCuhJ7E7w5AiZH34/Vr8YPpvVF3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666195; c=relaxed/simple;
	bh=OplnNWzMIEAuJV0ef8jNZevUp07n12xAWkrs9NUKfeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fevunEM227ek+587vPKMk8L9f4hlVWiplrcs3kb9PrKKuFJaLtGQOBdj+tDNwYs1UDLAHpTuN5x4yR79vKuzsNRcuixAvSWC5URRUqgULWgDejtuSqhc9SV7nae9yFHVOaUt20GQoQj6dnm/+tvgAVai77fQzqgMLCErM4uhUXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bsk1wpJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bsk1wpJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B751F000E9;
	Tue, 25 Aug 2026 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666194;
	bh=MuyDCRQh9v8rVkdoolnxmKEFDssuuSgEsA3qKXiYnKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bsk1wpJqTisHuTpULtcZ4y07QH+tBGg+r5kZI/ZZ51u1b3aDaINcuehsYJrPOeO9k
	 IzxqgeaLIfgFOzsp+DHIgsBcfS7o0+9Mma0BY/X9fP3ERSeqSx/CM1PTTmrN8bPMrR
	 TUOApmpD4HTB3kvj/+qJb2g8y4kHzwnPOn9vsyFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 35/76] nfc: pn533: purge fragmented skbs during cleanup
Date: Tue, 25 Aug 2026 15:26:28 +0200
Message-ID: <20260825132542.934587716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 5718fc62198c38c2de5316020a90506f9e75e0bb upstream.

pn53x_common_clean() purges resp_q before freeing the common PN533 state,
but it leaves fragment_skb untouched.  The fragmentation helpers queue
transmit fragments there while sending large initiator or target-mode
frames, and those skbs remain owned by the driver until they are sent or
discarded.

If the device is removed while fragments are still queued, the common
cleanup path frees the PN533 state without releasing the queued fragment
skbs, leaking them.

Purge fragment_skb during cleanup alongside resp_q.

Fixes: 963a82e07d4e ("NFC: pn533: Split large Tx frames in chunks")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/2D896607CAE4408E+20260720021444.3362044-1-raoxu@uniontech.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/pn533/pn533.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2805,6 +2805,7 @@ void pn53x_common_clean(struct pn533 *pr
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
+	skb_queue_purge(&priv->fragment_skb);
 
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);


