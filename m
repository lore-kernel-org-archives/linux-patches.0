Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975BE3B95FA;
	Fri,  4 Sep 2026 05:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499911; cv=none; b=EHN6XyeQ8VGwzpnM5x4zwhbNem1beNPYMUaeLhXgGpJfSOURgaI6tWJcPILxu5fNfqxCgq0z8fiGKsCqEpQ5CM7ddGGRX1k4x717BGIIK0M3as+E4ghHLHVqVMR50K1ombtOJ/numlP5BrW5U03g5zOp2b5XdYKfbKFtMfZfMo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499911; c=relaxed/simple;
	bh=HQFs2R/12DFXIpIql+slG0REgSRJV8Bs2Oo9s4hwGeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzYchwdRrfOgs/CX/XTUZk7haOkjyWmIDths3AD6WNVeqXkLqIfy/Q5+79Yyp6b4ix3b8/4j1qif1MhUt/naxIraACBsbt8d+rWqs4+dbjkSIqreC5M6Y2/FdhAbBHqtPnR6V0U6/g1Uj3hSLv/fzj3DTKEf1JdaBRiMTv1Ott8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+ConmtL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+ConmtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F037C1F00A3D;
	Fri,  4 Sep 2026 05:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499910;
	bh=AtXi16RkcGqUUeYHtaAL56o9XSkRtbYfOFCeTtA+Fck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+ConmtLkYnYDSbTomzyqV4k+ywQklRXZ8qI+G5i8Z0R/ypmm4wHGyW8sDPtw3gw7
	 BMQ04vfTdGKz5M+MJkrhK7bIvdVjUEoM9uiN5C+vauccjL3u1Vsqhy6WIQre6xhTfe
	 Y2TVxznanggBCIwOOcl0A9oaw8S0+loyf4atH7Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 582/713] platform/x86: hp-bioscfg: fix off-by-one write in hp_get_string_from_buffer()
Date: Fri,  4 Sep 2026 06:59:10 +0200
Message-ID: <20260904045816.864134123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit dc03f05e419f3460342fb7564884f244622634b6 upstream.

hp_get_string_from_buffer() clamps the converted string length against
the destination buffer size with "size > dst_size", so when the
converted length is exactly equal to dst_size, conv_dst_size is left
at dst_size and the unconditional NUL terminator write

	dst[conv_dst_size] = 0;

lands one byte past the destination buffer. This is the same shape of
bug as the previously fixed off-by-one in hp_convert_hexstr_to_str():
the buffer is sized correctly for the content, but the terminator
write is never checked against that size.

Fix by changing the comparison to ">=" so conv_dst_size is always left
with room for the terminator.

All fixed-size destinations that reach this function (path[512],
current_value[512], current_password/current_value[64], and the
per-entry buffers in encodings[][512] and prerequisites[][512]) are
affected.

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-2-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -85,7 +85,7 @@ int hp_get_string_from_buffer(u8 **buffe
 	 * bytes.
 	 */
 	conv_dst_size = size;
-	if (size > dst_size)
+	if (size >= dst_size)
 		conv_dst_size = dst_size - 1;
 
 	/*


