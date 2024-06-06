Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABDF197500;
	Thu,  6 Jun 2024 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682946; cv=none; b=IK/+aRpMNKD2b2p9WpcWKUtnv5CIvQlnDggqhxhHYwq71YlivqD4DhLmNVwOESIYXdERwmd0dYyXfk8KZc47hw/7S86J6ONPR4k6Fmg0hkWVXNw2KEmLWnaKaA4wtwHRMBg6k47yylFwqRCIgiSLBtx6graexHsvjkpylR3jJqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682946; c=relaxed/simple;
	bh=23+oSholP9RC5FIeIzCnaOf+/Gskm/IemT7IovcpNMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es7EdjHqKq+ry2r2rNDNmVLGI7U4HBl+L81T6hBxbcCRVNPkCnN572Qb6NKGJXXk99ko4vIVNFnjLmptrH8PMPHdbX7bs5jvwZD6rnJXyrxDupGj+lHhvpsXGakBZv2LS6GOSdz8f12wk4aqta4poFhHuZG70hiNwK39jfIL2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1MSpbeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1MSpbeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF543C32781;
	Thu,  6 Jun 2024 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682945;
	bh=23+oSholP9RC5FIeIzCnaOf+/Gskm/IemT7IovcpNMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1MSpbeBRf/DT7rvwmka3JTAS9nelCaI8r58ckrEkjclgpuoFZ7bCmJA3mVfeZdCS
	 Vi9tfF9rl3MZ0vY3yh4pYmhpD6DFFmlJhXLlTMt+dlnS7uHz5KERr7LF6IeFRrs+h2
	 qmTtMZXp1yzZz5BmXAi9bT8l+eDVlqEoNaUaz5Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 106/374] perf symbols: Fix ownership of string in dso__load_vmlinux()
Date: Thu,  6 Jun 2024 16:01:25 +0200
Message-ID: <20240606131655.472918519@linuxfoundation.org>
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

[ Upstream commit 25626e19ae6df34f336f235b6b3dbd1b566d2738 ]

The linked commit updated dso__load_vmlinux() to call
dso__set_long_name() before loading the symbols. Loading the symbols may
not succeed but dso__set_long_name() takes ownership of the string. The
two callers of this function free the string themselves on failure
cases, resulting in the following error:

  $ perf record -- ls
  $ perf report

  free(): double free detected in tcache 2

Fix it by always taking ownership of the string, even on failure. This
means the string is either freed at the very first early exit condition,
or later when the dso is deleted or the long name is replaced. Now no
special return value is needed to signify that the caller needs to
free the string.

Fixes: e59fea47f83e8a9a ("perf symbols: Fix DSO kernel load and symbol process to correctly map DSO to its long_name, type and adjust_symbols")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240507141210.195939-5-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a1ca1b8156fe5..68dbeae8d2bf6 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1973,6 +1973,10 @@ int dso__load(struct dso *dso, struct map *map)
 	return ret;
 }
 
+/*
+ * Always takes ownership of vmlinux when vmlinux_allocated == true, even if
+ * it returns an error.
+ */
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, bool vmlinux_allocated)
 {
@@ -1991,8 +1995,11 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	else
 		symtab_type = DSO_BINARY_TYPE__VMLINUX;
 
-	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
+	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type)) {
+		if (vmlinux_allocated)
+			free((char *) vmlinux);
 		return -1;
+	}
 
 	/*
 	 * dso__load_sym() may copy 'dso' which will result in the copies having
@@ -2035,7 +2042,6 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map)
 		err = dso__load_vmlinux(dso, map, filename, true);
 		if (err > 0)
 			goto out;
-		free(filename);
 	}
 out:
 	return err;
@@ -2187,7 +2193,6 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map)
 		err = dso__load_vmlinux(dso, map, filename, true);
 		if (err > 0)
 			return err;
-		free(filename);
 	}
 
 	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
-- 
2.43.0



