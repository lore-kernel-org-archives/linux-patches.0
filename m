Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98B3AA194;
	Wed,  3 Dec 2025 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779571; cv=none; b=FaEB652yJrdwP1SmHuKEtAnMFaIkssyxCJ8uq6DoLne96hiawOr/lmM0iOflr9YC7HhGFe2VZRC5Q/sZCuf7w72o3O+DuAl3rOiW9/i8ODQnZ0MFRpXgto/qRKY3joXUrhEhAFPlFI2CNdK2JJV1ECosqR8KI1q5wazmgUkdku4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779571; c=relaxed/simple;
	bh=jX5vk4O5FaIkxZSATWdvzOFQJHcIgx3PwYPtdwzaAEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSmeepNHxD4+5GZjdKTgOkwOXhReo3y3g09kVbnfHLCU+a4ftJAN705sTz9DNsiFsihA2iqC00M+7TWOdWLHkhHNX8TUP00Z37Qza/RkM6z/bwt+4AmwZHkQpQYWLEA+BFN7rwDf0yIzgJau2ZDBLNS4ILtIk2/n7l2/odNzH1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFo+x/R9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFo+x/R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305C2C4CEF5;
	Wed,  3 Dec 2025 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779568;
	bh=jX5vk4O5FaIkxZSATWdvzOFQJHcIgx3PwYPtdwzaAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFo+x/R9fxNigosOrEfRpWIioo1X/xDjn3qaVwOvFnJ1u1LRMz1U1QyDiedPpGWqu
	 emHjAVbJu10WPJqchSm1MfBaylbB/I5o5XkAXMlhJbmSf+YJO3roIBByLEnNcY2mA9
	 vkAtc0+0iobt1aAx34aWml8FF2NiXggx3u2dKe+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/568] tools: lib: thermal: use pkg-config to locate libnl3
Date: Wed,  3 Dec 2025 16:24:59 +0100
Message-ID: <20251203152451.582146284@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



