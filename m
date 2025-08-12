Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F08A27781E;
	Tue, 12 Aug 2025 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025540; cv=none; b=hcfhl37Vl2cATgSd07Z8prTRKQNnGio4NJA/85gIFvQNTAQmo1GceYM985MwOr2+xTWlyKDFc60pwuK/5ObqN7VZ/U6/MTCUXqWgpiwN3/rbzGlZeR1Sck4WsO8hPC9ERIJLU+UFJdrhdgHCG9sxxQ7IMuRwlST5Z4tF2rTpZgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025540; c=relaxed/simple;
	bh=kqW45ayfTJ+Voa77o4ieH3kMa0masbLzxzrYQEp7uTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6o6BHQrI5651SOHgzGWwa+sBSsfk2FhvOmaeSf2njHc7Y4gzgWz9Eq/xNkQUl0Yoq+5ao6h0r0+PjiPFcifCp36NB/KJt8p6hzADSN8W6TuUDc09Iu0FhBPoP5p7GBVu8oq6lZMcia5FtG/kpvLGjFLuobRafiCXofzW5bmBxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsjmtAjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsjmtAjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8E1C4CEF0;
	Tue, 12 Aug 2025 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025537;
	bh=kqW45ayfTJ+Voa77o4ieH3kMa0masbLzxzrYQEp7uTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsjmtAjN99Epyv7PFihONu3QJVOO5i/7E4NHcnc6ZymX7wTkjRDg94BSGX4tHpKN0
	 thlhJMa/SZ9Heun1pbLIunjZ5jRYP3DyaJIGfhNYhMbPxtG8fnnEf3911BoCrydM63
	 8PDuiu1lgsY2UQtl+t4AjRar/y96DY0XEp7bMYZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 043/480] pm: cpupower: Fix printing of CORE, CPU fields in cpupower-monitor
Date: Tue, 12 Aug 2025 19:44:11 +0200
Message-ID: <20250812174359.177078132@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 14a3318b4ac8ae0ca2e1132a89de167e1030fbdb ]

After the commit 0014f65e3df0 ("pm: cpupower: remove hard-coded
topology depth values"), "cpupower monitor" output ceased to print the
CORE and the CPU fields on a multi-socket platform.

The reason for this is that the patch changed the behaviour to break
out of the switch-case after printing the PKG details, while prior to
the patch, the CORE and the CPU details would also get printed since
the "if" condition check would pass for any level whose topology depth
was lesser than that of a package.

Fix this ensuring all the details below a desired topology depth are
printed in the cpupower monitor output.

Link: https://lore.kernel.org/r/20250612122355.19629-3-gautham.shenoy@amd.com
Fixes: 0014f65e3df0 ("pm: cpupower: remove hard-coded topology depth values")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
index ad493157f826..e8b3841d5c0f 100644
--- a/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c
@@ -121,10 +121,8 @@ void print_header(int topology_depth)
 	switch (topology_depth) {
 	case TOPOLOGY_DEPTH_PKG:
 		printf(" PKG|");
-		break;
 	case TOPOLOGY_DEPTH_CORE:
 		printf("CORE|");
-		break;
 	case	TOPOLOGY_DEPTH_CPU:
 		printf(" CPU|");
 		break;
@@ -167,10 +165,8 @@ void print_results(int topology_depth, int cpu)
 	switch (topology_depth) {
 	case TOPOLOGY_DEPTH_PKG:
 		printf("%4d|", cpu_top.core_info[cpu].pkg);
-		break;
 	case TOPOLOGY_DEPTH_CORE:
 		printf("%4d|", cpu_top.core_info[cpu].core);
-		break;
 	case TOPOLOGY_DEPTH_CPU:
 		printf("%4d|", cpu_top.core_info[cpu].cpu);
 		break;
-- 
2.39.5



