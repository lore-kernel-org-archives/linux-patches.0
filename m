Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08682459EA;
	Tue, 29 Apr 2025 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947817; cv=none; b=ClTltSjNSndHeCBJ1LhWsVPbTQ2y1n5U3x4wJlOh6G+BL+KKUVliwQDjbbEbcfEUU5MpylEC+sAJvbENC/A3eiAadp5GjFPiGz0hE/jq9lRxYm2X9Y26QxcDUmuhoBMNLLV5579SfuKN4JxzfoUVjmLDdmv2cGjveBUwnohwi7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947817; c=relaxed/simple;
	bh=9VohW/vnBoTNNSoBbs1rhy+HnyFQ/juW4knu/D/Oebs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYFaHbh28SDbqIyzSxTxOle2IhUinjoxwKjIscfRdYmF8KRGBGlf4sdR5hRVgh1owNwtKClgEJKVoG6V2I03Gk+d0TBrSN8yrnHjO+CLzOHaMH7636XVRHPdZweU1Okuxz2pTraCC9K9xLCos8iBx7u2vSiWi2eHZhSrJr2V9O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/3BXOJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/3BXOJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2D5C4CEE9;
	Tue, 29 Apr 2025 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947816;
	bh=9VohW/vnBoTNNSoBbs1rhy+HnyFQ/juW4knu/D/Oebs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/3BXOJI+S6tdOK62lNNk61DElzpEeSa18sGUgALRIFdvLZffFhGBv0bofBj9gjWK
	 G8tGfcv4NqxCe1JHAzmv1dO765RX/GWLTTo7XVuIf98Jk8+pY9zrvumyaujDhHikYX
	 jyOPMe+LZfU2JoWo3S0m4shMiHThLpkgCmUna5JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 112/280] io_uring: fix sync handling of io_fallback_tw()
Date: Tue, 29 Apr 2025 18:40:53 +0200
Message-ID: <20250429161119.696579654@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit edd43f4d6f50ec3de55a0c9e9df6348d1da51965 upstream.

A previous commit added a 'sync' parameter to io_fallback_tw(), which if
true, means the caller wants to wait on the fallback thread handling it.
But the logic is somewhat messed up, ensure that ctxs are swapped and
flushed appropriately.

Cc: stable@vger.kernel.org
Fixes: dfbe5561ae93 ("io_uring: flush offloaded and delayed task_work on exit")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1103,21 +1103,22 @@ static __cold void io_fallback_tw(struct
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
-		if (sync && last_ctx != req->ctx) {
+		if (last_ctx != req->ctx) {
 			if (last_ctx) {
-				flush_delayed_work(&last_ctx->fallback_work);
+				if (sync)
+					flush_delayed_work(&last_ctx->fallback_work);
 				percpu_ref_put(&last_ctx->refs);
 			}
 			last_ctx = req->ctx;
 			percpu_ref_get(&last_ctx->refs);
 		}
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
+		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
+			schedule_delayed_work(&last_ctx->fallback_work, 1);
 	}
 
 	if (last_ctx) {
-		flush_delayed_work(&last_ctx->fallback_work);
+		if (sync)
+			flush_delayed_work(&last_ctx->fallback_work);
 		percpu_ref_put(&last_ctx->refs);
 	}
 }


