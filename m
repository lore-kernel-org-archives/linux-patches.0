Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A793EEAC7;
	Tue, 21 Jul 2026 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661244; cv=none; b=YVmx3uNJ2LLlKF56zdKmDY7KFNKJATSkamB7Q/QFoId8i2wr1sIb+rx5FTx0XJEr76XklW7Y97PGTvLawyLnF8EiyeQq7A6IVRIcc5xC3a9UUshlKrZbO9K/K18t5HPDKHZNjVfw/hn9MJs9aJDdl5n4M7amcucuJK9ZNv9uFUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661244; c=relaxed/simple;
	bh=hYiR0Q5IOKB4ErYoVdSm5gls6N1ffnleLK8WD97OiVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj+HkIZqPnIkldQ7rRAK6mrSXNY50NXDmi7WSQkLL760mcR1QEbNBLsrKus5wGqchkDpmFTRVEiupHRUgesmSmd7VRcxVTMFmmffBqmLi9YlAuF+j+5it7VFkYJkFCS24bBIYisYONovUslppza9khmG6+ZPt5UdX+UlOkadUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNjjrU4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNjjrU4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4B01F000E9;
	Tue, 21 Jul 2026 19:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661243;
	bh=SplqD2BGNprd8YoI7+wT8cIKFZlUbaGXtqVKNnTRWCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNjjrU4STuzgRBeKVvvux7LjeA7R/tenoX1ir5q4iPvrpQF2JZx070ebcRqBxpxtg
	 Gy00fVdTemtPOZ2ynJSZh45QA+UCJNzrQOtGwsbzBLDz3WCSvXdpFe5DKZ3EFYq/g9
	 joDm1Nql5tRCwn3NUix6dXw0PcVPen7vown62AhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1283/2077] tools: ynl: build archives with $(AR)
Date: Tue, 21 Jul 2026 17:15:56 +0200
Message-ID: <20260721152623.079272869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 8c37e76f960b7a201556e954b987b431820995ee ]

Use $(AR) to allow build system to override the archiver tool (e.g.,
when cross-compiling for a different architecture) by setting the AR
environment variable.

GNU Make defaults AR to ar, so this change will not break existing build
environments that do not explicitly set AR.

Fixes: 07c3cc51a085 ("tools: net: package libynl for use in selftests")
Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Signed-off-by: Greg Thelen <gthelen@google.com>
Link: https://patch.msgid.link/20260622161659.145047-1-gthelen@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/Makefile           | 2 +-
 tools/net/ynl/generated/Makefile | 2 +-
 tools/net/ynl/lib/Makefile       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/Makefile b/tools/net/ynl/Makefile
index d514a48dae270d..3cefe4ed96cb92 100644
--- a/tools/net/ynl/Makefile
+++ b/tools/net/ynl/Makefile
@@ -22,7 +22,7 @@ tests: | lib generated libynl.a
 ynltool: | lib generated libynl.a
 libynl.a: | lib generated
 	@echo -e "\tAR $@"
-	@ar rcs $@ lib/ynl.o generated/*-user.o
+	@$(AR) rcs $@ lib/ynl.o generated/*-user.o
 
 $(SUBDIRS):
 	@if [ -f "$@/Makefile" ] ; then \
diff --git a/tools/net/ynl/generated/Makefile b/tools/net/ynl/generated/Makefile
index 86e1e4a959a751..ea4128f612d6c7 100644
--- a/tools/net/ynl/generated/Makefile
+++ b/tools/net/ynl/generated/Makefile
@@ -37,7 +37,7 @@ all: protos.a $(HDRS) $(SRCS) $(KHDRS) $(KSRCS) $(UAPI) $(RSTS)
 
 protos.a: $(OBJS)
 	@echo -e "\tAR $@"
-	@ar rcs $@ $(OBJS)
+	@$(AR) rcs $@ $(OBJS)
 
 %-user.h: $(SPECS_DIR)/%.yaml $(TOOL)
 	@echo -e "\tGEN $@"
diff --git a/tools/net/ynl/lib/Makefile b/tools/net/ynl/lib/Makefile
index 4b2b98704ff9ba..9b98c059960003 100644
--- a/tools/net/ynl/lib/Makefile
+++ b/tools/net/ynl/lib/Makefile
@@ -15,7 +15,7 @@ all: ynl.a
 
 ynl.a: $(OBJS)
 	@echo -e "\tAR $@"
-	@ar rcs $@ $(OBJS)
+	@$(AR) rcs $@ $(OBJS)
 
 clean:
 	rm -f *.o *.d *~
-- 
2.53.0



