Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A521591E3;
	Wed,  5 Feb 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767781; cv=none; b=aDD2PO3pI4iOqHSJn2ZnXtTCp3HbH3TxpdxnkWMk0655vrgUA1rq9mlW74U6RSgLWUo4aHQqTq5KdXxLX0pmjKPoky8gcQtJ9AsUlDOVyxPPrcleTLUHNFPuBQbf87kAPr+xhDksDMbj1mQc24eL68TO6uIVwwHIF7pSn/0thR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767781; c=relaxed/simple;
	bh=ivqrBA5lrO8fGBp/rNpe06isTwXjmUacTZ9sdVsAgDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KksztnlSLpRKFyPpT2ZA75SmaKxhrvg156+7VmIu1hiRUOIHWTIgT3FcjF/h8c+Qjt+pjea5/UDEP4ZjpKwZ5if8m/bjSMRWbL/XAGvfoGlnkQbeLw+qrjgd13p5X8bXgkA/Thn4qk/rBpnZmpQh2RwkgjBQQzU9pyJQwWian/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iui0XF0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iui0XF0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB1BC4CED1;
	Wed,  5 Feb 2025 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767781;
	bh=ivqrBA5lrO8fGBp/rNpe06isTwXjmUacTZ9sdVsAgDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iui0XF0bVbRTueUDgGXvi7h4KRDfYwEtWLhwZOc3O2UZOqBHwpfFcXyjars5eGF3o
	 uqPcw4wv/TyOHK9186rihb7l1LuSTr6VoKYdB6Mo7z3aGSkOrdFm7S/ivBv9wbf1cD
	 1Rgbta0KZf94Ncpg9AofpHr12Ye0yOddnhlNOPnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 508/590] perf test: Skip syscall enum test if no landlock syscall
Date: Wed,  5 Feb 2025 14:44:23 +0100
Message-ID: <20250205134514.702835585@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit 72d81e10628be6a948463259cbb6d3b670b20054 ]

The perf trace enum augmentation test specifically targets landlock_
add_rule syscall but IIUC it's an optional and can be opt-out by a
kernel config.

Currently trace_landlock() runs `perf test -w landlock` before the
actual testing to check the availability but it's not enough since the
workload always returns 0.  Instead it could check if perf trace output
has 'landlock' string.

Fixes: d66763fed30f0bd8c ("perf test trace_btf_enum: Add regression test for the BTF augmentation of enums in 'perf trace'")
Reviewed-by: Howard Chu <howardchu95@gmail.com>
Link: https://lore.kernel.org/r/20250128170629.1251574-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/trace_btf_enum.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/trace_btf_enum.sh b/tools/perf/tests/shell/trace_btf_enum.sh
index 5a3b8a5a9b5cf..8d1e6bbeac906 100755
--- a/tools/perf/tests/shell/trace_btf_enum.sh
+++ b/tools/perf/tests/shell/trace_btf_enum.sh
@@ -26,8 +26,12 @@ check_vmlinux() {
 trace_landlock() {
   echo "Tracing syscall ${syscall}"
 
-  # test flight just to see if landlock_add_rule and libbpf are available
-  $TESTPROG
+  # test flight just to see if landlock_add_rule is available
+  if ! perf trace $TESTPROG 2>&1 | grep -q landlock
+  then
+    echo "No landlock system call found, skipping to non-syscall tracing."
+    return
+  fi
 
   if perf trace -e $syscall $TESTPROG 2>&1 | \
      grep -q -E ".*landlock_add_rule\(ruleset_fd: 11, rule_type: (LANDLOCK_RULE_PATH_BENEATH|LANDLOCK_RULE_NET_PORT), rule_attr: 0x[a-f0-9]+, flags: 45\) = -1.*"
-- 
2.39.5



