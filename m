Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A497F143892;
	Thu, 13 Jun 2024 12:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281098; cv=none; b=pSKgTgjTilD2GhoRjQdhbhizzRny02ouMPEUlMihlaKpS/h6zMD7g5LG93eTLeWjr0km8L5rSbamhpACPTzDrAr6yHljk7rVsZuyYhhOBxfSZyzqXCfGUqGV85Fjlm2Br4Id0CVxFByQ2/9uu53k13u5+IRhSt4K1JKuORJzyJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281098; c=relaxed/simple;
	bh=XMUUCXhHPJvpQY/0nAaMSW9ffPTcCqnNfu5ClF/7cCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PD3o54TwtXSpemrQWU7s0nPpqPO2JmFMMqSbVbF9btASAGRL0qfr2B2ki++thCqoArHK0MYqHwEMj4+ISNUuWc7+QA+0xitlt9OWnaO6lRA+N3tp7D69pHPc+0mWoVgg1vKdtJb/2gRVyc64OoXsUZKfTjyYg1kB2ps8KF2h3hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TtQqoOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TtQqoOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F56C2BBFC;
	Thu, 13 Jun 2024 12:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281098;
	bh=XMUUCXhHPJvpQY/0nAaMSW9ffPTcCqnNfu5ClF/7cCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TtQqoODMqKT+/z5KBFzEeS5wCr9NX6IxIJSzcpoRW42TxZlcgvV+/gAnFUSExDDO
	 6Mzcvh0+ZmXhk5nuMtsz7VxnXlFeC01J3IRMzf/YwcVMGPQRoZ0wA/b7q8ZU4kd8qe
	 Tr0DY7jasg+uCyQTKpcs1LK6zj/lFIYQO1eJwkOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/317] perf annotate: Add --demangle and --demangle-kernel
Date: Thu, 13 Jun 2024 13:32:38 +0200
Message-ID: <20240613113252.983097401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin Liška <mliska@suse.cz>

[ Upstream commit 3406ac5347dbf64ab9f7b137ed25a18493f5ea2d ]

'perf annotate' supports --symbol but it's impossible to filter a C++
symbol. With --no-demangle one can filter easily by mangled function
name.

Signed-off-by: Martin Liška <mliska@suse.cz>
Link: http://lore.kernel.org/lkml/c3c7e959-9f7f-18e2-e795-f604275cbac3@suse.cz
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 374af9f1f06b ("perf annotate: Get rid of duplicate --group option item")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-annotate.txt | 7 +++++++
 tools/perf/builtin-annotate.c              | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index 1b5042f134a86..80c1be5d566cb 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -124,6 +124,13 @@ OPTIONS
 --group::
 	Show event group information together
 
+--demangle::
+	Demangle symbol names to human readable form. It's enabled by default,
+	disable with --no-demangle.
+
+--demangle-kernel::
+	Demangle kernel symbol names to human readable form (for C++ kernels).
+
 --percent-type::
 	Set annotation percent type from following choices:
 	  global-period, local-period, global-hits, local-hits
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4940d10074c3e..8059cf12cce86 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -538,6 +538,10 @@ int cmd_annotate(int argc, const char **argv)
 		    "Strip first N entries of source file path name in programs (with --prefix)"),
 	OPT_STRING(0, "objdump", &annotate.opts.objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
+		    "Enable symbol demangling"),
+	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
+		    "Enable kernel symbol demangling"),
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
-- 
2.43.0



