Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246C41F09B3;
	Tue, 11 Nov 2025 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824686; cv=none; b=jQiPW3+Wx4yqVHPraY9RparR0SJDv81SY6n/CfF3UIdanT3Znx0XuK1F/qdmLSEP+CSOKfm42CpL4YhHUZL9b5630sGMWw3llUzzSweJMezT0FbqQ+ene/sMsUG+wIYdnANPbOGpTrOE1jBYQ+uudM7vLLYTiA4TltoXq4Rkjbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824686; c=relaxed/simple;
	bh=CG/9mu/FrnTPE3c0WBsyAQ1jagHM6MMDMERdq2zD46Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuHwyk9L3fuHuFtXjMIg5esEDxzODnZXEoMz+YWjrLbpo461f2uSsUza19E2EgjXrXgD0CwJRBdeJs9IHK2gIdR2RhP3U8lL4QMkkHaeTiAEi8CBp6koIv3AUCEIG6VXN9C7vCbAThEOukt5AaMggfzxjv2ek6Ll3oR+htPhq/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLjWSfL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLjWSfL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA89C113D0;
	Tue, 11 Nov 2025 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824686;
	bh=CG/9mu/FrnTPE3c0WBsyAQ1jagHM6MMDMERdq2zD46Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLjWSfL2xv0Sg3A8yt0QbfaVofrC0FtilhoDOLpPlXmsQFIUZpj8R5r5TFprU4sWl
	 65svqhYeWZ59fU0UomlHVKJp+Ybl5oQS4+Ooy8ACDy/kVGcYEvhQURxgvBsFxp2ShX
	 iUFU5cd7QAQozj/cVGjf7ztq5uA90ydbCIw2F9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 485/565] tools: lib: thermal: use pkg-config to locate libnl3
Date: Tue, 11 Nov 2025 09:45:41 +0900
Message-ID: <20251111004537.839164326@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit b31f7f725cd932e2c2b41f3e4b66273653953687 ]

To make libthermal more cross compile friendly use pkg-config to locate
libnl3. Only if that fails fall back to hardcoded /usr/include/libnl3.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/thermal/Makefile b/tools/lib/thermal/Makefile
index 1694889847caf..8d21ea1950a31 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -59,8 +59,12 @@ else
   CFLAGS := -g -Wall
 endif
 
+NL3_CFLAGS = $(shell pkg-config --cflags libnl-3.0 2>/dev/null)
+ifeq ($(NL3_CFLAGS),)
+NL3_CFLAGS = -I/usr/include/libnl3
+endif
+
 INCLUDES = \
--I/usr/include/libnl3 \
 -I$(srctree)/tools/lib/thermal/include \
 -I$(srctree)/tools/lib/ \
 -I$(srctree)/tools/include \
@@ -72,6 +76,7 @@ INCLUDES = \
 override CFLAGS += $(EXTRA_WARNINGS)
 override CFLAGS += -Werror -Wall
 override CFLAGS += -fPIC
+override CFLAGS += $(NL3_CFLAGS)
 override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
 override CFGLAS += -Wl,-L.
-- 
2.51.0



