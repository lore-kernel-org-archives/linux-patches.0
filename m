Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AEE15FCF0;
	Mon, 27 May 2024 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838621; cv=none; b=Mp0t5udN2fX139qSWQSS4HcD2ZkgbadIpewPWBM7/XfJDE/QYMWiyGz6gEy16Cl7Tlgw8f7dme72YeaUs2kNVvpJ2EjKWhfkT8iKBcDYtgN5EOooYxchBjXWVnoeO3qSNJ2aXD3UJcStexPt0Uw5nSOnN5D7+RwswzKdibb9a7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838621; c=relaxed/simple;
	bh=mEVlfY8O2IWnNY2CfFe2oV/fz6APiFpF38z0JY/lbS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJnueaM2irnGqu6yqIaKrqSAEF0Q9lUOysViwsai/fxK3J2YceyojwzAPq+PoCJyx10cdagk8GvbFf1GQuN6Nkp9gBUVDthi2+Grnt+303tjepjb/4Gc148Qc9G+gFk122i+j0piL4NMEAoo7SY+wd/T5hdJBOzhrnRSdbU/juw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIikzk3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIikzk3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A76AC2BBFC;
	Mon, 27 May 2024 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838620;
	bh=mEVlfY8O2IWnNY2CfFe2oV/fz6APiFpF38z0JY/lbS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIikzk3WVvA8cNBqzUV6622wfYeI6k+9GT45wGsWe5RsgPLOn4zuMH2SMG6PJylUt
	 pzuS5vRSEzym/ESXhLrlFK2d8hKVXqRk+7GaXznyUGmXJzd8Ytbz/XjaMQkbon0dqz
	 6ZnTOEY8wT6p82qNC6GHmtyftSAy8DqlFdiqAuGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 463/493] of: module: add buffer overflow check in of_modalias()
Date: Mon, 27 May 2024 20:57:45 +0200
Message-ID: <20240527185645.338475546@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



