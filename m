Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3D52FFFA5;
	Sat, 12 Sep 2026 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220784; cv=none; b=aLGR+6NLOPaxm67ruqvLUt6vYv0m7NiryyKV7lrpo1r5UXdRpl/aPVu3Jj9lfTCYw78xoOaubGMgjebsQGi5KhZshQihJx6s7FcvTpaXLxhGZzfaEztL0fIlOxezG1ElF7yvQLglzowh0SDDaUnHdrajyoasjhCS+XEROFP2JgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220784; c=relaxed/simple;
	bh=WEMsEW95+BQH1/O1ZcIM6qF/gO+0+vx86w9+aFwc6pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1uz84JAIR4SjW9o3xAEMl3NeYbCNcSC5ixy66B/jsswKIWIs5wKPA6PInt1YjQdg4q2byP0tL4Epm3CPoDdi3UJ1tulNAHNuXWgaf7RNsTMh9C7Eb3yQ7CethIFxDeQWLrQtV7gOue6VZ31VOlifQjKfb86O5By1pzkmP5/wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItDzTuXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItDzTuXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA2E1F000FF;
	Sat, 12 Sep 2026 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220782;
	bh=1vpl8XQ9GcNAuNRdcv1O7QCLw0/UJhonjM1MppzXDhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItDzTuXQQhF5J9snfTtjum6O07SlLtmADBhV1iYxc4GfY6FfMcKGd4SosUtAC7Q1o
	 q1ZdwFfX4e14cuSJFQIRHeqa6yKEsjBsWPYpeao4wPL41pPzQr4Q4lG6G/oEvmP5UN
	 g/6h0jwzxThIOkAZ3/c9KjzhAaR8tl5CiEZRE84E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0246/1424] platform/x86: hp-bioscfg: fix off-by-one write in hp_get_string_from_buffer()
Date: Sat, 12 Sep 2026 08:44:38 +0200
Message-ID: <20260912065612.790156773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


