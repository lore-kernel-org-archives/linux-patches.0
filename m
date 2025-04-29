Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D240C03;
	Tue, 29 Apr 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950083; cv=none; b=RLXYWHVm27+S7tuEDt/lNJFnMb3FMRgbmnuXe1I5cXsqAyJzBuJQ8hOfeiolKUVynuXOH9yU7EnoMRRlWf86+65kbTAbZaXkYqyF/lmpTBW5NMJq+6Zhi14AdMxTgjxWZ4wmDYIQ5T4bVmVwBdWPpjkVNVU2randBOm4uf6E3tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950083; c=relaxed/simple;
	bh=7pznRt0JHMSGdYLEhmH5u0Hrv7C5aUvpynF9DA7VqCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUV612jzMjVTPD8Shjw2DnNuSJsiZMGDmFuFG2xQHAC4kw6xQ8YNoO3MF9VQNgYrSkY3chRph705cR2yEkNGpeqt+Y0JpYXeWEU0k9wjiTr7WL88+BR66eRfbSxYprBFuVDREKp+EHyrkN1H9Ap0rq8shrkrVmS53EpTznUR+cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQqTTS/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQqTTS/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFF6C4CEE3;
	Tue, 29 Apr 2025 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950082;
	bh=7pznRt0JHMSGdYLEhmH5u0Hrv7C5aUvpynF9DA7VqCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQqTTS/r5gZSzDQz3nfwp/Q7X6RNF2/VFObTcHvCM4Hwfhi4LDBGrH3bkI/3sV/7c
	 9mqZGwZaVNl0P+cEDqXsG6Bw4RooJrb2nW+bz3vcUFGT6vk0kUp4IAF0u4D48GPmBC
	 GJxox3OslmepByjCZnH87KUVMQlH+/CCPuJGosV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=83=C2=B6nig?= <ukleinek@debian.org>
Subject: [PATCH 6.1 150/167] of: module: add buffer overflow check in of_modalias()
Date: Tue, 29 Apr 2025 18:44:18 +0200
Message-ID: <20250429161057.791863253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Uwe Kleine-KÃ¶nig <ukleinek@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/device.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -264,14 +264,15 @@ static ssize_t of_device_get_modalias(st
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


