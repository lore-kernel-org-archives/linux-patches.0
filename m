Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438E2A8D0;
	Mon, 24 Feb 2025 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408661; cv=none; b=Tw25FS1V2WXXSfusKCqONj8b5nGLSraPxOo1PF64npcjlJeZPQHBzuqtg07R93heGxgDA8ZXLBTYamE068Ti9qSA0dirZbX2d9eoMQKBnkmWSpu4RRg0LT3Sp1KkEaAyVMxygmQOr3mTVtNlxngR9d0PPYqeaEYCaIyhDg8P68U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408661; c=relaxed/simple;
	bh=9ppfZqZZeElNnyKuY49igRAizNCEOycAcMfftsCmFkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLyKZgnx8qVcVufp9UgdZeyaP/phYafmM2ywi2Qk6Y3FoY/OFu5dxrDhnZZhd0T0HLRJxkv6BXy3KonNJPdV2IGcLmBUyrjM93GCQ5z9l8zQ/r8fHOTaVAwFXQljH4X1At6WiFib+lVSvaeBYjHqTF/o+2XQJ41CsyhsDmX5thc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqA4z2Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqA4z2Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2218C4CED6;
	Mon, 24 Feb 2025 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408661;
	bh=9ppfZqZZeElNnyKuY49igRAizNCEOycAcMfftsCmFkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqA4z2WzYvmsc25zbgE6UEl9I54NuJTRrVwuaM35u0XMHyT9C1P69NV8He/7jNWqW
	 OTN/ScAlpfodwmL2lCTgMpLVigzMnNsFmIJZwLfWr/lhi4aJMekQVGpTZuAmHz8Han
	 bcnYMCCHIyOu7VrDruCTVAJIbd1P1dg9PyD5HaVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 122/154] soc: loongson: loongson2_guts: Add check for devm_kstrdup()
Date: Mon, 24 Feb 2025 15:35:21 +0100
Message-ID: <20250224142611.831540620@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e31e3f6c0ce473f7ce1e70d54ac8e3ed190509f8 upstream.

Add check for the return value of devm_kstrdup() in
loongson2_guts_probe() to catch potential exception.

Fixes: b82621ac8450 ("soc: loongson: add GUTS driver for loongson-2 platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://lore.kernel.org/r/20250220081714.2676828-1-haoxiang_li2024@163.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/loongson/loongson2_guts.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/soc/loongson/loongson2_guts.c
+++ b/drivers/soc/loongson/loongson2_guts.c
@@ -114,8 +114,11 @@ static int loongson2_guts_probe(struct p
 	if (of_property_read_string(root, "model", &machine))
 		of_property_read_string_index(root, "compatible", 0, &machine);
 	of_node_put(root);
-	if (machine)
+	if (machine) {
 		soc_dev_attr.machine = devm_kstrdup(dev, machine, GFP_KERNEL);
+		if (!soc_dev_attr.machine)
+			return -ENOMEM;
+	}
 
 	svr = loongson2_guts_get_svr();
 	soc_die = loongson2_soc_die_match(svr, loongson2_soc_die);


