Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C57A1E9B38;
	Tue, 21 Jan 2025 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482058; cv=none; b=erfxWI7r05zat74XxghNzkJp/K3nU6OCx4/BidtA+rHR/fUu/wKLOFZ2ZBxrc1L1BPee3nAPwOYnHNewEGvSMEk785Y1B8DWsuGTxH/ZAX0exsA1CESpM6fsK5S3Ed1y6qy41R09qTrl7cd9tI4Pn0LG2nieEYT7BS5gezkhHog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482058; c=relaxed/simple;
	bh=wT1wktZcr0HOvG1o0qQ4CFMh/E4ZvfGKx1zqJMBAaNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/Cwdr9XQoh2H6bEvM/7DuylDcnb9UUfMZhf5eEh8ER3vv88ia27a0f04gUM6iKd/u6CBECNBo1ry00LSFLU+IBPk6UTIlv21lB+ZHb1VR09NzktdhP4S6jGtRpc4bRvjdNeuE5x8kIRuJFy9x6++Wc7d/zv2VpCEBOTWuIgw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upk26Mf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upk26Mf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8460C4CEDF;
	Tue, 21 Jan 2025 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482058;
	bh=wT1wktZcr0HOvG1o0qQ4CFMh/E4ZvfGKx1zqJMBAaNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upk26Mf/3LL5ow1Ab9/QsL+3loqsymaI9HhxNQM1CkD0QR64WMrvYrmqCxoBi1hCb
	 9cbNIF8pciYAN7CQBdOu3Z4pu39PZtOWLL95NkLC/1nMiOweolhs1vZ0XlDZGPAoKG
	 oByoS0TA6vXoizrfmAOwOpCYOyejYjeri/4/8rgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/72] pktgen: Avoid out-of-bounds access in get_imix_entries
Date: Tue, 21 Jan 2025 18:51:30 +0100
Message-ID: <20250121174523.602080189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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
index 0e472f6fab853..359e24c3f22ca 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -850,6 +850,9 @@ static ssize_t get_imix_entries(const char __user *buffer,
 		unsigned long weight;
 		unsigned long size;
 
+		if (pkt_dev->n_imix_entries >= MAX_IMIX_ENTRIES)
+			return -E2BIG;
+
 		len = num_arg(&buffer[i], max_digits, &size);
 		if (len < 0)
 			return len;
@@ -879,9 +882,6 @@ static ssize_t get_imix_entries(const char __user *buffer,
 
 		i++;
 		pkt_dev->n_imix_entries++;
-
-		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
-			return -E2BIG;
 	} while (c == ' ');
 
 	return i;
-- 
2.39.5



