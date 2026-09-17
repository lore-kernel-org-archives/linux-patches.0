Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF355012BE;
	Thu, 17 Sep 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668709; cv=none; b=Q1U6jWQ6VQPdaVuKGPw0jPdH7Fk4tuzHf/X4rDKaeZ6tvpeuraIJ2Rb10dfTW/rqQJEKZ/XyjNhLaabPsaLk+D56bRq4pYc45Jmz7TB3D2A9trEXxej6hK+uvG4zT6DhGeiJrMFUkeO6r9a3Vuv4hmImgQ43A8m3ZKE75CB4af4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668709; c=relaxed/simple;
	bh=JEAg3nu9+dPXFzVaOx5Ia4+EeVDKppRyWXAGtIdBzio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fal58Gb2S0Z9z9juqUEbkEstqgLX9xleMDDMrtO8HbhehEOa2oZp5TigBKuonRerwsomC7HhyFs5tkwOvvl1yBkQCq0Y3ajs4whJaWwEGfACkH7rwRwDi0NIZFU1O+4G6GzkPSPdlbJVcDxiUb+TKiIZvi4Jh9BQQt7rSEyBlvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpQM7g98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpQM7g98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A803E1F00893;
	Thu, 17 Sep 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668708;
	bh=6y9iJBsQT+ZHkRqDnAGFgr96jWGl1U9kKE8qVm0uEK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpQM7g98wDpNKEsZcYMLuRz/EVWxlwm+ZJ4klPIKovncj+c3uCsczqQMOtANNXwus
	 5xGgSjtxoUfDgDbNqZLaUIvY2qWuD5Idaf7nQMujK93i2oGgmEEIxdWbhOePBk9YAJ
	 WiwQFPSgUAjH8NG87jRzCIILUVoSrZmLhk6Yy3ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0466/1102] bpftool: Strip all -Wformat* flags from bootstrap libbpf build
Date: Thu, 17 Sep 2026 16:06:49 +0100
Message-ID: <20260917151551.389749085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index f92cdb7dbd428..6c2d32c874a6a 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -95,7 +95,7 @@ HOST_CFLAGS := $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),\
 HOST_LDFLAGS := $(LDFLAGS)
 
 # Remove warnings for libbpf bootstrap build
-LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat%,$(HOST_CFLAGS))
 
 INSTALL ?= install
 RM ?= rm -f
-- 
2.53.0



