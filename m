Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F68B78F58;
	Tue, 29 Apr 2025 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947763; cv=none; b=Q8qhtG4dUX5RL69z8MmQ6uAa6nr2uaKqtDYJ8+XS1LxXHtJnBkDnKaE9WhizenAFkvxUv/HMumx/6GiXyYfAYy/UtVpTfojcsQ70m573jsuWiSS0y+NIyzDVL0UtTsHEsTkejl0AkZ7iKzWuLGXryScTeMAqWrTne0KhAxzcX3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947763; c=relaxed/simple;
	bh=P3ljcjQSjrIdrnB4mi0YxCIsb5NbK2PPbgnuJsKLWOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP4tirKozc2kkS/k+oC7EC1XCZls9V6TwnrPzBVDy6WGT1TtUOf9xuqaBokDfKKddVcrrM/AAaVgZ4Nmsn9LNceSx0poOZkgtl1fMy0HKd0ICwdNMc65qXUP/xnRB1uLkuW/yOUOEpNwBwp36JhDUUZAtHwM7lQeaVIIhwUte6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmKMiCXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmKMiCXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55BFC4CEE9;
	Tue, 29 Apr 2025 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947763;
	bh=P3ljcjQSjrIdrnB4mi0YxCIsb5NbK2PPbgnuJsKLWOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lmKMiCXjV+lTnwCS8OGUWWMhO3Z6djj9Na2KwBlCLgg1H2c4sKsKTeLvs0ATHLGLj
	 fWR+Fz1qgd5PS/V61PrLKWLJDLpzb00Rma+gI9HIqabYfYdZMDJT2Te3w1VNm9wYsL
	 d8hCPwlJsxkXN20AXlAlDY8JdoTqNNeQdna/22mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 097/280] xen-netfront: handle NULL returned by xdp_convert_buff_to_frame()
Date: Tue, 29 Apr 2025 18:40:38 +0200
Message-ID: <20250429161119.081552751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


