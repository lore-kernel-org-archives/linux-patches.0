Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5C21F7060;
	Tue, 21 Jan 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482315; cv=none; b=MDU9yhhtM1ZuhK/xaab4iNSAa/2GYzslH89ml1dbnRpglWmazRS6md7gu2vdGPUlO3AnhjQglx2Mw5bxOKgW888Y0GDpvUiPA0MO30Ch0cE6ky/VvnAFWfGTT3TLd39My/SM03snUexHlVm+zPksVTujKX2KdLdEI5vc033WJBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482315; c=relaxed/simple;
	bh=81X0MaPb3j4/zKTRp34ftpbW/v8mWeKCuiY/zvzbMK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPTquANQYIWdWvoRygG4l7wgAkKi/xDDMQVQwTGS6hNH3UNhP2H6qIxZatzC5adVLFGlrEdPq8LNW0ylycG9aprbHtzoqBW48kVIKTy3w1jwEy8w0i+Ll+SSHwhqCxLtgeTwgbPbxjJ/vDNkz/IhKxu+PRtO/oB+VfkBejoZ02Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHQ1wU0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHQ1wU0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66D8C4CEDF;
	Tue, 21 Jan 2025 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482315;
	bh=81X0MaPb3j4/zKTRp34ftpbW/v8mWeKCuiY/zvzbMK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHQ1wU0TsWwL+xkeY4Q5/araemgXH8sBHqNlfbafOR9IIQ3Tc+E0mjO93U8HXPA4k
	 OPJNzD0FDBYepiDgzzpo0lkqjN5fpRTnbTMlLarJwDVdN0aAtGZUJqBDMtlyVeblYm
	 9/O1OqrhAV0cfw6xF0p3NsoWbZDq9eE3gcu7e/10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/122] pktgen: Avoid out-of-bounds access in get_imix_entries
Date: Tue, 21 Jan 2025 18:50:55 +0100
Message-ID: <20250121174533.275569114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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
index 34f68ef74b8f2..b6db4910359bb 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -851,6 +851,9 @@ static ssize_t get_imix_entries(const char __user *buffer,
 		unsigned long weight;
 		unsigned long size;
 
+		if (pkt_dev->n_imix_entries >= MAX_IMIX_ENTRIES)
+			return -E2BIG;
+
 		len = num_arg(&buffer[i], max_digits, &size);
 		if (len < 0)
 			return len;
@@ -880,9 +883,6 @@ static ssize_t get_imix_entries(const char __user *buffer,
 
 		i++;
 		pkt_dev->n_imix_entries++;
-
-		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
-			return -E2BIG;
 	} while (c == ' ');
 
 	return i;
-- 
2.39.5



