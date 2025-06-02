Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF8222582;
	Mon,  2 Jun 2025 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874428; cv=none; b=sKZ3Oe4fxzLogBePrDCVQQyEBjGF2oN+9QAdc/AFkVkbqyvVDTRD3Xc9C0XCG5/9+ao6XFOKGBRUJun/myH5w51zYPSBPy2WA84m+c+kMWkjT3NFtyieAGvPEZ+80fP65euriiG9LTmrAemGaLLl9CNL9XOuTfSRsGvo+PKSo5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874428; c=relaxed/simple;
	bh=ZUfO1lt/1yA9ml/J/wweffJJggpKLZTk94NKrj7eAZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6jXp0UJ4NalImmi61OT5EacRv5JRHfJypih+tgJD+TA0T1siiePRYTOvZfLIBKbIMQQXj7c90ZptdWynXFXFPGj++sMVb1mOsTRCcSANkctShCPKjGIsiTXlpMw+zqSsCUiy2zSGiXAP8UXKqa5I4+YJt13lhvAKUFa4R+RWgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgIQzU0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgIQzU0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B82AC4CEEB;
	Mon,  2 Jun 2025 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874428;
	bh=ZUfO1lt/1yA9ml/J/wweffJJggpKLZTk94NKrj7eAZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgIQzU0Y7NlPOo/nYcuKzgbKAilXecnPIDMNgQ1ED0arQfE2ukIlinTqI+TEwSImc
	 S3o4LikDFrA+mRGbP1ynXYmxC0hK3yma2QLngvwRMkqdYwP1CbnFs2BYZV3ZrqqL8g
	 8a7nCsfdwxOzXOzUQjfIPXFo3Sxj9jhaFmjT+170=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>
Subject: [PATCH 5.4 021/204] of: module: add buffer overflow check in of_modalias()
Date: Mon,  2 Jun 2025 15:45:54 +0200
Message-ID: <20250602134256.517997615@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.

In of_modalias(), if the buffer happens to be too small even for the 1st
snprintf() call, the len parameter will become negative and str parameter
(if not NULL initially) will point beyond the buffer's end. Add the buffer
overflow check after the 1st snprintf() call and fix such check after the
strlen() call (accounting for the terminating NUL char).

Fixes: bc575064d688 ("of/device: use of_property_for_each_string to parse compatible strings")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bbfc6be0-c687-62b6-d015-5141b93f313e@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: "Uwe Kleine-König" <ukleinek@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/device.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -213,14 +213,15 @@ static ssize_t of_device_get_modalias(st
 	csize = snprintf(str, len, "of:N%pOFn%c%s", dev->of_node, 'T',
 			 of_node_get_device_type(dev->of_node));
 	tsize = csize;
+	if (csize >= len)
+		csize = len > 0 ? len - 1 : 0;
 	len -= csize;
-	if (str)
-		str += csize;
+	str += csize;
 
 	of_property_for_each_string(dev->of_node, "compatible", p, compat) {
 		csize = strlen(compat) + 1;
 		tsize += csize;
-		if (csize > len)
+		if (csize >= len)
 			continue;
 
 		csize = snprintf(str, len, "C%s", compat);


