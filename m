Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA1D322A22;
	Tue,  2 Sep 2025 13:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819828; cv=none; b=twV8udDqoSgCWX2xo7eK+DV93cqZGfNAqWrGEoSVgYPRavX6jn192FIWYQGwGFYMnq9kq1pq8ZAU+UjJw5SET3ZPMMAWi2DYXAXqhIxAeoGgagUCgPwpaPGbVktbSLbHR/kNLn+7piqUEOrACZ9G/5z2g6m4gTuApJECWDb/gvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819828; c=relaxed/simple;
	bh=gWNrWWQCz+9W2L4jSJjLaOLLKQfbwgM7eIwNfAKUNNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTIMlKSF16vldr/d862XElyPcwgLyoPksYYwJA5l5HEvLvA0K4B2L5+1eMIQCkG7MlN3TVgXs5FCKY1G7n+oMjvYkhpfCeqJ4QGJnNk0Zh70tJ3LQoZNMEMwLrQuzWEqFg0HRFBMn0jyB9cDR0JF08kmgWkPmQHAl4JTg6ZRvf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=011GV4Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="011GV4Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48937C4CEF4;
	Tue,  2 Sep 2025 13:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819827;
	bh=gWNrWWQCz+9W2L4jSJjLaOLLKQfbwgM7eIwNfAKUNNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=011GV4VeougIzS8FpVJq/woXQ2+0yhbfkC+ZjKt7j3lSBOpk70k2bxmSdjqo2IlPv
	 uMUX9eE000AOKquNdPrQsgksH7AWULuBfdM58jQyqlFepSZaMVnzHE+NVtMtuB0NLD
	 wyHTdQN1bqwmkayTj6kQ3rOZbUR96HINK/C3qYtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/95] tools/latency-collector: Check pkg-config install
Date: Tue,  2 Sep 2025 15:19:37 +0200
Message-ID: <20250902131939.665438991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 26ebba25e210116053609f4c7ee701bffa7ebd7d ]

The tool pkg-config used to check libtraceevent and libtracefs, if not
installed, it will report the libs not found, even though they have
already been installed.

Before:
libtraceevent is missing. Please install libtraceevent-dev/libtraceevent-devel
libtracefs is missing. Please install libtracefs-dev/libtracefs-devel

After:
Makefile.config:10: *** Error: pkg-config needed by libtraceevent/libtracefs is missing
on this system, please install it.

Link: https://lore.kernel.org/20250808040527.2036023-1-chen.dylane@linux.dev
Fixes: 9d56c88e5225 ("tools/tracing: Use tools/build makefiles on latency-collector")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/latency/Makefile.config | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/tracing/latency/Makefile.config b/tools/tracing/latency/Makefile.config
index 0fe6b50f029bf..6efa13e3ca93f 100644
--- a/tools/tracing/latency/Makefile.config
+++ b/tools/tracing/latency/Makefile.config
@@ -1,7 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+include $(srctree)/tools/scripts/utilities.mak
+
 STOP_ERROR :=
 
+ifndef ($(NO_LIBTRACEEVENT),1)
+  ifeq ($(call get-executable,$(PKG_CONFIG)),)
+    $(error Error: $(PKG_CONFIG) needed by libtraceevent/libtracefs is missing on this system, please install it)
+  endif
+endif
+
 define lib_setup
   $(eval LIB_INCLUDES += $(shell sh -c "$(PKG_CONFIG) --cflags lib$(1)"))
   $(eval LDFLAGS += $(shell sh -c "$(PKG_CONFIG) --libs-only-L lib$(1)"))
-- 
2.50.1



