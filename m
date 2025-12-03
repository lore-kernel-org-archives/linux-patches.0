Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4FC350D60;
	Wed,  3 Dec 2025 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781205; cv=none; b=dZGuwLf6gqahRP75P5+D+wynVUfw1IY8++6PtZDVxterMuFIqDe08FZYrNKBkZcII4P2Sf7+CpC63eVlEp6/hEH8Y3k1Oixw6PcLuFLAI2mFgodtIx1iwqyVyQ5QlLqn5ADxTNVK/FUJ4DZQSt5vjt18H6EeFmTyYy/IuZCV9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781205; c=relaxed/simple;
	bh=H1dsj1s/vE7eHD1S9UAtCxf8EtgFhGtpcxyYzpsJ0DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdGm7XYWwmWT+S1gU+b11YAskrr/1w8yWYH5jcv+oABG2W3qH+ves4tTsQmGSbFj/zwVOcn3eJClARlpVzxt4EmU0fJh6pjpfcTZj3EOSXP2Tkls/hsc6JMHxyCMnlzyWT4gRbj3g8141Oh4vKcoDA4nk5L4i8jZ28Mn2R6I0+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUv/4mUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUv/4mUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8277AC4CEF5;
	Wed,  3 Dec 2025 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781203;
	bh=H1dsj1s/vE7eHD1S9UAtCxf8EtgFhGtpcxyYzpsJ0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUv/4mUpEkbyuEvBkbRJi0V4d1Aq1AMSBU9AlYLv4CnJgXBgqQPRe//K53wBrJL+n
	 1ZdkRiAPyfgUK6tK+sEVLxzODMs+XgQgHhkK5xurbuYESK9SsNVwiwyir65Dcavvfk
	 em2uFN7xTlWuQCz7tiXVjnNnG84vHtX2z+JPOqg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.6 55/93] serial: amba-pl011: prefer dma_mapping_error() over explicit address checking
Date: Wed,  3 Dec 2025 16:29:48 +0100
Message-ID: <20251203152338.558043312@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit eb4917f557d43c7a1c805dd73ffcdfddb2aba39a upstream.

Check for returned DMA addresses using specialized dma_mapping_error()
helper which is generally recommended for this purpose by
Documentation/core-api/dma-api.rst:

  "In some circumstances dma_map_single(), ...
will fail to create a mapping. A driver can check for these errors
by testing the returned DMA address with dma_mapping_error()."

Found via static analysis and this is similar to commit fa0308134d26
("ALSA: memalloc: prefer dma_mapping_error() over explicit address checking")

Fixes: 58ac1b379979 ("ARM: PL011: Fix DMA support")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://patch.msgid.link/20251027092053.87937-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -636,7 +636,7 @@ static int pl011_dma_tx_refill(struct ua
 	dmatx->len = count;
 	dmatx->dma = dma_map_single(dma_dev->dev, dmatx->buf, count,
 				    DMA_TO_DEVICE);
-	if (dmatx->dma == DMA_MAPPING_ERROR) {
+	if (dma_mapping_error(dma_dev->dev, dmatx->dma)) {
 		uap->dmatx.queued = false;
 		dev_dbg(uap->port.dev, "unable to map TX DMA\n");
 		return -EBUSY;


