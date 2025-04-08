Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13926B091;
	Tue,  8 Apr 2025 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116774; cv=none; b=Ma78Wn0dPxYB7a8Q6WcEcXS6a5dX35IfiqQrg6mABpXOns81bJ4AaVQxmzhpSP01wOXnMf0KAKUaKhUezmW+haN0BaqArJojMZ3tDPyVqhSuqNFgePy1JbxsztuQ9QMyZ1Rr3kBg0PfxpHYgktbQQ0uM5mBmSTWyO9hFadAJDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116774; c=relaxed/simple;
	bh=b/0Iquo2X+GUsyNjo4czugT2oQiYuXTX4zPAYJSRv38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSv5kq8huCoZG/ogpqwjSz6LbdaahUAQBdImiJ4+TXEF1xvpHeUjpBMp+EyaPlHL9eyQ/hVxxSBFFXq6h8G1iqYVKfEkN5LTs/BFRpS4O5jf4cZ2+o4I54FXm52Lxf+P4VYaqJ6DjZbedbxtioq6B7OsJnK5VqSnbkh1twJgXGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7RJ+LC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7RJ+LC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19507C4CEE5;
	Tue,  8 Apr 2025 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116774;
	bh=b/0Iquo2X+GUsyNjo4czugT2oQiYuXTX4zPAYJSRv38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7RJ+LC72sFAiZGP3fmfSQaKjwtgUU2cIy9DDfUaoDDhkUtEsBzvj7ZgaK3GIySMJ
	 6dCmHq8T58h8aTr3A+ucIUHdxVT9ycoeZs+WPt1Snxq5U4A3492Z6fCKaDrwPeJcwi
	 7TvzFziU7IaxpBdf2oMJ+CM3FAaP1fvJNz5powYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Shi <sshii@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/423] perf bpf-filter: Fix a parsing error with comma
Date: Tue,  8 Apr 2025 12:49:10 +0200
Message-ID: <20250408104850.943339191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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



