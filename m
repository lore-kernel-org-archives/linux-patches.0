Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02037321F3F;
	Mon, 18 Aug 2025 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522993; cv=none; b=J/fTdLfiMub8n2OqCaSvOk4BffAl0/x4D0wSC8r7oAv4CuEQADjGwjItCyCYiRcevweEr0JjijfjSyN6NA+oR2wlPBCsn/nyRHX4Rois4misvrFdi2OGvUTbd33U5c7/tKFwxoSVTYDV2FNVvnHw5i7TGyDhuefzMiU88N0MzBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522993; c=relaxed/simple;
	bh=0wn2anTpkTTcfdEcN7WprMVZ7N9Vb3nng8snt5Y4w9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTLe878nxZ+/hL54sCqvcaf7u/4E5lKTiF1DtNRgLAawvlb8XtRrP1xDYvzgIV/LhpiVUEjLRX7/b9FBxd1TFjty924ihVNJYZ919qO8KlJBpLZDK/2Smbs1r+4Nyr8P3f8+eLC/KZfzWSkVbE5WEI6NaJBNFrW7o8uD5QZ4+C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Epaip/Qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Epaip/Qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE9CC4CEEB;
	Mon, 18 Aug 2025 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522992;
	bh=0wn2anTpkTTcfdEcN7WprMVZ7N9Vb3nng8snt5Y4w9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Epaip/QymuyDNzk2sX17ndkG/mjFfHljQlwzcWR29X2p17tb7F2OvBmvIMN4TARnQ
	 2IiQ5kgAtCfuVkWdyPgzgrDofxCEdQWF/AA2yH0hTt3OvNMcc2t/5/zWOFNvFw27PO
	 0it8WJ1CsF6E1jKTelkZVXfakc220KufvJuAmWeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 037/515] LoongArch: Avoid in-place string operation on FDT content
Date: Mon, 18 Aug 2025 14:40:23 +0200
Message-ID: <20250818124459.869846713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


