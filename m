Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2E31DE4C4;
	Wed,  7 May 2025 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643386; cv=none; b=ThqfF6YHVmvs0v8l1naGdXit9gVbGi9ry/qR09NIL37K1ypcvYKOq+R0ONc9auefjSnXOVdtbEbXH8v8By8PaJmhIIg3Yg7uJoNaL/686sq1zXfWsGMvIpqE+a9RpgYbcX0hJkBSMygIG9f1C4hinifdDcNBX9NMuCfueBRbh1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643386; c=relaxed/simple;
	bh=5CtE4j7ysZ/9EBijD7b8AinJVyxNEMgINd1CEF0i3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1CUGEKRm5DztpCcHZOuRWtUzxBJXhQ3YbfyDP4yb1oBM3kJYwWJobOefzyU7IQ5jqjdkP3rMH7UlanZ9RDu2hNWmF3CXJeVONzPdZDZU3JPVo0Z+IzSoKM+tJ0VAjM1t614fSkdFzevPoma59PhkfkUmnQzSEItcOUYoKfm2KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg1hx1Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg1hx1Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B655C4CEE2;
	Wed,  7 May 2025 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643386;
	bh=5CtE4j7ysZ/9EBijD7b8AinJVyxNEMgINd1CEF0i3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg1hx1UbBs1tapusIdmv1bbm6NC9YKziiivb6lXHDJdgiS+LdJ4XiXK+3eXfcRDxX
	 ZWZUELdbpijRYlrOs0yttUJqP9+16ynjCuDmB0TnyT6rBC/z+tIvVtokcHjkacQSyd
	 ru4BNcH6Ufgnox8q2n4ig40EN+zxU3nmonN25qnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@debian.org>
Subject: [PATCH 5.15 43/55] of: module: add buffer overflow check in of_modalias()
Date: Wed,  7 May 2025 20:39:44 +0200
Message-ID: <20250507183800.776103612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,14 +257,15 @@ static ssize_t of_device_get_modalias(st
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


