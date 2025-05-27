Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746372110E;
	Tue, 27 May 2025 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366519; cv=none; b=G36ZE9VM6HXuW2W/2YEwrVl5fYfhr1Z/rSl/p0UU/+EM0E7EZq7qKTosE6cBzq1siVj47soSCM8CX0MIBMu5cUAh9gYYJp9eGc1NLAlmuYXoPyuuFFna8sn9Ff/0z4jPgCTes0Czv9jN6kPBUI+++mR3erO0oa0FhTAKoRNsVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366519; c=relaxed/simple;
	bh=J68ctQ7wpGNsIh71mZqK/QrF79ypVHlbKPAmZr0cTFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF15iy8g1cyFpieSXRO/aX7aQb/JMN1sqawmsoHNNHrVU4IrBYajqzefFGHHiF3odpo9GIQInRCtEF6aLcknafttdqWt3/v/mbR9OJBj/aUjug57d3YUVPSJfjBIZa8DhCpnvWs82WpjVTcIAq+XH9Oj1bZHC8wuIZSyjsKzHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwPxnPCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwPxnPCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AFAC4CEE9;
	Tue, 27 May 2025 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366519;
	bh=J68ctQ7wpGNsIh71mZqK/QrF79ypVHlbKPAmZr0cTFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwPxnPCGvwZ2Dg9oAuapkv7pNih/mbAPzOpwKNIeCnhZfJ0yN1829iBx9TWZ1mRHr
	 QRqYFiUd05wVk7FQv/7rSw+V9+Tm1Hx9YCL0/S1kGOWV+IWC5Q/F+ARLez6/Md9Z8e
	 2VVsmZu0TiNOxRi8rGaB4EStpsNiVZcC9MyLRC9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/783] tools/build: Dont pass test log files to linker
Date: Tue, 27 May 2025 18:18:12 +0200
Message-ID: <20250527162517.008993563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e710ed67a1b49..3584ff3086078 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -129,6 +129,10 @@ objprefix    := $(subst ./,,$(OUTPUT)$(dir)/)
 obj-y        := $(addprefix $(objprefix),$(obj-y))
 subdir-obj-y := $(addprefix $(objprefix),$(subdir-obj-y))
 
+# Separate out test log files from real build objects.
+test-y       := $(filter %_log, $(obj-y))
+obj-y        := $(filter-out %_log, $(obj-y))
+
 # Final '$(obj)-in.o' object
 in-target := $(objprefix)$(obj)-in.o
 
@@ -139,7 +143,7 @@ $(subdir-y):
 
 $(sort $(subdir-obj-y)): $(subdir-y) ;
 
-$(in-target): $(obj-y) FORCE
+$(in-target): $(obj-y) $(test-y) FORCE
 	$(call rule_mkdir)
 	$(call if_changed,$(host)ld_multi)
 
-- 
2.39.5



