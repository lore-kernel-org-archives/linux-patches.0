Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3C3268FE5;
	Tue,  8 Apr 2025 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111520; cv=none; b=Bq7LtOMhdAnNq0nI7cWV1Z2I6UYKEqVcbY6Pe+vgTn5OVDIq0hWjXQtste+AvQwP36QQxjqEVhjh+6SS4XFgYkAojHTI4JnJ9BGzF5hkahL7IrxYXM9EAhLtWZHwTzAgLVNwCMZVIvgYKu9daKi5NMWcmnzwfa4c3WUkbckMaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111520; c=relaxed/simple;
	bh=M+6sa4W6TzROXg/lTJb14oZ/cd5CkQP9m6EGd2D0O2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnx5bVhD8mtNGWI7hLw/NOlM9+JEkKzY1kNch9AuT8/apyYMwAK0mq1cPDW/f5NzgVA/7JVlM+qc0jdG/KpO2L3iHXNgAKVsyALwKCX0E0VZOYg2KH5LyBioCPN24HL73A0SJXNDEeNjLirnsVoo9GA017KCjv48B0gmi7EHUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZyhy350; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZyhy350"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586A8C4CEEB;
	Tue,  8 Apr 2025 11:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111520;
	bh=M+6sa4W6TzROXg/lTJb14oZ/cd5CkQP9m6EGd2D0O2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZyhy350WX4yPl8IxWHMEOoGwtOy8Xvmbqu1UNKKwqC+4UU0wWyiHD71DEB683VOR
	 n0ZKQm6VMdbO1B05I6YF57jnSaHm2VBXdXupqI9I9jTumuaFd4Vc+dnKuw81+2OaCc
	 qkMtS1DT0pRnswcB+/Cx4y6q3cZXSnhYAa8POurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 460/731] perf report: Fix input reload/switch with symbol sort key
Date: Tue,  8 Apr 2025 12:45:57 +0200
Message-ID: <20250408104924.980521864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit 6353255e7cfab568058580424fa0967bf4504fe5 ]

Currently the code checks that there is no "ipc" in the sort order
and add an ipc string. This will always error out on the second pass
after input reload/switch, since the sort order already contains "ipc".
Do the ipc check/fixup only on the first pass.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://lore.kernel.org/r/20250108063628.215577-1-dvyukov@google.com
Fixes: ec6ae74fe8f0 ("perf report: Display average IPC and IPC coverage per symbol")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 66b8b1c32e00a..e74d8a6cfa5ae 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1730,22 +1730,24 @@ int cmd_report(int argc, const char **argv)
 		}
 	}
 
-	if (sort_order && strstr(sort_order, "ipc")) {
-		parse_options_usage(report_usage, options, "s", 1);
-		goto error;
-	}
-
-	if (sort_order && strstr(sort_order, "symbol")) {
-		if (sort__mode == SORT_MODE__BRANCH) {
-			snprintf(sort_tmp, sizeof(sort_tmp), "%s,%s",
-				 sort_order, "ipc_lbr");
-			report.symbol_ipc = true;
-		} else {
-			snprintf(sort_tmp, sizeof(sort_tmp), "%s,%s",
-				 sort_order, "ipc_null");
+	if (last_key != K_SWITCH_INPUT_DATA) {
+		if (sort_order && strstr(sort_order, "ipc")) {
+			parse_options_usage(report_usage, options, "s", 1);
+			goto error;
 		}
 
-		sort_order = sort_tmp;
+		if (sort_order && strstr(sort_order, "symbol")) {
+			if (sort__mode == SORT_MODE__BRANCH) {
+				snprintf(sort_tmp, sizeof(sort_tmp), "%s,%s",
+					 sort_order, "ipc_lbr");
+				report.symbol_ipc = true;
+			} else {
+				snprintf(sort_tmp, sizeof(sort_tmp), "%s,%s",
+					 sort_order, "ipc_null");
+			}
+
+			sort_order = sort_tmp;
+		}
 	}
 
 	if ((last_key != K_SWITCH_INPUT_DATA && last_key != K_RELOAD) &&
-- 
2.39.5



