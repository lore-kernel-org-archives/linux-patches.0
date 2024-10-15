Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB121C07C4;
	Tue, 15 Oct 2024 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997291; cv=none; b=DMWXTxt0Doyy3Sy3vZR35DCpBVbdFE8Cr0KobTBU+nFekIjyKDoRO6Hq9n9xQMgdZ62yr3Xhds94eWYwvvjlwSDbBOsybYyMB5tAB+w82S0rppqfOsmIZD1/smPURVLUdsb2vTxHR2Krbk5xH8rRrNAJMdy1mWvswbKf7mTqEC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997291; c=relaxed/simple;
	bh=Ak8mx7Lb9IO4HpTGFW9h4z79ad/Fba9+ZWYfYXL10ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL1vR9QSyfZRbT20HoPMbKHMANM+FVtX9TM3BzBs77RFn9XTeqimdQ2377/QXm4C+pZS4Ee1QURl6YY+ChRU4krmPgIXHKIRtIiunltuT63ReBDeFOtVkSfUxtIoTb2tpR38M6f4Me1Z8FcMaNQxaSAsDqnpWp1fMuqkbIL/xc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1xag1H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1xag1H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DA0C4CECE;
	Tue, 15 Oct 2024 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997291;
	bh=Ak8mx7Lb9IO4HpTGFW9h4z79ad/Fba9+ZWYfYXL10ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1xag1H/iUs904X/AJU+24dnRyCl1yj51JwXPVlYD/dxGFTNVvVQ2orZPNDjuKkst
	 JpkdbdGYXSoHStFtD7qT7GN9ei6wWJVdBuanXj6Bpb30SlY9WiHipQcHQ/0kdbNuHR
	 +s/cDzjnawgbuZZHYnZiug9iI4r3mdxUUgTTzb3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/518] selftests/bpf: Fix errors compiling cg_storage_multi.h with musl libc
Date: Tue, 15 Oct 2024 14:40:45 +0200
Message-ID: <20241015123922.439539529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 730561d3c08d4a327cceaabf11365958a1c00cec ]

Remove a redundant include of '<asm/types.h>', whose needed definitions are
already included (via '<linux/types.h>') in cg_storage_multi_egress_only.c,
cg_storage_multi_isolated.c, and cg_storage_multi_shared.c. This avoids
redefinition errors seen compiling for mips64el/musl-libc like:

  In file included from progs/cg_storage_multi_egress_only.c:13:
  In file included from progs/cg_storage_multi.h:6:
  In file included from /usr/mips64el-linux-gnuabi64/include/asm/types.h:23:
  /usr/include/asm-generic/int-l64.h:29:25: error: typedef redefinition with different types ('long' vs 'long long')
     29 | typedef __signed__ long __s64;
        |                         ^
  /usr/include/asm-generic/int-ll64.h:30:44: note: previous definition is here
     30 | __extension__ typedef __signed__ long long __s64;
        |                                            ^

Fixes: 9e5bd1f7633b ("selftests/bpf: Test CGROUP_STORAGE map can't be used by multiple progs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/4f4702e9f6115b7f84fea01b2326ca24c6df7ba8.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/cg_storage_multi.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cg_storage_multi.h b/tools/testing/selftests/bpf/progs/cg_storage_multi.h
index a0778fe7857a1..41d59f0ee606c 100644
--- a/tools/testing/selftests/bpf/progs/cg_storage_multi.h
+++ b/tools/testing/selftests/bpf/progs/cg_storage_multi.h
@@ -3,8 +3,6 @@
 #ifndef __PROGS_CG_STORAGE_MULTI_H
 #define __PROGS_CG_STORAGE_MULTI_H
 
-#include <asm/types.h>
-
 struct cgroup_value {
 	__u32 egress_pkts;
 	__u32 ingress_pkts;
-- 
2.43.0



