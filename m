Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE1A16078F;
	Mon, 27 May 2024 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837342; cv=none; b=aTvRZ+UNp+Gkeihce/CYQImYaf8JnDh0ZxDHx8zEMLCo9EMqoZmRJZphkt8Fbmz9d31QVadoGeZyH+NPI9fUHG5CY6VxPZoEBSC8sMvLVG+dnbAbGrT0Er5IE5WVaOU+UOnNH2taPUSfnmyHH1lP7Iq6hEi/DzQ2tI5JOXVuv+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837342; c=relaxed/simple;
	bh=ncDKh8A1Q2AzyvnG/COePAfvY4nCi8/DI2l35LZaIwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiluQhmrsJCRpeCQMlDKhih0vbvIouwQQXk5yWs51uDFtZ+hKX7SjdZR9/CWiv/aHWcFXYHkvLXeJs3G5Dwwk4k6dFFeWFvUF4IvSn2ZdnQri3O9FalHHmlkiNbGRdrwLTcjajwtNTMSs9XdXbNPR4rlX7c0Oeq6igh91YC6Y8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQb09eaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQb09eaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA5AC2BBFC;
	Mon, 27 May 2024 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837342;
	bh=ncDKh8A1Q2AzyvnG/COePAfvY4nCi8/DI2l35LZaIwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQb09eaU3p7NxDPFTMa57Nvuw1H/6LU3ecWak/mnlSe43hu/icpi0HQnely0O1Fnn
	 2xlFvLLPLfA6ONVtV0hgGdCJDz6h4Z/pDj40sfcpI6a1+lYBShGANZdwKkzE/D/Hcl
	 2nTfsDfTrCu3DuxnksYvsZTFMIWe6HX2WtN+E7Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 401/427] of: module: add buffer overflow check in of_modalias()
Date: Mon, 27 May 2024 20:57:28 +0200
Message-ID: <20240527185635.125432736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit cf7385cb26ac4f0ee6c7385960525ad534323252 ]

In of_modalias(), if the buffer happens to be too small even for the 1st
snprintf() call, the len parameter will become negative and str parameter
(if not NULL initially) will point beyond the buffer's end. Add the buffer
overflow check after the 1st snprintf() call and fix such check after the
strlen() call (accounting for the terminating NUL char).

Fixes: bc575064d688 ("of/device: use of_property_for_each_string to parse compatible strings")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/bbfc6be0-c687-62b6-d015-5141b93f313e@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/module.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/of/module.c b/drivers/of/module.c
index f58e624953a20..780fd82a7ecc5 100644
--- a/drivers/of/module.c
+++ b/drivers/of/module.c
@@ -29,14 +29,15 @@ ssize_t of_modalias(const struct device_node *np, char *str, ssize_t len)
 	csize = snprintf(str, len, "of:N%pOFn%c%s", np, 'T',
 			 of_node_get_device_type(np));
 	tsize = csize;
+	if (csize >= len)
+		csize = len > 0 ? len - 1 : 0;
 	len -= csize;
-	if (str)
-		str += csize;
+	str += csize;
 
 	of_property_for_each_string(np, "compatible", p, compat) {
 		csize = strlen(compat) + 1;
 		tsize += csize;
-		if (csize > len)
+		if (csize >= len)
 			continue;
 
 		csize = snprintf(str, len, "C%s", compat);
-- 
2.43.0



