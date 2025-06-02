Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F402147E7;
	Mon,  2 Jun 2025 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875521; cv=none; b=IRQ8qZS7C/to2Xa9oKdtOTUvhTgJ7bAX86xwymFjx9OwPstfon09E4mMj6bSyRndmW+CjJ4FCjob2eyCe3+jiy9ACe5HvXflWxCP/7gVBts4vYo+crc7TBCcSELJrOy7ZxaZFUyxOLlqTBFUSLuawTRHOH9/XlHvi1THQLKac8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875521; c=relaxed/simple;
	bh=RMjXY7BNgDQ5YdJKYBF5QskQxSBHpuc4TPE7hShoyAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WysHNq+YnTPFs8mHdGKENtkOcltUKp3CApD92O0MXZGkSqh8npNQQGNlMH3w64J3SNYABsvNbZN5oqPPqy3umHWut0yGOLkfe79c+R7ExWgoCWmMItQHqkVNVMIVj7Mz+grQwj7vRNnvJBRi7cSyern2YvjBfqbVoODcjU/n6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvo7udkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvo7udkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68065C4CEEB;
	Mon,  2 Jun 2025 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875520;
	bh=RMjXY7BNgDQ5YdJKYBF5QskQxSBHpuc4TPE7hShoyAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvo7udkmALxW1EG2sFS3rJ1nVA1qM3FmZAhl0tlLN6u32Jts5XkWNpe/wPs3Cb20l
	 BhqfyG189+Jktf1TFNBRmBR4QItwSMpGFC5HMzbgGzuqW6HXFfbPUvy+rVeKM4shkE
	 kskrWZ9XG/rqxkhAKdoMHyouhoYscQd6TkNf53Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/270] tools/build: Dont pass test log files to linker
Date: Mon,  2 Jun 2025 15:46:55 +0200
Message-ID: <20250602134312.545408610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd72016c3cfa7..ab0630ae6be85 100644
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



