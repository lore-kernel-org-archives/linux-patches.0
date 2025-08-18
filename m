Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B2D320CAB;
	Mon, 18 Aug 2025 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524711; cv=none; b=Iv2Ym03wo9wk38VyDqNV3ClaunwmraIebIYnBJIqeUVv8nRGHliimQEgMFUP/RehAfJGr5XhN9ZHssR8OrGYT79DGCFvXr4rEaUce6BjXXyv+Ig5X4NZuvuMnMO/C6SJVl8D3c5vOQBXIgifB5Gpc/hA/+RTdaiKdUWwdjOdqAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524711; c=relaxed/simple;
	bh=G2MOdnjGy2NvXrAb7I8w4aRCY/2YkZOtZorVh/ad39c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfQRRpVoQAQ1v/vYPlCiGBdSN059QJJ4mWPau0WcOv3gfmarCVbwhIohhS9e+FG4nmfWI4RD2ztJj0SShaPkwxkTMlZ5XKKf9Bqs/MbimC3GTfO3MCPeSM6Pjvz9ZDsQEdLY/qeIf8ajuvXIqhOwUK0kXngaYy4zzVjFSdyIJVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWGqfHDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWGqfHDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DD4C4CEF1;
	Mon, 18 Aug 2025 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524711;
	bh=G2MOdnjGy2NvXrAb7I8w4aRCY/2YkZOtZorVh/ad39c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWGqfHDwVc471aqv2sn/vVEav9o8w/F43pEIexLBFv+fZOjsVIsFC5wTzdRQrGjgQ
	 gnu9QIblfANHf2xICl7qcOeUk4r38c528cUdw5CZE84QJNTt/DpoHgsxIx6SBouXRD
	 4Ke0Y3f3tZ5R4PRSVnjV+H1LGoBXD8ewUZgIYSuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 039/570] LoongArch: Avoid in-place string operation on FDT content
Date: Mon, 18 Aug 2025 14:40:26 +0200
Message-ID: <20250818124507.322763344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

commit 70a2365e18affc5ebdaab1ca6a0b3c4f3aac2ee8 upstream.

In init_cpu_fullname(), a constant pointer to "model" property is
retrieved. It's later modified by the strsep() function, which is
illegal and corrupts kernel's FDT copy. This is shown by dmesg,

	OF: fdt: not creating '/sys/firmware/fdt': CRC check failed

Create a mutable copy of the model property and do in-place operations
on the mutable copy instead. loongson_sysconf.cpuname lives across the
kernel lifetime, thus manually releasing isn't necessary.

Also move the of_node_put() call for the root node after the usage of
its property, since of_node_put() decreases the reference counter thus
usage after the call is unsafe.

Cc: stable@vger.kernel.org
Fixes: 44a01f1f726a ("LoongArch: Parsing CPU-related information from DTS")
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/env.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/loongarch/kernel/env.c
+++ b/arch/loongarch/kernel/env.c
@@ -39,16 +39,19 @@ void __init init_environ(void)
 
 static int __init init_cpu_fullname(void)
 {
-	struct device_node *root;
 	int cpu, ret;
-	char *model;
+	char *cpuname;
+	const char *model;
+	struct device_node *root;
 
 	/* Parsing cpuname from DTS model property */
 	root = of_find_node_by_path("/");
-	ret = of_property_read_string(root, "model", (const char **)&model);
+	ret = of_property_read_string(root, "model", &model);
+	if (ret == 0) {
+		cpuname = kstrdup(model, GFP_KERNEL);
+		loongson_sysconf.cpuname = strsep(&cpuname, " ");
+	}
 	of_node_put(root);
-	if (ret == 0)
-		loongson_sysconf.cpuname = strsep(&model, " ");
 
 	if (loongson_sysconf.cpuname && !strncmp(loongson_sysconf.cpuname, "Loongson", 8)) {
 		for (cpu = 0; cpu < NR_CPUS; cpu++)


