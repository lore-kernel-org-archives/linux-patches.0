Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6F023D298;
	Wed, 23 Apr 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421875; cv=none; b=nmJWauuKnkxFlajbdPzdKGcqBd7asuQd1nyiyy8SKyKd1g3qlkxIZIMLtjrqsaV6co55xmowoGPFnVhmKqa3wnGBGGE3Uj2WcvAKqFQww7yB36WfcFPijdevyjkDUKXt2RYXQsI8adqIc1i8P67To3Lph8iqvVIe4UjHGsFy4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421875; c=relaxed/simple;
	bh=8oWu/Q2TTdjlM5t+pQROAq+nF/eQGvwoRx2cuAT/dZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrKeUPQ04m6f7wIr4icM3XgaFK3q/oKgMrm36VXhnZs1r0CoYGh6Ye+5t9e/WOOMzBMJb2VVVanPOKVuccU1fqvqAeOs3BJLWNzEAb7CK8fULjSHnzXsCKpLzZ3C1w9Au84QrFwEomwJLfAyISv9Kl5dR/7/ktTnZP4j6dWlhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC4emoRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC4emoRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE9C4CEE2;
	Wed, 23 Apr 2025 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421873;
	bh=8oWu/Q2TTdjlM5t+pQROAq+nF/eQGvwoRx2cuAT/dZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lC4emoRk6Tb1aAjlDYvVgGkTi99X6IuM6Qw4vmZ7vZqr7wMJwma7mFKMXe0PCeg2R
	 gZQUiY6o/NJsSNC0c37Dhy3Nacwd2Sx/hybqdo08RcUYp6DOTLmoKcccuBbXig+nsG
	 neGtQ0bq303U8ajWfhC7Ja66UnZ2RI3dEUTSGOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 237/393] media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline
Date: Wed, 23 Apr 2025 16:42:13 +0200
Message-ID: <20250423142653.176692753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp9_req_lat_if.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp9_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_vp9_req_lat_if.c
@@ -1189,7 +1189,8 @@ err:
 	return ret;
 }
 
-static
+/* clang stack usage explodes if this is inlined */
+static noinline_for_stack
 void vdec_vp9_slice_map_counts_eob_coef(unsigned int i, unsigned int j, unsigned int k,
 					struct vdec_vp9_slice_frame_counts *counts,
 					struct v4l2_vp9_frame_symbol_counts *counts_helper)


