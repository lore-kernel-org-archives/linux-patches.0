Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766321F55F8;
	Tue, 26 Aug 2025 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212793; cv=none; b=fJvzHLoi41xHQSzKtnq/kLH3wRP13699lfgWHJ+DwD3Ponytp4lEV4+chihsHu+/K5NqpQ8mYehAn+oMgxyBxvf0y51r69sdGtiuF8C+94Zsvhm0nhaCm7HiE3lbunqgwK3ZcMRPqYWC8UGIQwSLBFsJPUwQqtgH6N8v4/Wdq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212793; c=relaxed/simple;
	bh=UcNL2+9FFy8bJ1p1K3qzu3GsVE6khqfBu9rxXP0T3N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRDzWdldLRdTnI57kADG2oGD5mZlSBFufsamlG/0+Mvx9fX4e02HQnXGPrAbJWYwBwjZkE5+/5hpLDRaKB2oa/mEqQ3uZ9jwxe6mznWLb2+HKRgArirBgTIjksgCMp0Q1wTiM4brX5e2b7G4HfGrrnfCHgImBH49I5y4Ix6u9mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV1AupJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV1AupJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07734C4CEF1;
	Tue, 26 Aug 2025 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212793;
	bh=UcNL2+9FFy8bJ1p1K3qzu3GsVE6khqfBu9rxXP0T3N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV1AupJFTDIillxHhWf/NJPn/ALgMIzXmzh6SK4qEGXoR4eYShq5/7t42bl90nV22
	 lBPmscfUnbyf9m7kD1U5rP7CAW98CIIYaYyR2KBhNb8L6LvzqlMhUYW2vViNjHo0dS
	 49KdGeA8ggAjQTUXRo30VcpV4/btqibbUgJerC1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/587] tools/build: Fix s390(x) cross-compilation with clang
Date: Tue, 26 Aug 2025 13:04:14 +0200
Message-ID: <20250826110955.610937953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a40f0cdce78be8a559ee8a85c908049c65a410b2 ]

The heuristic to derive a clang target triple from a GCC one does not work
for s390. GCC uses "s390-linux" while clang expects "s390x-linux" or
"powerz-linux".

Add an explicit override.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250620-tools-cross-s390-v2-1-ecda886e00e5@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/scripts/Makefile.include | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index ff527ac065cf..c006e72b4f43 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -98,7 +98,9 @@ else ifneq ($(CROSS_COMPILE),)
 # Allow userspace to override CLANG_CROSS_FLAGS to specify their own
 # sysroots and flags or to avoid the GCC call in pure Clang builds.
 ifeq ($(CLANG_CROSS_FLAGS),)
-CLANG_CROSS_FLAGS := --target=$(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(notdir $(CROSS_COMPILE:%-=%))
+CLANG_TARGET := $(subst s390-linux,s390x-linux,$(CLANG_TARGET))
+CLANG_CROSS_FLAGS := --target=$(CLANG_TARGET)
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)gcc 2>/dev/null))
 ifneq ($(GCC_TOOLCHAIN_DIR),)
 CLANG_CROSS_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
-- 
2.39.5



