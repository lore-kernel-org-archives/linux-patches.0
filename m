Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3A37C106;
	Fri,  4 Sep 2026 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501545; cv=none; b=ScsCmOGVLgrPHZK/q9gE712qXTNvz/Q7KBvnTR3asADE0eKjfWbk+dKHor0HQiS2iY+u6BW3VTV1Rc61/2PlwNww7pHpuGQPqfUoAJpgWxG+l4vNXoEHZZeI6tKra/ZSi8cr6yLA9HFaago+cb3XurDPrDST6/0wdanTNnWQCNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501545; c=relaxed/simple;
	bh=KGGdo43FIiBO7tuC7ZiS8m346JqSNeRzzF+4UxpMhro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4ozkXt2oVbZO3YXqeMY2hVA10fX96ZiKaw1m5m26H3P+0LdRe4duzHL6SRctiv0Y2iKBzuiD9FXtVcgO1wrqSzIH4rPqyMff0+POdlBZCQ2udX4G/6PTXStb87OGSyRDy0GBfBlfiKFoGQqtZi37JOuNebakfgSBQJpEiKRjGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9LQkIA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9LQkIA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EE01F00A3D;
	Fri,  4 Sep 2026 05:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501543;
	bh=VOr8ruSQslINJLuV9tTGDNxdEwNchD17yCXhOI4tTSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9LQkIA58LeQ6iE6IUDsnFQ09X9Pikjcyjuqy3RJZhGKbhBAx989kDtalhumLsEDS
	 IbGEp71jfHh4NhhBwqwb13Yw64fe0sgyiuPPFZDufvKfniTq2KBbRYg/ta9XgwX+Yl
	 /VE4TSpDCapwB7kY1JyXooP1lXWEj2Cs2+CSiwDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 440/552] platform/x86: hp-bioscfg: fix off-by-one write in hp_get_string_from_buffer()
Date: Fri,  4 Sep 2026 06:59:57 +0200
Message-ID: <20260904045800.566110015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


