Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A040C03;
	Tue, 29 Apr 2025 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949900; cv=none; b=KzlYrye1LegPyMLjGAE9FH5N3F2l+lHX0FZaAKKk0PAzZf1zQ62BUlKMq446Gy1y856CShl7BTmxlcfbw9aZCi5IC5B1l+5W2NYdFGuVlDIEcYN7ZWuDB9aVPjAytmLB12Q0fsQqPogsKAejTzVTnH2p6pu+8yzRMKSZWGQN8i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949900; c=relaxed/simple;
	bh=HfAwzIa23iAa2rifIYEyQl83J5jO1cW04Hst4HrIbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTeLk0mS8TVrhkeorNUclrgkt2PgORn6JIz/3/1mpApD7JGnAnckUjl5oV8zl74Rzzmce+VLJJg2P3Ez+N8rdtSagNOBTOexUcthIQRfQ9LU3CM2+pMpgKX0pfk/U3qX7znAP4sCC/dH1aMyv/d2ZFVPO+UlVDF2ECwF6DTiHd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBimpIbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBimpIbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2640EC4CEE3;
	Tue, 29 Apr 2025 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949900;
	bh=HfAwzIa23iAa2rifIYEyQl83J5jO1cW04Hst4HrIbxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBimpIbLpCC6u2yah+GC/Ww9WY36Gy60REjh6HIGnCYi+B3ZehcN8XQxAJQlFbjjI
	 tiyVWkxPatDkewZ+WyHGr1L/aejn5q5GGsj5K628Y46k38Ry87TMf4mBevfpSPqNPq
	 6ONIUcuz2TxcAdqdYhFpmVNG9Pkl2eQp25rX03UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 063/167] xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()
Date: Tue, 29 Apr 2025 18:42:51 +0200
Message-ID: <20250429161054.324576700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Nepomnyashih <sdl@nppct.ru>

commit cc3628dcd851ddd8d418bf0c897024b4621ddc92 upstream.

The function xdp_convert_buff_to_frame() may return NULL if it fails
to correctly convert the XDP buffer into an XDP frame due to memory
constraints, internal errors, or invalid data. Failing to check for NULL
may lead to a NULL pointer dereference if the result is used later in
processing, potentially causing crashes, data corruption, or undefined
behavior.

On XDP redirect failure, the associated page must be released explicitly
if it was previously retained via get_page(). Failing to do so may result
in a memory leak, as the pages reference count is not decremented.

Cc: stable@vger.kernel.org # v5.9+
Fixes: 6c5aa6fc4def ("xen networking: add basic XDP support for xen-netfront")
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Link: https://patch.msgid.link/20250417122118.1009824-1-sdl@nppct.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -985,20 +985,27 @@ static u32 xennet_run_xdp(struct netfron
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
 	case XDP_TX:
-		get_page(pdata);
 		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf)) {
+			trace_xdp_exception(queue->info->netdev, prog, act);
+			break;
+		}
+		get_page(pdata);
 		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
-		if (unlikely(!err))
+		if (unlikely(err <= 0)) {
+			if (err < 0)
+				trace_xdp_exception(queue->info->netdev, prog, act);
 			xdp_return_frame_rx_napi(xdpf);
-		else if (unlikely(err < 0))
-			trace_xdp_exception(queue->info->netdev, prog, act);
+		}
 		break;
 	case XDP_REDIRECT:
 		get_page(pdata);
 		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
 		*need_xdp_flush = true;
-		if (unlikely(err))
+		if (unlikely(err)) {
 			trace_xdp_exception(queue->info->netdev, prog, act);
+			xdp_return_buff(xdp);
+		}
 		break;
 	case XDP_PASS:
 	case XDP_DROP:


