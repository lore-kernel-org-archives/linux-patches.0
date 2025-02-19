Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C071DE2C2;
	Wed, 19 Feb 2025 08:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954509; cv=none; b=mgxB+we0OLQHY7CicM9fvfyyBI2ASKJYHFksIzC8wEXsWlbi/gSAuqYapQgZrYUaIJS9KpO9n750HnMwjh0gJJu47upYf51u+g6krHBkaP+5GlrW+Vb1IKPyxh6GeZrvx27lSSqbbchOcjXQN53cImy4hQ8XtzkVKunelT8K0sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954509; c=relaxed/simple;
	bh=N1tQwJ8SSQ0H7SsS61iP19SIBY/FMGhkTbBi0aiOsFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKcbhcr6ZsudHmIdOe4j/gurG3oZfVqHDIhmS4qRoJLs28ucaIVCeiu0QIGg5If0zRZ88Bnz1Kx8plY6QDp/4JCC3AP5spQhsBI5XaJ2OZTC/s5sFTPSa1oWyuF0Qy8IS6QCaV5xZvHDFBe++1MU4ibdxL3KkaJm1uStvFZh3S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHBo4Hp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHBo4Hp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B97BC4CED1;
	Wed, 19 Feb 2025 08:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954509;
	bh=N1tQwJ8SSQ0H7SsS61iP19SIBY/FMGhkTbBi0aiOsFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHBo4Hp/ibbz0jCS9eQNw6DTuETS5DG5ygQc9MARDask3J8Mt2t6G1/SX6+iPw4H7
	 HkOLRKJ0Z00jWkHFccGkSqkpjb3qHGQsh0yHM65PjDep87AxSxVhKRZrHDLz03IoJ4
	 A1v2AFIv7sDO4yNtLaxK+ZeINVceV6Eoj3K5eP2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruowen Qin <ruqin@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinghao Jia <jinghao7@illinois.edu>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 207/274] samples/hid: fix broken vmlinux path for VMLINUX_BTF
Date: Wed, 19 Feb 2025 09:27:41 +0100
Message-ID: <20250219082617.675573094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

[ Upstream commit 8b125949df58a00e8797c6e6d3f3d3dc08f4d939 ]

Commit 13b25489b6f8 ("kbuild: change working directory to external
module directory with M=") changed kbuild working directory of hid-bpf
sample programs to samples/hid, which broke the vmlinux path for
VMLINUX_BTF, as the Makefiles assume the current work directory to be
the kernel output directory and use a relative path (i.e., ./vmlinux):

  Makefile:173: *** Cannot find a vmlinux for VMLINUX_BTF at any of "  /path/to/linux/samples/hid/vmlinux", build the kernel or set VMLINUX_BTF or VMLINUX_H variable.  Stop.

Correctly refer to the kernel output directory using $(objtree).

Fixes: 13b25489b6f8 ("kbuild: change working directory to external module directory with M=")
Tested-by: Ruowen Qin <ruqin@redhat.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jinghao Jia <jinghao7@illinois.edu>
Link: https://patch.msgid.link/20250203085506.220297-4-jinghao7@illinois.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/hid/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/hid/Makefile b/samples/hid/Makefile
index 69159c81d0457..db5a077c77fc8 100644
--- a/samples/hid/Makefile
+++ b/samples/hid/Makefile
@@ -164,7 +164,7 @@ $(obj)/hid_surface_dial.o: $(obj)/hid_surface_dial.skel.h
 
 VMLINUX_BTF_PATHS ?= $(abspath $(if $(O),$(O)/vmlinux))				\
 		     $(abspath $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux))	\
-		     $(abspath ./vmlinux)
+		     $(abspath $(objtree)/vmlinux)
 VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 
 $(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
-- 
2.39.5



