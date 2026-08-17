Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B315E5BB;
	Mon, 17 Aug 2026 14:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976621; cv=none; b=jVwiuYqJ6hUMKkQOMzLNye+gcf5+8kJLjYK/5EME/HaQYvyz+p8x8RqAF6QmGAFwfvlKh5Jl1N2VN4PtOk0qjh4Cfy5EqrxPrR/QGWTvjKNNN2cx5U64WCAsjHjgmIfr+wlCx/qQaHB3MmY6kyboPpS8FvvZ/oysqyQtSpmHMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976621; c=relaxed/simple;
	bh=WhulW5M1EFJiW22gbVWUQnEmYrsOzu8fR+MdiNwPKik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+dh80fF/pCBET8/NUv0gzaHDv5ZycXw2LZi0UG3QXnARfirRzWV+8csMyIjEDLge2dDgbJfPFqlmZvIX1UWRxwvGVn8aogESh7un3MXwH25dFGNEndBnALRxvP5Kv/oA6ipKPQaI/NUdNzKVSRiWqUpDnUzEHWMvINYHPMW7a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Knii5dNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Knii5dNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7061A1F000E9;
	Mon, 17 Aug 2026 14:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976620;
	bh=lHQaOXj+0AZ9vTmze2YS2+R7d/cr/qWP4WkSrDcJlxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Knii5dNzj9o9IQyBHK3fHLR6irRAjLcirgZga96C5Nv41kBNFf8DhEdmZQDnjYxVQ
	 nMA7yJLV8LAjC+yNw4V0efeXwklvPOQBU57CL7eC5YioZTFtBQA5Zt6kBCik0kL570
	 uF8oH6RCy1cV26Py9etsYyX9uxnbMwLRMaMmOBQY=
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
Subject: [PATCH 5.15 045/456] Bluetooth: qca: fix NVM tag length underflow in TLV parser
Date: Mon, 17 Aug 2026 15:27:15 +0200
Message-ID: <20260817132541.802792318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25e98ce4a5af98..142d61abb137fd 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -352,7 +352,7 @@ static int qca_tlv_check_data(struct hci_dev *hdev,
 
 		idx = 0;
 		data = tlv->data;
-		while (idx < length - sizeof(struct tlv_type_nvm)) {
+		while (idx + sizeof(struct tlv_type_nvm) <= length) {
 			tlv_nvm = (struct tlv_type_nvm *)(data + idx);
 
 			tag_id = le16_to_cpu(tlv_nvm->tag_id);
-- 
2.53.0



