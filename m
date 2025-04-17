Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653B91A9B5D;
	Thu, 17 Apr 2025 18:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916243; cv=none; b=EQlRPzUqk4lul4cAwdCSXLxldXwjClWViLzi9Osg8m3UUhr9Vs7g0eNl4bGfEqYfuiEhn+X1glTNCQEyj1D8upl8JK1Xozp/NsqXhw4Zdhg09dW6m33flTvZ6w0Qzmbka3Azq4j9sKO6H2TzeJid914P9Xz/W+ITQVVOVrg18Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916243; c=relaxed/simple;
	bh=RxyE4ugAvVChzgzXJ1hvYr3WBbbMsLUdHNgE2r+eWjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9S608o0565oBM9+iSPE1d1HJdPKJHBZMPSzJ5RN39CGgS8UfNB9dLPD4QZ9jsno7H/nW/jEQDSPLuN6QIyA4WkkpnrlUbhWviFczzlJRbEh/N3n3qy98c6p75CE77Tkmq9nzR90MB7YEfGzvBpPfUNBP8Eds2HSNN5yiiGW2ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxXl4w83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxXl4w83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7E7C4CEE4;
	Thu, 17 Apr 2025 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916243;
	bh=RxyE4ugAvVChzgzXJ1hvYr3WBbbMsLUdHNgE2r+eWjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxXl4w83GyQbYlMkH6Nc1JAkwQIMzkehk5jpQRpeqpEEZ6GtCG8Bp+4iO+/kgSLs/
	 YbHoTnEW6IZRVLHOvAcaWHSuEbk+ehdINHKE4s87DJxGmLRtsQ+kkRuTinNiOZQ0fs
	 o4hmaYDmGVFRMgM1ZMwx7c1NrH0GxFeYE+/ySiQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 391/393] media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline
Date: Thu, 17 Apr 2025 19:53:20 +0200
Message-ID: <20250417175123.329316460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
@@ -1188,7 +1188,8 @@ err:
 	return ret;
 }
 
-static
+/* clang stack usage explodes if this is inlined */
+static noinline_for_stack
 void vdec_vp9_slice_map_counts_eob_coef(unsigned int i, unsigned int j, unsigned int k,
 					struct vdec_vp9_slice_frame_counts *counts,
 					struct v4l2_vp9_frame_symbol_counts *counts_helper)


