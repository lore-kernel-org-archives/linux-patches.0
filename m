Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823A61C3042;
	Mon, 14 Oct 2024 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917857; cv=none; b=aLIldD2YQWdMdZSgoC99ZJmhX+8Ixj1ZnF2/1IrWLkQFqLS66KF6jcwvf0LVLs1tFFwCa0QRE5fu3MC/01V/0a4rdlWT8w1F1jmu2/ml9ixMgpyKL6oTLrOPNllhszQbIv9NQNTDx6i2puN3fX1/3DylKuv0firASIMxn6QJHqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917857; c=relaxed/simple;
	bh=HZfl0nInJjIUvy6JUY7tAclbDQhTxnoFKLsF8Z5Sd2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Peq/iDBtydHeq8ApAq+yQMe3OLRppwql5J3PtsgyHvIyQN4FltFxiRTehTK24FAVt3fFWcNvCfkfkBxkK40NAB4ln49QWnoNgLQqOikW5a+uyAJrlyAHJUOxIwns/a6UrSw2zIQKDm7LBC7b4YTijvoDdNS61dxe38ICQCgvp80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuM0SWGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuM0SWGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40B1C4CEC3;
	Mon, 14 Oct 2024 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917857;
	bh=HZfl0nInJjIUvy6JUY7tAclbDQhTxnoFKLsF8Z5Sd2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuM0SWGpcnuPBzPBbUPTM2qcFDWHNKpfWKS2cdAjNijbRuwhVDTDKYOYQ4tKwPyHX
	 Mn4EZ3975hGF6RQPbkskgRByrKKVFykh1o/Npgzf3T4S+6UlbZwEiU45aBW6AEzkOD
	 RdV9bx4tJ0cv2Wa7+iCOOtb6BCZV9Zmf4JArJKZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/798] selftests/bpf: Fix compiling core_reloc.c with musl-libc
Date: Mon, 14 Oct 2024 16:11:48 +0200
Message-ID: <20241014141223.965548637@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit debfa4f628f271f72933bf38d581cc53cfe1def5 ]

The type 'loff_t' is a GNU extension and not exposed by the musl 'fcntl.h'
header unless _GNU_SOURCE is defined. Add this definition to fix errors
seen compiling for mips64el/musl-libc:

  In file included from tools/testing/selftests/bpf/prog_tests/core_reloc.c:4:
  ./bpf_testmod/bpf_testmod.h:10:9: error: unknown type name 'loff_t'
     10 |         loff_t off;
        |         ^~~~~~
  ./bpf_testmod/bpf_testmod.h:16:9: error: unknown type name 'loff_t'
     16 |         loff_t off;
        |         ^~~~~~

Fixes: 6bcd39d366b6 ("selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/11c3af75a7eb6bcb7ad9acfae6a6f470c572eb82.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 47f42e6801056..26019313e1fc2 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
 #include "bpf_testmod/bpf_testmod.h"
-- 
2.43.0



