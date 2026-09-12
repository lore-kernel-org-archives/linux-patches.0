Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA98A3806C6;
	Sat, 12 Sep 2026 07:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197311; cv=none; b=GayoxXovklDebPVbHd1o3r+XxxuAxn1VuwNGXrg7sEN8Ln9Ofe8R8AQLAB2KHUjJFEYkU11aQEtlIQ7MobzGfAEhAHGJho4cNtmVWfK4z6byQqLXcGIYRQoElkBwV3E5JXy5ZFtI5MPZrsOV2GzZS5YLl5Vd8JGX7ujw/6ZmN/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197311; c=relaxed/simple;
	bh=DHFStljFB0TTqhvYu8VsBPzqywrB17EyuZaVqnyTYUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jB6D8Pr86u0d4NrBfQmP50lFr1TCRaQsu17Hdbgh4zvBBSVEHuNFtAPHjnZ3GZkL9tEu45ObPv9Qo+coUd0F3Q2albMkDJMfKtaJQjXFXwT0f9qzN/M0V5hVIGxNXEHzpkwY69WFAae3CBRWpetjOarC46DLLj5UURRxsc8iaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyF7tDxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyF7tDxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7C11F000FF;
	Sat, 12 Sep 2026 07:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197310;
	bh=d6xxniUgogg/GQnjJZ58/9L+q4R2DuxAKpDZCQ262Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyF7tDxoDr8HPf1IFaPWar29DC8yMeKkkesl5wzjbnCmZ0gNREfzB5zCou9sb2Bg5
	 FxombxyYII+USrEHkkCU9lYdq52IybSbYuOVoRK2aqukRFYE6raDdLcPzxWqcLDmyD
	 4ATaXjUpEdIo+5N63lQwLfrqBnySYk8F6GBSPzBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0149/1815] bpftool: Strip all -Wformat* flags from bootstrap libbpf build
Date: Sat, 12 Sep 2026 08:31:39 +0200
Message-ID: <20260912065652.514450722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 271a7dc772730..b0f7168e79432 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -99,7 +99,7 @@ endif
 HOST_LDFLAGS := $(LDFLAGS)
 
 # Remove warnings for libbpf bootstrap build
-LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat -Wformat-signedness,$(HOST_CFLAGS))
+LIBBPF_BOOTSTRAP_CFLAGS := $(filter-out -W -Wall -Wextra -Wformat%,$(HOST_CFLAGS))
 
 INSTALL ?= install
 RM ?= rm -f
-- 
2.53.0



