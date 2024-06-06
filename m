Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99D41B4C59;
	Thu,  6 Jun 2024 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683452; cv=none; b=EtqWdLM/7R2OZQO29YrsxjXNrrqI0DUSLtbblXmu7kekHtHbmzEiIzBOajVfZ9EE/pLyg/K4dJT/0njHRsYFct//lSyu3oHntjEVPUa4t9scS+9gGRVonr2aRnD4Dyy+wzPFmc4OV0mCZWu4lfBwImkxlW1sQSfVmkLigDPR2/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683452; c=relaxed/simple;
	bh=67LUeZhlmuRyEvzNGdQuuCXTdU1zktqynvBof4PQ7sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGwf+tCXVe+tKNUH7HLJ98qVZiuGrXSens5SN4HG7UTStIY6kUwwqT2cA5ayBWxajS/srhBLHzERa80EAhJIpnxZOTCw+sdncLpkLbKo8Qs+4VE1GdUdvVH4JdPXZANIhmL3jxd4iQwCBcqb73UX8N8LcM9SA7c0q4d8hsZmZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc+A4TjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc+A4TjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6701C32782;
	Thu,  6 Jun 2024 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683452;
	bh=67LUeZhlmuRyEvzNGdQuuCXTdU1zktqynvBof4PQ7sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc+A4TjNZiC0Hvh3mustekmvnAoGE9y7CR7Ip0GEW6GVyamN0RbGcOxLRNquesuye
	 xsEpgdsffrDot04XhOR/8jtUmMxh0LHt62p5XEU6ZVzYPGGeD5Jzw95fPVTtBco51z
	 X/koCRR1CuMp7dMzF7cLyX1bGgW4YA8aFoFux0lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/744] of: module: add buffer overflow check in of_modalias()
Date: Thu,  6 Jun 2024 16:00:39 +0200
Message-ID: <20240606131744.256311060@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



