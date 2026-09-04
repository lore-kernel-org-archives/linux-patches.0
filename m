Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8FD38AC65;
	Fri,  4 Sep 2026 05:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500925; cv=none; b=gekvDpk76b61jwooZTSpzTlk15fcHOLTae1ziavodvfx/v5Zw8ti7pY2bxLTrGOqoY7HSRXWsaYeis0ZgHKMAT86pjsqNMlxGjBB2u6vCFBRXdzXM6ZCO7lka1XTAP3vgtm0Hbq/9+h36GEgJ3hIfgqxbybSSvmXJ2GO4baXvEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500925; c=relaxed/simple;
	bh=T58gAth/uFqpw6WOOPBv6Ym1cuiFrHQtilxChaiQw84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdTjo4Nj0m8SZn5jYwH3nNKOuqp8rxod5WO54keRUyNbtYVrwhtjtg1XwKvrQfEn2b9dnT30qlsgw93Wqx9zew/5FFNymoihP9u07t+4rKP3vlAH93ZzhlvqiCMdatGqR8fNE2S4kT1bw1S293vS1F7YTvbdCsQ1ZuKwlUmSFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1uf6SAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1uf6SAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7634E1F00A3D;
	Fri,  4 Sep 2026 05:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500924;
	bh=7kFF29naiLRKafq429lRF9rFg+cZoLmrXAvoj3cVPZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1uf6SAAzLMQ+FLzpK9tnfWAvFaS4DXhFrjOPcmd4GKTYrN893JSZwmcfl9ocm4rj
	 Q8WjGHilHxto9j9gAp/VrNH/bBLwM7CZSoAxD8epgAf7487Aw2ScrhBxixOoLr2wOl
	 h16fwoZXwaWK16iMtdV7bVan1Fsismq3GDuHq8DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 228/552] bnx2x: fix double free in bnx2x_init_firmware() error path
Date: Fri,  4 Sep 2026 06:56:25 +0200
Message-ID: <20260904045754.659798830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d2796ffe38cb4155afe0eab23636295b096c27a5 upstream.

bnx2x_init_firmware() frees bp->init_ops, bp->init_data and
bp->init_ops_offsets in its error path without setting them to NULL.
The cleanup function bnx2x_release_firmware() frees the same three
pointers unconditionally, so if init_firmware fails and
release_firmware is later called (e.g. from __bnx2x_remove or through
the function state machine), all three are freed a second time.

Set each pointer to NULL after kfree() in the error path so that the
subsequent kfree(NULL) in bnx2x_release_firmware() is a safe no-op.

Fixes: 94a78b79cb5f ("bnx2x: Separated FW from the source.")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815122149.951215-1-yijiangshan@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13474,10 +13474,13 @@ static int bnx2x_init_firmware(struct bn
 
 iro_alloc_err:
 	kfree(bp->init_ops_offsets);
+	bp->init_ops_offsets = NULL;
 init_offsets_alloc_err:
 	kfree(bp->init_ops);
+	bp->init_ops = NULL;
 init_ops_alloc_err:
 	kfree(bp->init_data);
+	bp->init_data = NULL;
 request_firmware_exit:
 	release_firmware(bp->firmware);
 	bp->firmware = NULL;


