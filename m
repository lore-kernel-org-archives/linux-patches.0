Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD35267B96;
	Tue,  8 Apr 2025 12:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114628; cv=none; b=EiS+WoFYYR3EtRCgc0s5F/7k/0kkPNqSytsx1NDxKdgX+KyaIEHqQNX8ZjCDS2xXkncCsOIY39I6GuE7PI+Adqtghqd4YxVvf6W0TnRSTl4UTHYDHOGqkuTCA7V0mZaaiahRfwd0QOZG9kocgiEXwtwPQNMoczm6hR9sFbiCfnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114628; c=relaxed/simple;
	bh=+4nIE5+G6Dlk/1tBWoSo19IsZa7mhaHS6e+t/rE/jHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgG6A8Mz27/8fIHTALz9FppG9epn5FLHgcZaZ+/+rvcS3BFN6duehRr4XfnrxbPsAbGx5bcAGOsMUWCxk/SMYzT+1xL4wAWaa/yrGCXZYljUKTo0lfA7wlZgdzYUmTrhAbK9jcdl5v19VtUTJLXMxqHYjNlKPD7DpeGNcIudY/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8NjJNbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8NjJNbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5D7C4CEE5;
	Tue,  8 Apr 2025 12:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114628;
	bh=+4nIE5+G6Dlk/1tBWoSo19IsZa7mhaHS6e+t/rE/jHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8NjJNbv47h60y3vJcl/21lZ7IaYX4rWJrO4iP8Ptc2eulU6eP9FOS7ZV8KFnhbrK
	 6MrQrVM7DFkKRQb2OqAuPTpQaVb2qC7nIAbbngrMK5UZK0DgFE1oObc8BWCxVRqIfQ
	 G65gRrzR6V2I2r/12Nx6nnw9vEeWumaKLb0P6TyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinghao Jia <jinghao7@illinois.edu>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ruowen Qin <ruqin@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 178/499] samples/bpf: Fix broken vmlinux path for VMLINUX_BTF
Date: Tue,  8 Apr 2025 12:46:30 +0200
Message-ID: <20250408104855.612260962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinghao Jia <jinghao7@illinois.edu>

[ Upstream commit 94f53edc64e19640b5245721cd6d0c4a84f52587 ]

Commit 13b25489b6f8 ("kbuild: change working directory to external
module directory with M=") changed kbuild working directory of bpf
sample programs to samples/bpf, which broke the vmlinux path for
VMLINUX_BTF, as the Makefiles assume the current work directory to be
the kernel output directory and use a relative path (i.e., ./vmlinux):

  Makefile:316: *** Cannot find a vmlinux for VMLINUX_BTF at any of "  /path/to/linux/samples/bpf/vmlinux", build the kernel or set VMLINUX_BTF like "VMLINUX_BTF=/sys/kernel/btf/vmlinux" or VMLINUX_H variable.  Stop.

Correctly refer to the kernel output directory using $(objtree).

Fixes: 13b25489b6f8 ("kbuild: change working directory to external module directory with M=")
Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Ruowen Qin <ruqin@redhat.com>
Link: https://lore.kernel.org/bpf/20250203085506.220297-3-jinghao7@illinois.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 96a05e70ace30..f5865fbbae62f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -307,7 +307,7 @@ $(obj)/$(TRACE_HELPERS): TPROGS_CFLAGS := $(TPROGS_CFLAGS) -D__must_check=
 
 VMLINUX_BTF_PATHS ?= $(abspath $(if $(O),$(O)/vmlinux))				\
 		     $(abspath $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux))	\
-		     $(abspath ./vmlinux)
+		     $(abspath $(objtree)/vmlinux)
 VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 
 $(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
-- 
2.39.5



