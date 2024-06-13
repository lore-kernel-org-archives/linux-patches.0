Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C6143C4B;
	Thu, 13 Jun 2024 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279959; cv=none; b=uts63up9dMhUE8OsdMVOWuoLsAafZSrFjtuwuTJymYzXwPFGvHsM7nvEgcXOjnYscvu6Pj6Rj0eZzVGGdXRETB1Ad3SaIgqR+3Kyqm26AK70C23rL9pmGEmW3Bs9UUSjqgcCGi6V34EiFTmxMq+nGTiEs2rtmRV2ovJ0a/54F48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279959; c=relaxed/simple;
	bh=+iNlXbuUQkKYjFZTaSHSnRsyje+flLizJfOLtxToIe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpS+Hhc12cQoul0g0KBwf0Q4S78WWWpAb3zZV1xYWBREzPtYrNmdaFjBHeMctj+aoF7DZvxz1ZpQLXld+bci0T/bCFZx2fPFQTG304Ic9YSTxNczWbjnlgQ/wEwJa51B/n/bQ28YjW/xihNILwG5JyHQ0LLvCKY4n33JU9+4DY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNUJHYiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNUJHYiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAD7C2BBFC;
	Thu, 13 Jun 2024 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279959;
	bh=+iNlXbuUQkKYjFZTaSHSnRsyje+flLizJfOLtxToIe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNUJHYiMKQZWPVmb9Z6/CZEsmYt2HjRvUDqb0Ew1fdxRST92qFaqHs5R2U14mqALU
	 Sofd2IJ0J86d57V61ZmCNXz7u6vRBPfmdKCEQtrQaILJd++0vLOkOgO1NVceBVjVzJ
	 1ykZq1R5l/lh8Q7go4fDaVJ3a6bMZY2+LQBLDW88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/202] perf annotate: Add --demangle and --demangle-kernel
Date: Thu, 13 Jun 2024 13:33:13 +0200
Message-ID: <20240613113231.436489657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e8c972f89357d..066ecfffbf4ed 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -118,6 +118,13 @@ OPTIONS
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
index 8db8fc9bddef3..a6fea0be3a5d6 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -537,6 +537,10 @@ int cmd_annotate(int argc, const char **argv)
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
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



