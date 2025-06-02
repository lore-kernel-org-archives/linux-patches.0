Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493CE17BBF;
	Mon,  2 Jun 2025 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876044; cv=none; b=UKc4fZwZqQ6afepCheWdQ+0lascc+9kwhBMgYTCihp56MAmldnpNIzQJAkr0X4C9t7VrMOCKsyWBGxOVKU4RCil/PoM0hkxsum2+ytHQODqbyjlOZIhfphmfU1YAOTK4fpCGzsre9CZeDXTYeXyh/0zJloJmevnrx7XnqFHuTHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876044; c=relaxed/simple;
	bh=wtni4mSLATK4o4lGmYHSWgT31ftDDsfiG2l4vkcdy30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpYToXpZMsNlXFZaBTgQDxV3bokL1u0s+1QDRIu03Eg/umWha+9cknPd82jCUf9yZyfgEbQe+WzVet0y6h82JEMm2pQpZm97a2s31XoQs+J+XEj3sCRSoRsXnxX57lpkjkWMfKVgmAl1VjN6igfsWOINVUhnQ0PIi40iQSujKQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBRQfXSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBRQfXSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A32C4CEEB;
	Mon,  2 Jun 2025 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876043;
	bh=wtni4mSLATK4o4lGmYHSWgT31ftDDsfiG2l4vkcdy30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBRQfXSjfWXDnDPFki8F+z1rEJ3X6nv498hQhyAlYofS+/NAfMSjeHIpbSXDRFaRG
	 Tv9xzYi9B8YnPFq6wYvXOPVGB2Z/rRbsur57afo1i1uBBd3bDpaYO6/UtdtL6B0Z1F
	 4ywBhuqQl0Ul5B4TaTL7ZzwtrC7C1ELrfj0JCs6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/207] tools/build: Dont pass test log files to linker
Date: Mon,  2 Jun 2025 15:46:34 +0200
Message-ID: <20250602134259.644645850@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 935e7cb5bb80106ff4f2fe39640f430134ef8cd8 ]

Separate test log files from object files. Depend on test log output
but don't pass to the linker.

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250311213628.569562-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.build | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
index 715092fc6a239..6a043b729b367 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -130,6 +130,10 @@ objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
 obj-y        := $(addprefix $(objprefix),$(obj-y))
 subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
 
+# Separate out test log files from real build objects.
+test-y       := $(filter %_log, $(obj-y))
+obj-y        := $(filter-out %_log, $(obj-y))
+
 # Final '$(obj)-in.o' object
 in-target := $(objprefix)$(obj)-in.o
 
@@ -140,7 +144,7 @@ $(subdir-y):
 
 $(sort $(subdir-obj-y)): $(subdir-y) ;
 
-$(in-target): $(obj-y) FORCE
+$(in-target): $(obj-y) $(test-y) FORCE
 	$(call rule_mkdir)
 	$(call if_changed,$(host)ld_multi)
 
-- 
2.39.5



