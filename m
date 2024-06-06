Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2FC1974F3;
	Thu,  6 Jun 2024 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682944; cv=none; b=dAV8Q92N5s2xaC5Akzlr0VCB1rsB8RZ5JADt2YflbIt98r4S/3nkDc0T42nN4v8M2qUwVmQAu8rOb6BoLJPEN0bRkBbwUH8CbYAz0tgzllgwMuCjaurhBEbi5tmMSYvgjzK/8+KInxbOV3ZwdwbF0Z8MsqGeykkPhwmkGW4evRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682944; c=relaxed/simple;
	bh=vYgYAwLgR4nu9TwTVle8QAURdA/Z8r9dUctVVEM9MPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMFT3s2oeHEX9BkN/GO3iHBgvOakjc2h8sB/V2+FwbNw3gSZZtwTXdgpcF5puxqhZ7oOkFN+HFd4nufbO08ByHrtQ5ZkLt3Sw/SHYCXugTOsoyQv2hk72Ns4vbUKvqxA5qK5BIpvLKUNkbnGgtFIwNzXFaGEkaa+Z+Uok6BaNkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/7KXbxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/7KXbxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57253C32782;
	Thu,  6 Jun 2024 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682944;
	bh=vYgYAwLgR4nu9TwTVle8QAURdA/Z8r9dUctVVEM9MPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/7KXbxzuw0XsZzgtiyOtaVrPCLVZzv5y+y13IbVzOUvP0qRFKqRbKZmDwWdW2Mv8
	 J0kdEHxyH8QBLhCXIfIriEWb4ncZ6s/KtZhwXMuV4xUDM+lU7sk9VuzU9D/f/tb50i
	 e4QCSMXFRLToBHCm3si3RBpHRId9V63cg6mokFEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 103/374] perf dwarf-aux: Fix build with HAVE_DWARF_CFI_SUPPORT
Date: Thu,  6 Jun 2024 16:01:22 +0200
Message-ID: <20240606131655.375756782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit c9d492378faec5c1fb8ea1534c620f7320bbb23a ]

check_allowed_ops() is used from both HAVE_DWARF_GETLOCATIONS_SUPPORT
and HAVE_DWARF_CFI_SUPPORT sections, so move it into the right place so
that it's available when either are defined. This shows up when doing
a static cross compile for arm64:

  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LDFLAGS="-static" \
    EXTRA_PERFLIBS="-lexpat"

  util/dwarf-aux.c:1723:6: error: implicit declaration of function 'check_allowed_ops'

Fixes: 55442cc2f22d0727 ("perf dwarf-aux: Check allowed DWARF Ops")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508141458.439017-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 56 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index ff1874ae0832e..f93e57e2fc42e 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1168,6 +1168,34 @@ static int offset_from_dwarf_op(Dwarf_Op *op)
 	}
 	return -1;
 }
+
+static bool check_allowed_ops(Dwarf_Op *ops, size_t nops)
+{
+	/* The first op is checked separately */
+	ops++;
+	nops--;
+
+	/*
+	 * It needs to make sure if the location expression matches to the given
+	 * register and offset exactly.  Thus it rejects any complex expressions
+	 * and only allows a few of selected operators that doesn't change the
+	 * location.
+	 */
+	while (nops) {
+		switch (ops->atom) {
+		case DW_OP_stack_value:
+		case DW_OP_deref_size:
+		case DW_OP_deref:
+		case DW_OP_piece:
+			break;
+		default:
+			return false;
+		}
+		ops++;
+		nops--;
+	}
+	return true;
+}
 #endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT || HAVE_DWARF_CFI_SUPPORT */
 
 #ifdef HAVE_DWARF_GETLOCATIONS_SUPPORT
@@ -1345,34 +1373,6 @@ static bool match_var_offset(Dwarf_Die *die_mem, struct find_var_data *data,
 	return true;
 }
 
-static bool check_allowed_ops(Dwarf_Op *ops, size_t nops)
-{
-	/* The first op is checked separately */
-	ops++;
-	nops--;
-
-	/*
-	 * It needs to make sure if the location expression matches to the given
-	 * register and offset exactly.  Thus it rejects any complex expressions
-	 * and only allows a few of selected operators that doesn't change the
-	 * location.
-	 */
-	while (nops) {
-		switch (ops->atom) {
-		case DW_OP_stack_value:
-		case DW_OP_deref_size:
-		case DW_OP_deref:
-		case DW_OP_piece:
-			break;
-		default:
-			return false;
-		}
-		ops++;
-		nops--;
-	}
-	return true;
-}
-
 /* Only checks direct child DIEs in the given scope. */
 static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
 {
-- 
2.43.0



