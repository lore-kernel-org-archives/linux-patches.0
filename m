Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AC126B080;
	Thu, 13 Feb 2025 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458873; cv=none; b=Z5mRK2ZaVcEtsz7T/Tr1Z4JwwWNpByy+28W49F8eEi4GE+mxuSeNojM3nTa+sMDlVzBHThqDRNyNN6EFf73f/L1KC4OFfsXlZ17O7KjeJYNXwNHmF7uUZjWrmoEvBlVIWo2T1tSG76Z8UkRQT1TRfXoOyL1rM5dOlqnnK3RmvSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458873; c=relaxed/simple;
	bh=JRkt8O4u406mgwlmt08gadygiT1J8QMYCtgvR48L7HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbdxGmTAQ3/pFn4r2nmne6xBp2qFQoevOXApeQ8RsnxyLU9QJa5c3j1aiYmWpuEsrhoKTfigke0d8FZSnFAfFYXLQQ2S0PLA+dytlbnstiojveMUyXnIqIzqDvdalpV5Bqb0HZGrsYh27tyBXceRHuYpvh1AzFjjhsuA5mVy/ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvcfO3Na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvcfO3Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26684C4CEE4;
	Thu, 13 Feb 2025 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458872;
	bh=JRkt8O4u406mgwlmt08gadygiT1J8QMYCtgvR48L7HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvcfO3NajBK1iV1jdI1ZqFhCgcA73cNir9HiGQSDdrhq4aJh1N7Rrz6RetGCN8kuk
	 FizoEZvQYX//4rw7xZr4955LoBzxdDWP+9aCx0BFHqeDx+YfJwXfuJV2bT7Aab1pol
	 SnZARJjTU0PB+lwVwPVFAJV5slYTmEQSpsh+7/lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Stefan=20D=C3=B6singer?= <stefan@codeweavers.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/443] wifi: brcmfmac: Check the return value of of_property_read_string_index()
Date: Thu, 13 Feb 2025 15:23:55 +0100
Message-ID: <20250213142443.318266242@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Dösinger <stefan@codeweavers.com>

[ Upstream commit 082d9e263af8de68f0c34f67b251818205160f6e ]

Somewhen between 6.10 and 6.11 the driver started to crash on my
MacBookPro14,3. The property doesn't exist and 'tmp' remains
uninitialized, so we pass a random pointer to devm_kstrdup().

The crash I am getting looks like this:

BUG: unable to handle page fault for address: 00007f033c669379
PF: supervisor read access in kernel mode
PF: error_code(0x0001) - permissions violation
PGD 8000000101341067 P4D 8000000101341067 PUD 101340067 PMD 1013bb067 PTE 800000010aee9025
Oops: Oops: 0001 [#1] SMP PTI
CPU: 4 UID: 0 PID: 827 Comm: (udev-worker) Not tainted 6.11.8-gentoo #1
Hardware name: Apple Inc. MacBookPro14,3/Mac-551B86E5744E2388, BIOS 529.140.2.0.0 06/23/2024
RIP: 0010:strlen+0x4/0x30
Code: f7 75 ec 31 c0 c3 cc cc cc cc 48 89 f8 c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <80> 3f 00 74 14 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3 cc
RSP: 0018:ffffb4aac0683ad8 EFLAGS: 00010202
RAX: 00000000ffffffea RBX: 00007f033c669379 RCX: 0000000000000001
RDX: 0000000000000cc0 RSI: 00007f033c669379 RDI: 00007f033c669379
RBP: 00000000ffffffea R08: 0000000000000000 R09: 00000000c0ba916a
R10: ffffffffffffffff R11: ffffffffb61ea260 R12: ffff91f7815b50c8
R13: 0000000000000cc0 R14: ffff91fafefffe30 R15: ffffb4aac0683b30
FS:  00007f033ccbe8c0(0000) GS:ffff91faeed00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f033c669379 CR3: 0000000107b1e004 CR4: 00000000003706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? __die+0x23/0x70
 ? page_fault_oops+0x149/0x4c0
 ? raw_spin_rq_lock_nested+0xe/0x20
 ? sched_balance_newidle+0x22b/0x3c0
 ? update_load_avg+0x78/0x770
 ? exc_page_fault+0x6f/0x150
 ? asm_exc_page_fault+0x26/0x30
 ? __pfx_pci_conf1_write+0x10/0x10
 ? strlen+0x4/0x30
 devm_kstrdup+0x25/0x70
 brcmf_of_probe+0x273/0x350 [brcmfmac]

Signed-off-by: Stefan Dösinger <stefan@codeweavers.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20250106170958.3595-1-stefan@codeweavers.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index c1f18e2fe540d..1681ad00f82ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -99,13 +99,13 @@ int brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root && err) {
-		char *board_type;
+		char *board_type = NULL;
 		const char *tmp;
 
-		of_property_read_string_index(root, "compatible", 0, &tmp);
-
 		/* get rid of '/' in the compatible string to be able to find the FW */
-		board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
+		if (!of_property_read_string_index(root, "compatible", 0, &tmp))
+			board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
+
 		if (!board_type) {
 			of_node_put(root);
 			return 0;
-- 
2.39.5



