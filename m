Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725E1F7060;
	Tue, 21 Jan 2025 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482997; cv=none; b=ll7jnNU6pqmRB3NRcIUeBzyS9YpCQP09jzj//g61yLSbwk4szo4tEqB06YppeE+fStfu22wH6CULhuB70aWG1sxgMBrDk6DvLBuvPR0Of59zAeZA3q55NkySjO+kWuzQJMnA6kzOsREO8/yzx+0AFN3AwZl0PiZCC096LsJaDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482997; c=relaxed/simple;
	bh=HwHU/jR5YPPAvD+mMxKEMawjuWUzBXhBSt05Vcko4Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2SdDP02mGBWsGx6DNffXA4Np29RqcSjneXeprBengWlssSwmEiFP8+d+Z6gtxeatQAPzEynu2nmmI/5Y55eZKyspNSySD4r5p3dc02iU5y0UogJ1L2mUkx+h4Mb4nmal+18FzU230VBfekc0qaCS8Gb4kVPAZdAMuVssRRglKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSaIUVhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSaIUVhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE64C4CEDF;
	Tue, 21 Jan 2025 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482997;
	bh=HwHU/jR5YPPAvD+mMxKEMawjuWUzBXhBSt05Vcko4Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSaIUVhQPMsLmsSxB5O+pjz0mIBi9SmVZ2UUB7/o6fED34OH35RS1cpnAGNjFbmo5
	 X0tNeBElanJQB0eyvo1ATEgo1fEc1svD4z0Mc3/UMnuiInzUVeZe/G132Bue/Hg/GA
	 gMyv36eJNCEK/0xXxBbYMNnMDL3SFy/oUD+v39v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/127] pktgen: Avoid out-of-bounds access in get_imix_entries
Date: Tue, 21 Jan 2025 18:52:33 +0100
Message-ID: <20250121174532.777668928@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Chernyshev <artem.chernyshev@red-soft.ru>

[ Upstream commit 76201b5979768500bca362871db66d77cb4c225e ]

Passing a sufficient amount of imix entries leads to invalid access to the
pkt_dev->imix_entries array because of the incorrect boundary check.

UBSAN: array-index-out-of-bounds in net/core/pktgen.c:874:24
index 20 is out of range for type 'imix_pkt [20]'
CPU: 2 PID: 1210 Comm: bash Not tainted 6.10.0-rc1 #121
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
<TASK>
dump_stack_lvl lib/dump_stack.c:117
__ubsan_handle_out_of_bounds lib/ubsan.c:429
get_imix_entries net/core/pktgen.c:874
pktgen_if_write net/core/pktgen.c:1063
pde_write fs/proc/inode.c:334
proc_reg_write fs/proc/inode.c:346
vfs_write fs/read_write.c:593
ksys_write fs/read_write.c:644
do_syscall_64 arch/x86/entry/common.c:83
entry_SYSCALL_64_after_hwframe arch/x86/entry/entry_64.S:130

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 52a62f8603f9 ("pktgen: Parse internet mix (imix) input")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
[ fp: allow to fill the array completely; minor changelog cleanup ]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a539f26fe4bea..5d5f03471eb0c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -849,6 +849,9 @@ static ssize_t get_imix_entries(const char __user *buffer,
 		unsigned long weight;
 		unsigned long size;
 
+		if (pkt_dev->n_imix_entries >= MAX_IMIX_ENTRIES)
+			return -E2BIG;
+
 		len = num_arg(&buffer[i], max_digits, &size);
 		if (len < 0)
 			return len;
@@ -878,9 +881,6 @@ static ssize_t get_imix_entries(const char __user *buffer,
 
 		i++;
 		pkt_dev->n_imix_entries++;
-
-		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
-			return -E2BIG;
 	} while (c == ' ');
 
 	return i;
-- 
2.39.5



