Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034D21519B4;
	Wed,  5 Feb 2025 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768384; cv=none; b=RS9LVdhfb0u2fGXDdHnHEQJLEXacafQetb/pgtqn9c2zy5Oz+b+2HN/izB+urT79rfbLCNIrH0AG4N213lzKaDOeyTz5b+3/17HbG33xX31S19YTCyc7PNpsijTNot0T8s/BQuMCuFEjGyaA7Nle6Ij62EAkCJxH3yALq88DYZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768384; c=relaxed/simple;
	bh=I7H/b2A4UTx520oCWGCC5gE6QJJIEDiyOaC1ntXQeF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNhIks6dKD2+q1xPNEUfMeE43jZfZmC6qW2zomCLzoH3GkexcmpRBGr6jybf6qER5VXcXKSEOBRqLsgSSQLLKHeHfm6gsBSLclEHlPeKo5eOSmQWoIEM/CVYphuqoGyx1EidH6mBikVYq7gShNlSeqC/oOmJuZLGkKKoLWKUXbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDHSZjCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDHSZjCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69934C4CED1;
	Wed,  5 Feb 2025 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768383;
	bh=I7H/b2A4UTx520oCWGCC5gE6QJJIEDiyOaC1ntXQeF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDHSZjCaNh/JJfgbe369AJYsHbkE23xQDiH/fbBSWZwcvWqK8bn3c4DHggkVpuXbd
	 IokRK8vb0AboEXp+yTsEOlumgzWygr33CAn7iERuZ8P2p9lQv6tWkhqQyixy4YBwul
	 9ZcSap4AUVIZxysM9vGTEYAK61wr4W8YDOCH2d+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 540/623] perf test: Skip syscall enum test if no landlock syscall
Date: Wed,  5 Feb 2025 14:44:42 +0100
Message-ID: <20250205134516.881647157@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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



