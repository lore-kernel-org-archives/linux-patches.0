Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46A15198D;
	Wed,  5 Feb 2025 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764693; cv=none; b=STTL4ibnWaCXmhmhU+7FXBc5W99lXUfpCYUZZ00n3M1uuGZEtqaxGnWxApvyt+MY5wQjPLHyl5bvxIBOgeRhQJOHQPeqnLUhCg7XpUsVNuMV+YFyVztF/5VorhBcVXRrszMWS4DscJ12CMcJh5v/+LLWhcxEriyK7CrFCQDyWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764693; c=relaxed/simple;
	bh=FyH55BMYbGrv8HcLmuHvOdnASara61BhkuyQEwsCI7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LN3piB8/pUiFDyYPgBi9qPfXuf/c757qhw4Rcd8JddoCTbB2aAwbbmbd02Dq5TG2ZJ/hL1GImD7e1dQruMkSiEGosp2Dw7VK3DvmygQQ7oZpPfipVEc00efN2xpW5GBtkCxNrMRh1OL54Z1MAutmWalzefyKLcMfiPLrG4qZqmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSEI9Az5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSEI9Az5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5DDC4CED1;
	Wed,  5 Feb 2025 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764693;
	bh=FyH55BMYbGrv8HcLmuHvOdnASara61BhkuyQEwsCI7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSEI9Az59mH6oVv6oCXN+7+HyrQqvG9C2IBrv7TNdEQ12dz89agDz61aEZ13v+T7w
	 YMK1jIvEbgeg2ITAHbHLZIhzVicW0q+VjNFPYn4FQhKKHXWgfy/LjVzXgpKeMSN0jE
	 KQ2IMbtQtaUiXkqNU4xY4gGornw3S5iA9fSSyAvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/393] perf machine: Dont ignore _etext when not a text symbol
Date: Wed,  5 Feb 2025 14:41:34 +0100
Message-ID: <20250205134426.990638038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7a93786c306296f15e728b1dbd949a319e4e3d19 ]

Depending on how vmlinux.lds is written, _etext might be the very first
data symbol instead of the very last text symbol.

Don't require it to be a text symbol, accept any symbol type.

Comitter notes:

See the first Link for further discussion, but it all boils down to
this:

 ---
  # grep -e _stext -e _etext -e _edata /proc/kallsyms
  c0000000 T _stext
  c08b8000 D _etext

  So there is no _edata and _etext is not text

  $ ppc-linux-objdump -x vmlinux | grep -e _stext -e _etext -e _edata
  c0000000 g       .head.text	00000000 _stext
  c08b8000 g       .rodata	00000000 _etext
  c1378000 g       .sbss	00000000 _edata
 ---

Fixes: ed9adb2035b5be58 ("perf machine: Read also the end of the kernel")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/r/b3ee1994d95257cb7f2de037c5030ba7d1bed404.1736327613.git.christophe.leroy@csgroup.eu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7c6874804660e..e2a6facd1c4e2 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1217,7 +1217,7 @@ static int machine__get_running_kernel_start(struct machine *machine,
 
 	err = kallsyms__get_symbol_start(filename, "_edata", &addr);
 	if (err)
-		err = kallsyms__get_function_start(filename, "_etext", &addr);
+		err = kallsyms__get_symbol_start(filename, "_etext", &addr);
 	if (!err)
 		*end = addr;
 
-- 
2.39.5



