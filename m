Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036289;
	b=hSAYNu1e0h7+jt5dkDlk5qQyNZCY+prWo3wj9RYdq9cw6/l/Cyo7uPS0zDxuEh6cpZ8m
	 oOzhsCXevY4tWXuLLV0zf03odYsDCAxWQu7erhAi3TIAfg5qh6hODI0S6CcMOAjILrNWu
	 w8nIBjctEwdfAch22tZs5AnRNoc/AY4tsgrw6z+JeEfuQOwH9eEXM+/Snl5Hy4F1s0laJ
	 eHI3ZWhUkYIa6b0u6F7JGvjNQbtbtdYPnFhmfHnW+DOMBUpH86C4dYgJEkqbCn/m2yQCG
	 igj2GeE+NoM5FetvnIW/UcCTUK1tEHglnth7ITiXzAP01D4UAVclZI+Ti6XMvcQLkeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SRlds88ie6KEBFdLsW//YhnGIpZ9x4SaCn+ntEhOcK8=;
	b=Xdovfw5PYR/XMlgTw+C4ekVF0d3t6adwL7O8ntNgXDfhiMaK/RzB1LRP76CFslFnTVVF
	 t4rqxwYlnId5drKocKOlvxWY/LjqtLC/pHO3vSMji4ozSKwoxQ7EKzzz5F8HSNVtKfIFv
	 ZhLdmsQwNrmBNHq88mrGBWnQv6Sc3XnNdOsPN6BOtHjWKLedxdgSksafZTTv3AmhTAw+U
	 rlzOb6X68txEnbgvBSs/UTu1hqs0KgeEVea8CFBhDNFFZMtQziS6M/fVN7BbVsIzMpAwa
	 OSVYkCkF4vMZBpo5Loh1+L6uyK5uKGlQan/mfRl44G5K7KHroL8TC9j7t8PZci+1cEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1t7eXcK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5393606A32A;
	Wed, 18 Nov 2026 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1t7eXcK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48CD1F000C5;
	Wed, 18 Nov 2026 21:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036289;
	bh=SRlds88ie6KEBFdLsW//YhnGIpZ9x4SaCn+ntEhOcK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1t7eXcKTOZis+qwcb2hvSRp3/A8dvAPAGmZYxEklzV/LG5R1ZXmTupIvKaEINpmX
	 QB8mDN4A6SIfuLUrZOvf0ciFtzfQ0/gXz5HoMx4eKoCvA3wRAqA5xMKc88QSLR941t
	 i/HhtK36sEmMxfpQX48eip7rDU+FpW5P0fq4gFAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1005/3318] media: vicodec: fix NULL deref on oversized frame
Date: Wed, 18 Nov 2026 15:27:07 +0100
Message-ID: <20261118150350.029362277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c657eb609197e289b054bc2c4e86a0fc32dd7ebe ]

job_ready() only honours the is_header_valid() verdict when
ctx->comp_has_frame is set, and comp_has_frame is only set once
comp_size reaches the full frame size. Since the copy is clamped to
ctx->comp_max_size, a header advertising a larger size leaves comp_size
stuck at comp_max_size, so comp_has_frame stays false and the failed
validation is discarded.

Control then falls into the resolution change branch, which calls
update_capture_data_from_header(). That function re-derives info via
info_from_header(), assigns it to q_dst->info and dereferences it as
q_dst->info->sizeimage_mult, with no NULL check of its own.
is_header_valid() does check that same info_from_header() result --
if (!info) return false which is precisely the false verdict
job_ready() discarded above. info_from_header() returns NULL whenever the
header flags resolve to no supported pixel format.

Drop the comp_has_frame conjunct so an invalid header always bails out.
The resolution change path is unaffected, as it is entered with a valid
header. Oversized frames are then rejected by device_process(), which
already returns -EINVAL when comp_frame_size exceeds comp_max_size.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 66d7b626b04de..fb825b96c7337 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -650,7 +650,7 @@ static int job_ready(void *priv)
 	 * if the header is invalid the device_run will just drop the frame
 	 * with an error
 	 */
-	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+	if (!is_header_valid(&ctx->state.header))
 		return 1;
 	flags = ntohl(ctx->state.header.flags);
 	hdr_width_div = (flags & V4L2_FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
-- 
2.53.0



