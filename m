Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7CC425CD6;
	Tue, 31 Mar 2026 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976034; cv=none; b=bjHIGt4GPGL0j/gLeUK7fndOHPMfuVTsNzD5hNGegLmxb0JwjHxYJfrnirSkFdKRj8vEzen24H/TYy5LIEbTvzLcvWmzAI3T7pOP1v1gLCjaBq5ylAqtrjy744yWVXguDzXzuU8nyZTnii7T9MLh3SASKJqCdjCk5c9qJ/APHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976034; c=relaxed/simple;
	bh=v7Q0uza27SMw16nOezMxJw1r4NHmhPXM2h1KzozXpzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8PmejpHcaJdJyVYVUn2M8ne5x85xFPPIOuyvtiyOXV4e77ke1eJg/EScLTrSnGZtCMrxurJTBR1PEYcby4LXYtTtkKjnPGRDOQssK72phNovMgcC88Gw1aTuEYjBKixuG59JnYbW0nQmUY9Fhe03kVCydUic3kJW4qYM3PjOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxGd2wEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxGd2wEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A83C19423;
	Tue, 31 Mar 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976034;
	bh=v7Q0uza27SMw16nOezMxJw1r4NHmhPXM2h1KzozXpzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxGd2wEu/E2EreYr4q/t2ubD2DxEUfZS90g6M4I3utE1o28DcvcWdfETnd7YA0MED
	 N4tpdQsjpXEk5yVC9MJLiNj4rP3RVstC8Mi7IUx8NqC0s7r/mSk2FBb9vt63Y2R6sz
	 BoxDoR36zztP5psKTK/nVIVs4bpz+ajFtGv7yLc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 174/244] LoongArch: Fix missing NULL checks for kstrdup()
Date: Tue, 31 Mar 2026 18:22:04 +0200
Message-ID: <20260331161748.184519686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


