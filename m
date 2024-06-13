Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E4D143872;
	Thu, 13 Jun 2024 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278844; cv=none; b=lDwGrTL0c0YcrTUuV/HuSBCr1PouWpGgRnbmDol4DzBBOzyV47x/nuVGuzsRg3kVoZC/5QkiX50rRgqTpNg/tZ3D/l+YyZIjZE0sf5lLyYZRiPdcal1qeAwgCc96hRmAQDf/zQDqVvncqPpdW0P3Y+6ByAU5pJFdB2d5uHCcr8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278844; c=relaxed/simple;
	bh=zsYIpWyEE+Rr63ZTKd/x0kU2LTiBw26M9kH2NT7JCXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/3ZIjONKs71weyCgTgaNSEitt4+GZXx66qskDg6SJu+34LqEqBHk4r+JYBk1Wp/NFGLGwgp2Mi41einOirXIdLetavCYTgBq/LsmcxzCNc7QP6yIi2i1QIRBOLf/bqObuGFI3YbdJpfkqxXfKdyHleT/7qTmqL5dziawXjqeQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT+Iad0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT+Iad0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15FBC2BBFC;
	Thu, 13 Jun 2024 11:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278844;
	bh=zsYIpWyEE+Rr63ZTKd/x0kU2LTiBw26M9kH2NT7JCXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT+Iad0OooNK7oxpsy9Msg4P4AVje6Q7/Mtnhy9tFbFj/srpy4tpNkM2/v/SW8H4t
	 lcnH+3Rqb/spw5HBuqutniw8omjFJa1xUZTLQ5zHjRBjyBxTYdbS2XRTSeHYHPv8gx
	 CyTm7qlBn/LQEf8b5lDCKkL+K+X7nMsPtQcFNxHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/213] perf annotate: Add --demangle and --demangle-kernel
Date: Thu, 13 Jun 2024 13:32:17 +0200
Message-ID: <20240613113231.443361711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 830481b8db26a..d12430fe9c783 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -533,6 +533,10 @@ int cmd_annotate(int argc, const char **argv)
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



