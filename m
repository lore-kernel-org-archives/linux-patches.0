Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063174;
	b=MdpjXJFaDNkllYTDkGWVkOGxVvFja4KiRDTNHzs3If+hkT0eJ7wfhqVL0tErY2E4vy3Z
	 cn9SDjEWDy6pwcwWM9yyujY9oDKnsJLa1SqLVol7bEjqsN7omqdiyByM1jGFEOWF4sRzl
	 apB5Yp3MFQvH4XmH5KJeLB4U+dgzj1Kr5jH4pNcfAwJ0Tq1KVaO0Gg7j9O7sh2ju+erYp
	 DsOuWI66bW8trOtHm26aNdCjXszgsv2sR4ILx93yESAhuaGGmpZEAzv3B68fJf2Dd9Lxp
	 IUjkUMcJsCHjg0I+WOuLv3BEQCN5F5S5h/VbJJ5EJOa7N0yHsMekOYxBoY1pw+S0zfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=koQq91PkYfAueu0o1qhTlOGMqHCcWPavjzhKHDzREx4=;
	b=FwizEx4JI/F3FyvkJOO+AYs7g1VxEkmZ1iu/QjZJ23Ff59iEAQj2FfH4dg6uVQnz8e54
	 KPrX+AY4Wg+p/2xVpCucOkeBjDk/uZolW1V43JJfTrQ4crT4mHaoI8TdII9i9sy+tACDv
	 wKUrItZFqiufih/RS3e58kVo1ArYcmkdfAFQp8xS28wJi3yci0U1xIykIwA/VgUW81Hxc
	 VlAbcLEq6hndhF/hCNQGOjd0VTKThhzzaUD2ynq89BdJfdSUL9ZpTBDCLWWsHGZTXszBp
	 W3pCX8QHdEkCapDrsAGPnv/Wdt7WIc+6Z6qA8Bu+IQOE6ZSVd20zKUiO93ssbErbygA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kn0fv3MA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A44606A330;
	Sat,  7 Nov 2026 14:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kn0fv3MA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A254D1F0089F;
	Sat,  7 Nov 2026 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063173;
	bh=koQq91PkYfAueu0o1qhTlOGMqHCcWPavjzhKHDzREx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kn0fv3MA0lEjTbQndtPpctEytPTnXYjzZzK/A78iJo3rkonuDZgIo4ExRP2KYyRe5
	 X2YkclmM8uSgIDHhgF+K7M7cQq0FAHtCJKpNINxEIcincMZ3ittBOJ0L7NouEO9Y3z
	 KIeqyry2CsCB7h7LDW3i92uWoKhm7btOAUIA1dO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/869] media: vicodec: fix NULL deref on oversized frame
Date: Sat,  7 Nov 2026 08:50:37 -0500
Message-ID: <20261107134904.414795573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 841dc03d0edd2..3052d248a7286 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -652,7 +652,7 @@ static int job_ready(void *priv)
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



