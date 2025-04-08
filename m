Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47B3268C62;
	Tue,  8 Apr 2025 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111744; cv=none; b=tuT9lIqhzWbWR3RKdszJoT8TSrhEVAXaI36Lc6vSSMG4RGFUYznjedyhK4l0hnH1KQe958PsR5owK0YsX1Xm6yhSCFcq4FdvODb3y/O4hJo55xM3ZWHsb/WJ6OvBjRJ7xX9uie8dQxR3TUayuvbqwYedwB75bTRv+uZl4EA0J3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111744; c=relaxed/simple;
	bh=Lc9k+QutxRdxuuBluqSM7eHYgtcfZ2xl4A31W+QayKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRcm/wl8ad4AoBEKiMqMNyrrSBjhh2ds6wZ5wk/Wg0vtsCCckhjnVlokqLawiotALQ7W997Wif5Du7ASowX6aQIhsGq0p9M6CsFnWvJozZeEj7cYeA+rcaAF8ZI0srRLttXdn9c/VOsxdpjpJMFH5bzKD57EuzvcozJdMsHrPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1dtObTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1dtObTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C1C4CEE5;
	Tue,  8 Apr 2025 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111743;
	bh=Lc9k+QutxRdxuuBluqSM7eHYgtcfZ2xl4A31W+QayKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1dtObTteMTqCuguw134Lq1ZtK4e9bhryPD4lMnzMiOyZYlMmRbCURjObo5pQtm1u
	 QGm9K8Di3XcNmBsBkgtSq74/Fq4tEBOoDUaLmXyUnw3VLFgZYZ58C0JJKdH8rEETdX
	 vCctAUm0T0jzKbe1yNm9kCwT59mkGLQXHAG5Q8jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Shi <sshii@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 542/731] perf bpf-filter: Fix a parsing error with comma
Date: Tue,  8 Apr 2025 12:47:19 +0200
Message-ID: <20250408104926.883674767@linuxfoundation.org>
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



