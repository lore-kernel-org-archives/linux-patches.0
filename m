Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57E26A08C;
	Wed, 23 Apr 2025 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422228; cv=none; b=pRlqXyT4GTgo4m52Z1/unQmo05WlOFUjRpKDvA+G3dqjYvgV9Vyhw7EG/e/SB5c5PSvvuNShkd48kbcRy/Ff9HO8kACfJwXWdS2/y2h0IAAyCeLBDD5g5KwIlhUGtrD7s7RzN+kkUUSXfJGNV3lKplRGl2+S0SIExggLGdt5rQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422228; c=relaxed/simple;
	bh=FfJFaiVEPJ/dzHZTHwATBslQEYpvrYj+Sd9NBzU2sy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRTgAvQGO43N1csH4WTe6M6cYQ/s9wJqXZAh0/SYKc3k7NGT97WuC+5oNNX6DGadCRCeqJjhuxjeLwIc1DBakkLbtCdWlX8f3lFciK8Hck3QKFdlCn1U4I0tV69gtFnTcJ2RqEtKJTBl05ZoBGaTEb/K60yxiZfJivjhV4KgVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ06pl6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ06pl6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DE8C4CEE2;
	Wed, 23 Apr 2025 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422228;
	bh=FfJFaiVEPJ/dzHZTHwATBslQEYpvrYj+Sd9NBzU2sy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ06pl6vF/btfqZs4z8JkQdX6DFW4+M1yrLE5aWyCLyxGvIzeov5shRJYNehcewOc
	 3SaGwAvbQJkT/cevL+d1FnJzPAlINOfjb+a46cHw29EOMRntFj7mU/yvO473/gLiJ1
	 vQN5rkoIUEnbnyXtC5vtS7OmMga/n7XtmU8JTtxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 259/291] media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline
Date: Wed, 23 Apr 2025 16:44:08 +0200
Message-ID: <20250423142635.012030134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 8b55f8818900c99dd4f55a59a103f5b29e41eb2c upstream.

With KASAN enabled, clang fails to optimize the inline version of
vdec_vp9_slice_map_counts_eob_coef() properly, leading to kilobytes
of temporary values spilled to the stack:

drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp9_req_lat_if.c:1526:12: error: stack frame size (2160) exceeds limit (2048) in 'vdec_vp9_slice_update_prob' [-Werror,-Wframe-larger-than]

This seems to affect all versions of clang including the latest (clang-20),
but the degree of stack overhead is different per release.

Marking the function as noinline_for_stack is harmless here and avoids
the problem completely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
[nathan: Handle file location change in older trees]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c
@@ -1192,7 +1192,8 @@ err:
 	return ret;
 }
 
-static
+/* clang stack usage explodes if this is inlined */
+static noinline_for_stack
 void vdec_vp9_slice_map_counts_eob_coef(unsigned int i, unsigned int j, unsigned int k,
 					struct vdec_vp9_slice_frame_counts *counts,
 					struct v4l2_vp9_frame_symbol_counts *counts_helper)


