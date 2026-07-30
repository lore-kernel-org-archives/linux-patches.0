Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7DA443AAB;
	Thu, 30 Jul 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427184; cv=none; b=QxcGvBBKY96XZ8GUyJHvUlX1o7rSEzId0F3CL3rLX3y9uE0uIwrXBF2XMmITLpQnkqv7xpEbI2h2H/TQ2SHDUOcV+DHLmtTN03iMnxdfolxjf65zz7SGeX6o8pDg+DPJmvtBJkhW3IyNRo/tUmu0q3xo7ZpSaI/QYTj5b3uzbJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427184; c=relaxed/simple;
	bh=uZebe1Fn5sRc5AGJCLsR/CBaBGrfIgqE9uxTzW/1xRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCvxG7A3T9BNKVKGmfySBxv2Gj7ADaS73xAuELxR6wI4c03ChBNkBhpIKcd9wkwM3Q00f/4nGSdPTY13bmt6/LTJePRsgrfdP4hrnrtChinEYlIBHo76ikrzbzU5/OivWe3deR0CXGcxICVQqrf6fYwnKxJJCBLCC+mzD0wpiPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaXrgaYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaXrgaYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5F11F000E9;
	Thu, 30 Jul 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427183;
	bh=9xgOWq2bJ/EoNRMzx0iOAP6IuDNBBQtid+v0KNaW9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaXrgaYCqkWdSY6ycSzNI13LYDXEdIiHlC2OW86KMO01ACRcwTm86SD9e31lJsYiF
	 hoGkAOuKe4VSYNC3HxEmPok6gTmZs8W/ZjfHwpfnsmsT/OUYWZN48FAwtUpryil/cZ
	 pFTsP7ooKDY4tO5yyQcrVawWKB1nCv2F0iEicq3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johan Hovold <johan@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/484] Bluetooth: qca: fix NVM tag length underflow in TLV parser
Date: Thu, 30 Jul 2026 16:09:36 +0200
Message-ID: <20260730141425.154247548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit c90164ca0f7036942ba088eb7ea8d3f6c2352020 ]

In the TLV_TYPE_NVM branch of qca_tlv_check_data() the tag loop bound is
"while (idx < length - sizeof(struct tlv_type_nvm))". "length" is a signed
int from the firmware TLV header and sizeof(struct tlv_type_nvm) is a
size_t (12), so "length" is converted to size_t and any firmware-supplied
"length" < 12 makes the subtraction wrap to a huge value. The loop body
then reads a 12-byte struct tlv_type_nvm past the end of the short
vmalloc'd firmware buffer (and the EDL_TAG_ID_* handlers can write past it).

Rewrite the bound as "idx + sizeof(struct tlv_type_nvm) <= length"; both
operands are non-negative, so it no longer underflows and a "length" too
small for one record correctly skips the loop.

  BUG: KASAN: vmalloc-out-of-bounds in qca_download_firmware.isra.0 (drivers/bluetooth/btqca.c:421)
  Read of size 2 at addr ffffc900000e5004 by task kworker/u9:0/52
  Workqueue: hci0 hci_power_on
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   qca_download_firmware.isra.0 (drivers/bluetooth/btqca.c:421 drivers/bluetooth/btqca.c:617)
   qca_uart_setup (drivers/bluetooth/btqca.c:948)
   qca_setup (drivers/bluetooth/hci_qca.c:2029)
   hci_uart_setup (drivers/bluetooth/hci_ldisc.c:438)
   hci_dev_open_sync (net/bluetooth/hci_sync.c:5227)
   hci_power_on (net/bluetooth/hci_core.c:920)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

Fixes: 2e4edfa1e2bd ("Bluetooth: qca: add missing firmware sanity checks")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reported-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 5b34da23adce7c..09ef7df5c231bf 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -430,7 +430,7 @@ static int qca_tlv_check_data(struct hci_dev *hdev,
 
 		idx = 0;
 		data = tlv->data;
-		while (idx < length - sizeof(struct tlv_type_nvm)) {
+		while (idx + sizeof(struct tlv_type_nvm) <= length) {
 			tlv_nvm = (struct tlv_type_nvm *)(data + idx);
 
 			tag_id = le16_to_cpu(tlv_nvm->tag_id);
-- 
2.53.0



