Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9F131283C;
	Tue, 11 Nov 2025 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825244; cv=none; b=jOqNhNdDJXXpfAv+H597kfxR+rLAQTwPJMlwoRp2jdN+wE9vXGGCgvAvNtX7eyHQs7VvirpiB906dbogtS652vLppiuySOxi1owkKBcnUaPjxssl5UA9xDI4Kr800wcYjg9kLzQgL+YQ1cKcnk5rj+iadsB+A2i82YFAv5BSeNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825244; c=relaxed/simple;
	bh=tD4gSrsOv3l5iAkbknKBTiWLLtuKbs1zC2v+zGaxiUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktTy1uy1xfsCVbcxvVv241D3RtMHg0DNTsRLsgX8nGSV8Ij0hm6tBB2MVfl38ibg3iQ/m46hUu0b6tuAdl01cStJsvhmkaSANJNrUn9pL5dzPb/hcyz1vdsw1Ug2RVNxwBf0/GQ/wUwqnm/SYo6p9ZlbGlq6ToEcG6T+hUeIfLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIGV5+RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIGV5+RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B5AC116D0;
	Tue, 11 Nov 2025 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825243;
	bh=tD4gSrsOv3l5iAkbknKBTiWLLtuKbs1zC2v+zGaxiUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIGV5+RYoGJ84p+nuP2DDb9s8eMuO0XFYJYlu7xgVBhLpIfB7OmTcq5gJZnnOS5Nf
	 Y13sgFtNCnHSXUA3gLDVJZ1Qz39ggORtQY+od21lVU/4nU1hrCFaAsnmilDw/lhmRp
	 8E9H+acnq6Q/wl3neRpICzWeZH1WmzKwcgfrtJo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 722/849] tools: lib: thermal: use pkg-config to locate libnl3
Date: Tue, 11 Nov 2025 09:44:52 +0900
Message-ID: <20251111004553.889713862@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ac918e98cd033..41aa7a324ff4d 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -46,8 +46,12 @@ else
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
@@ -59,6 +63,7 @@ INCLUDES = \
 override CFLAGS += $(EXTRA_WARNINGS)
 override CFLAGS += -Werror -Wall
 override CFLAGS += -fPIC
+override CFLAGS += $(NL3_CFLAGS)
 override CFLAGS += $(INCLUDES)
 override CFLAGS += -fvisibility=hidden
 override CFGLAS += -Wl,-L.
-- 
2.51.0



