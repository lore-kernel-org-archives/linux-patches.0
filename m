Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6893F8E04;
	Tue, 31 Mar 2026 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975460; cv=none; b=CZpuK9ouXKy7PQiaaeoaqFDygsw2A+VXm42ZhDVsYf/9hsjKImEKCeBSnnx3YcOeLajYEnTI9+cjzEM9aIKjZRGEQcCMObU3JTO/dUijSfxQzBWX9rbw+XDBPEucQWA6x+k0nU7YxBoRab/XI1Z/8Dh1BGq0uwOwJ0Eq1nmK/Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975460; c=relaxed/simple;
	bh=dV2kRh1P7ZpjP50Z9K1a3P9anP4sRLs+b+M6QVOJq50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTVIewPg7/Pr7yqK11hShknN15lTFQ3EZMJMO40uI/b1KRieMfDJ0OmdTpKgQma0vIt+sTsa4bMknMLVBfgZzJlYVBxs/bTRNiXIC3H9TvMqr2f7DsoLah04IdSqSQHgzyaUfhOEvfrEmEYfAB+ODIIppamJJDvVKArkDpRwAxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aS7Lsxp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aS7Lsxp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5D1C19423;
	Tue, 31 Mar 2026 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975459;
	bh=dV2kRh1P7ZpjP50Z9K1a3P9anP4sRLs+b+M6QVOJq50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS7Lsxp7FODyqLbiAh+Y6gdclOqC7z/vqKF8Z/h3MwuisEkm2FJ5qNj9k/CT41/s1
	 8hw2jGg2SCXVl0vECkyHdV2wCCoqfBbjxNld6VEyTTXyyU4FayVM/HChRG11t917BB
	 P2tQQYd+l5373TUHurF0Ae08QhI02wdzRVbfdUGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.19 270/342] LoongArch: Fix missing NULL checks for kstrdup()
Date: Tue, 31 Mar 2026 18:21:43 +0200
Message-ID: <20260331161808.881687523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

commit 3a28daa9b7d7c2ddf2c722e9e95d7e0928bf0cd1 upstream.

1. Replace "of_find_node_by_path("/")" with "of_root" to avoid multiple
calls to "of_node_put()".

2. Fix a potential kernel oops during early boot when memory allocation
fails while parsing CPU model from device tree.

Cc: stable@vger.kernel.org
Signed-off-by: Li Jun <lijun01@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/env.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kernel/env.c
+++ b/arch/loongarch/kernel/env.c
@@ -42,16 +42,15 @@ static int __init init_cpu_fullname(void
 	int cpu, ret;
 	char *cpuname;
 	const char *model;
-	struct device_node *root;
 
 	/* Parsing cpuname from DTS model property */
-	root = of_find_node_by_path("/");
-	ret = of_property_read_string(root, "model", &model);
+	ret = of_property_read_string(of_root, "model", &model);
 	if (ret == 0) {
 		cpuname = kstrdup(model, GFP_KERNEL);
+		if (!cpuname)
+			return -ENOMEM;
 		loongson_sysconf.cpuname = strsep(&cpuname, " ");
 	}
-	of_node_put(root);
 
 	if (loongson_sysconf.cpuname && !strncmp(loongson_sysconf.cpuname, "Loongson", 8)) {
 		for (cpu = 0; cpu < NR_CPUS; cpu++)


