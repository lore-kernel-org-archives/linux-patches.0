Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3634D917;
	Fri, 21 Nov 2025 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733015; cv=none; b=RhOiGlJa3SgQyCwnEIH9KeQj5Gw3XlvSU5PvjxsL0+HkUZ5EfwtO40go1NKsAntNgIttrgHIJjsvexlz30POh4NYnqWjX4wUyqlkiW1TBfauxYXFrSWrZUSDiV0E3ugXMgpXbqm0ZmEdiwyEzEQ1Z6Ux/COq8HQ7Loc3ROFEZmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733015; c=relaxed/simple;
	bh=jAJceNT+P0W2L8DXgWF27buBz4zgPN0AFAE7hCQ1UpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuWPCbh6TO3apJCFvTslqZt0kDbe3WTqmyofdpCiWNsSmGQveKe/wIjkaIlVX7EzUocwvPi2nzzdjV+Zom3CcsUb1DVNtmqDUQBlicDbLyr94MVfRdYPxd0MFPpffeiTVdA1SlEaM6Sxb0wLZ1s3r1EHo0gBDVzzikBFkgDUwCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muYEjCVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muYEjCVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EBC116C6;
	Fri, 21 Nov 2025 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733015;
	bh=jAJceNT+P0W2L8DXgWF27buBz4zgPN0AFAE7hCQ1UpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muYEjCVDnT2zZMQtyhYqnJEF0j1d9ygMNXqrqsKr2JMLNrZbF1CoNQuPUEkyEmnut
	 kQ5CrzYYXsJJR//GCorGxnMsH+UPgOCUg0qN8O+m1+Vkb9nCZr8KnXw6XdZWIvRKTj
	 yj6CmzIY58ovk1y32NMzNH9lUbO3msF3VZVup870=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/529] tools: lib: thermal: use pkg-config to locate libnl3
Date: Fri, 21 Nov 2025 14:10:21 +0100
Message-ID: <20251121130242.483508316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



