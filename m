Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A762676CF;
	Tue,  8 Apr 2025 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114886; cv=none; b=Xjyl149rdIAjx8+Y4AwwK4g5OBUn3lxbus7pz+DI0J4RAWdXdIGBLk/ooqCBJEeCeWjNnNI9o3/QXiR3i1wSGJWErTRbT1Gymet0KO4DhLeiOcenyEnFlhZd+q7hUi7UD73YI1DbR2STLjk2UOw8yQqjUwg2Q8a1rNAKx1m9UqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114886; c=relaxed/simple;
	bh=1k9Xv78H64hK3UpH/I4P6/GbnoKbqt71llvVTbTERiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNJ3Pey78X+p7YSmip3H+ghnrc1T/hmhGnhaiy7yt5vKdRQvRINuJ9nIbmwd6L++/d0jX1E4MK8yFVrz5YzH8cs970wtpfX0qICgHhXcsLCxVAQ4GWuKP2jK22oUoN4lmbFG5AkiaM5x4KWbSAE2uHrU0yEKtR91YDhshpqGR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx8iXCMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx8iXCMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F94DC4CEE5;
	Tue,  8 Apr 2025 12:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114885;
	bh=1k9Xv78H64hK3UpH/I4P6/GbnoKbqt71llvVTbTERiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zx8iXCMu4bUTCFY+eXeWNa5Wz5VNcFVDS9nzFFClBcMwbzrnUYHg60nRoMA7Vlns1
	 t4ScIaIeJu4mO3E+mSKGADKrpKTYBz10Io5tsBe9Id5JvOc/XKe0KPYQwBAd6TO9dq
	 FuSw+/cyBjuemuCQuKHmPlxU8TjIGRdy1ZR9KtjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Shi <sshii@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 271/499] perf bpf-filter: Fix a parsing error with comma
Date: Tue,  8 Apr 2025 12:48:03 +0200
Message-ID: <20250408104857.976200799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 35d13f841a3d8159ef20d5e32a9ed3faa27875bc ]

The previous change to support cgroup filters introduced a bug that
pathname can include commas.  It confused the lexer to treat an item and
the trailing comma as a single token.  And it resulted in a parse error:

  $ sudo perf record -e cycles:P --filter 'period > 0, ip > 64' -- true
  perf_bpf_filter: Error: Unexpected item: 0,
  perf_bpf_filter: syntax error, unexpected BFT_ERROR, expecting BFT_NUM

   Usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]

          --filter <filter>
                            event filter

It should get "0" and "," separately.

An easiest fix would be to remove "," from the possible pathname
characters.  As it's for cgroup names, probably ok to assume it won't
have commas in the pathname.

I found that the existing BPF filtering test didn't have any complex
filter condition with commas.  Let's update the group filter test which
is supposed to test filter combinations like this.

Link: https://lore.kernel.org/r/20250307220922.434319-1-namhyung@kernel.org
Fixes: 91e88437d5156b20 ("perf bpf-filter: Support filtering on cgroups")
Reported-by: Sally Shi <sshii@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record_bpf_filter.sh | 4 ++--
 tools/perf/util/bpf-filter.l                | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/shell/record_bpf_filter.sh b/tools/perf/tests/shell/record_bpf_filter.sh
index 1b58ccc1fd882..4d6c3c1b7fb92 100755
--- a/tools/perf/tests/shell/record_bpf_filter.sh
+++ b/tools/perf/tests/shell/record_bpf_filter.sh
@@ -89,7 +89,7 @@ test_bpf_filter_fail() {
 test_bpf_filter_group() {
   echo "Group bpf-filter test"
 
-  if ! perf record -e task-clock --filter 'period > 1000 || ip > 0' \
+  if ! perf record -e task-clock --filter 'period > 1000, ip > 0' \
 	  -o /dev/null true 2>/dev/null
   then
     echo "Group bpf-filter test [Failed should succeed]"
@@ -97,7 +97,7 @@ test_bpf_filter_group() {
     return
   fi
 
-  if ! perf record -e task-clock --filter 'cpu > 0 || ip > 0' \
+  if ! perf record -e task-clock --filter 'period > 1000 , cpu > 0 || ip > 0' \
 	  -o /dev/null true 2>&1 | grep -q PERF_SAMPLE_CPU
   then
     echo "Group bpf-filter test [Failed forbidden CPU]"
diff --git a/tools/perf/util/bpf-filter.l b/tools/perf/util/bpf-filter.l
index f313404f95a90..6aa65ade33851 100644
--- a/tools/perf/util/bpf-filter.l
+++ b/tools/perf/util/bpf-filter.l
@@ -76,7 +76,7 @@ static int path_or_error(void)
 num_dec		[0-9]+
 num_hex		0[Xx][0-9a-fA-F]+
 space		[ \t]+
-path		[^ \t\n]+
+path		[^ \t\n,]+
 ident		[_a-zA-Z][_a-zA-Z0-9]+
 
 %%
-- 
2.39.5



