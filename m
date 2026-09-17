Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E27950254F;
	Thu, 17 Sep 2026 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665022; cv=none; b=ne5Qwy8JcguWNsW/GWMJETq7g0CPeVzVBJekkYXgZ7lI9jRww9s4CF4SijBVwIOrKt0h+VLM46fcCF/8KZOSjIbEqYZwNcSpqT2nWfXu687uAdq8nuJT6PeswsEX/6+m2yG1Wj9vZgZm7mchV4p4DKEcapq9FO2HhLBYMIi1jbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665022; c=relaxed/simple;
	bh=6wpu8ONKX1G/UVdF/UYtWS9uVsyMWmuOdjxMDnTUE2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ooz+HczuaBgl3Yz35PY/l+CvOP2rUpJPhPl/+htK7Fe1BOQCsjD4K0D4O6/VRbl/e2n4QUDRdRWcHUL9WRsNXgB4K/l16TXAqVsyvYfhJb1Fhmenxm5jDHyg/p1wMNrGeVasXUUjmQpfn35jAWwcSeawB6EvLQjuoyMqTr6LYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STbAn4+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STbAn4+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE51F000FF;
	Thu, 17 Sep 2026 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665020;
	bh=kHcJC7r/upxzM3jgRXOKw1u9Uv9htrlDjs/qCZJUaFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STbAn4+OX11NYdnvTfnOgYQdHM+vn8OqYU7JzqoJB/Oxg+Vugcd4T9/4S+cJ/mYbD
	 8aG4GwzVczOra8zAtvArGv5gewN0/XDkZwvaL6awYyRvcAGmml3Os57Xe03kkMWvM4
	 rAfQ69vCMIGA7uJ38a7rxhWbtp2sx4166ulV9KkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0567/1250] bpftool: Strip all -Wformat* flags from bootstrap libbpf build
Date: Thu, 17 Sep 2026 16:06:02 +0100
Message-ID: <20260917151607.286963447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit a954c9e3168cdf0c3cad07b43dfc8ca2945d773a ]

Commit 9080b97689db ("bpftool: Pass host flags to bootstrap libbpf")
started building the bootstrap libbpf with HOST_CFLAGS, stripping the
warning options that are unsuitable for that build by filtering out
-W -Wall -Wextra -Wformat -Wformat-signedness.

HOST_CFLAGS inherits EXTRA_WARNINGS, which includes -Wformat-security
and -Wformat-y2k. The filter drops -Wall and -Wformat (the latter being
what actually enables -Wformat), but leaves those two -Wformat-* children
in LIBBPF_BOOTSTRAP_CFLAGS. Building the bootstrap libbpf with it then
warns:

  cc1: warning: '-Wformat-y2k' ignored without '-Wformat'
  cc1: warning: '-Wformat-security' ignored without '-Wformat'

The warning is easy to miss in an in-tree build: tools/lib/bpf/Makefile
re-adds -Wall via "override CFLAGS += -Wall", which re-enables -Wformat
for the libbpf objects, so only libbpf's feature-detection probe (which
uses the passed CFLAGS verbatim) leaks the two warnings. The standalone
libbpf Makefile (github.com/libbpf/libbpf, used by the bpftool mirror)
instead uses "CFLAGS ?= ... -Wall", which the passed-in CFLAGS overrides,
so -Wall is never re-added and every bootstrap object warns.

Use a -Wformat% wildcard in the filter-out so the orphaned children are
removed together with the parent.

Fixes: 9080b97689db ("bpftool: Pass host flags to bootstrap libbpf")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20260630205418.3483969-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 4b6670bad86e7..0081f5bf73b72 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -94,7 +94,7 @@ HOST_CFLAGS := $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),\
 HOST_LDFLAGS := $(LDFLAGS)
 
 # Remove warnings for libbpf bootstrap build
-LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat%,$(HOST_CFLAGS))
 
 INSTALL ?= install
 RM ?= rm -f
-- 
2.53.0



