Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FC82C60;
	Tue, 29 Apr 2025 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945981; cv=none; b=n/mvYg2XZuDhjRNl+WI3E6TmSGrTeYcXIL9N+vGA6aa/wYXJD/DPpdNrYfy4NjNZubyB3LE2FHVI5whCRtsyKUXKoGjmMumC0tT5NflorxKu8JkStBdB9nQx+oONRuA9iPkFTW2cyHKX7CkkzTuBJVe8yu53puO3w3f7fGEcEPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945981; c=relaxed/simple;
	bh=Q/hU/vVd6hLM/Y72H/ms/X/ifcjwPJ28MGQzMXMIXoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoTKl1uqidgx0GrqDDoyiIHqoMj7KrX51tb2OsDj/6GxWrte1pfUpgthQRPusexD8VuMalCln4mHTTRr45GQByBjt+tMTtYuL7H272r9sfFpvmniZglhSPDlYRuoOh9S3AvFV2UA5hI8PWK+pun9P8DOJLi37/DQrffIXly75lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYL2hmH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYL2hmH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED06C4CEE3;
	Tue, 29 Apr 2025 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945981;
	bh=Q/hU/vVd6hLM/Y72H/ms/X/ifcjwPJ28MGQzMXMIXoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYL2hmH5a3+M53zyUUgtJ70QXeSUvNqgUkoyMWpYMVDUJ/LmZoWug6uyDSQT0RmLq
	 UgTde/YMSR+AHoWLqQA6IMqDQTIryMn26ZPlQgDfc4rYdh9DMJnLU5u3XVeKKiZ7M1
	 Y9vGPM7sYLphC31NA2ayJMheK2bJ3o9iGXnHXwoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 113/311] xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()
Date: Tue, 29 Apr 2025 18:39:10 +0200
Message-ID: <20250429161125.661570654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


