Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3739E2AE9A;
	Mon,  2 Jun 2025 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875193; cv=none; b=HbjCM1PjjNnfUZc1Y4wx2GExjI3lsMZ+sOQMf8ZaoXABwlaFLcIjROwgbsVSdCSbUCBLQJO95mRswFWK3+bx1rPKqzHBwNQGz3fy4ustXEPgroWyD5lkfFRg9OXqMA4cYB0xMYfQdb7gs2IgFxds/+w29gmnd/rBbgpVPqXisXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875193; c=relaxed/simple;
	bh=wnkJi5WXucgkmFPxg8jnIRHKjoLI95DoefCdDUoRsmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMiTVY+hRDzSmygfn9tuI1ZeLlGC5V1csNr/NvaKfZC401hIce4Fvr0iKL2Xp+U8sjiqh4oMrBfwIrr3XxNQGToANk2cvN6FY1FrE3gnDqXdIscrAyowl6Qubce0EDqV66r9ZY0oO5wwqWvilMKTON7y7gOp3pMlDrB9gK7PLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VruEDQFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VruEDQFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3A5C4CEEB;
	Mon,  2 Jun 2025 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875193;
	bh=wnkJi5WXucgkmFPxg8jnIRHKjoLI95DoefCdDUoRsmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VruEDQFnKrhMJP70808mm+rid0HcE0jjqdV5tBrgZb854leCIRDOuqmvizrLxc5Wg
	 2aWLCd7WBdEpzy483optHpH9C5u4J7Mf5NWiNCwpx0pW+NP1nISiRYsgnJK+RK1jut
	 Q0xwYkYAY6PcThIH8AP8t+u4bHHzU4ff8duQYUuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>
Subject: [PATCH 5.10 030/270] of: module: add buffer overflow check in of_modalias()
Date: Mon,  2 Jun 2025 15:45:15 +0200
Message-ID: <20250602134308.431943747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -231,14 +231,15 @@ static ssize_t of_device_get_modalias(st
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


