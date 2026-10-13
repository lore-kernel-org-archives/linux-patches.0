Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3567F35E1D5;
	Tue, 13 Oct 2026 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895298; cv=none; b=mCveGHw4w3kFtYTgQQoxp18rcjKvLa5SbxNDesipo6UwBUEXUT8n/choxCPcFrsvkFtZnNq0hJXh9iA8C3LAMJD/5/ipHNmaVX+L3bNVHWt08GfI5ReEkuh8lewCEVOWlfAAhDmbNNa2y/CY7vQiT/sETc+cdPGEzNIQO19oV00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895298; c=relaxed/simple;
	bh=lqKDOIyRk/oZ91YZwQnU5v/lkf+rfzmyX77HnaFKncw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/ftsSGliFEIoQTxBuKgu8HF2UNwjfE3S2ZTSpeySyIYuDVIEECyK2xy0ZDSs9d27CIVynFYZELgsmwJbBc/nt63lzGg8060LPCd+RrZi3hsZ6VGBfqiyRhbGLCBPN0FV1JO2zRdCFpyc5oteN5scG/EZWCYB7Tx63V9VboM6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aVDktUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aVDktUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F071F000FF;
	Tue, 13 Oct 2026 12:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895297;
	bh=SebWFpCOxbyeiPrsFktG2cNskEUu3FDAfsjDpN5oSEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aVDktURvbQxdKBNc1Ahe5q4M08sdc98gNOFtGfIWods6oBZPCnj3MvKzABJR3l/w
	 k3Xuw1dRoaV/y1+85VrcDc9POWJbWHRbLVKbDt/4Oc8Zc8ICaLmTG3CElk44yGSHyD
	 BzUCKz3qpBLjK6dMuaAt8JkgMbmgRsn26NrQGd6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 183/497] Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems
Date: Tue, 13 Oct 2026 13:35:50 +0200
Message-ID: <20261013112912.232541487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 74847177eca5638827ab74cdf77f0b10fc40ca6c upstream.

On 64-bit systems, outgoing BR/EDR connections always fall back to page
scan repetition mode R2 with no clock offset once the system has been
up for more than five minutes, even when inquiry found the peer only
seconds earlier. This lengthens paging and can increase the risk of a
Page Timeout.

The inquiry cache stores jiffies in __u32 timestamps, but its age
helpers subtract them from unsigned long jiffies. INITIAL_JIFFIES casts
-300 * HZ through unsigned int, so jiffies crosses 2^32 five minutes
after boot on 64-bit systems. Assigning it to __u32 then drops the upper
32 bits. In one trace, a 7.6-second-old entry (HZ=1000) was reported as
2^32 + 7620 ticks old and rejected by hci_acl_create_conn_sync().
hci_inquiry() is affected by the same truncation when checking the whole
cache. 32-bit systems are unaffected because unsigned long is 32 bits
wide there.

Use unsigned long for both timestamps so they have the same width as
jiffies on 32-bit and 64-bit systems, and update the debugfs format
specifier accordingly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    4 ++--
 net/bluetooth/hci_debugfs.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -64,7 +64,7 @@ struct inquiry_entry {
 		NAME_PENDING,
 		NAME_KNOWN,
 	} name_state;
-	__u32			timestamp;
+	unsigned long		timestamp;
 	struct inquiry_data	data;
 };
 
@@ -80,7 +80,7 @@ struct discovery_state {
 	struct list_head	all;	/* All devices found during inquiry */
 	struct list_head	unknown;	/* Name state not known */
 	struct list_head	resolve;	/* Name needs to be resolved */
-	__u32			timestamp;
+	unsigned long		timestamp;
 	bdaddr_t		last_adv_addr;
 	u8			last_adv_addr_type;
 	s8			last_adv_rssi;
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -367,7 +367,7 @@ static int inquiry_cache_show(struct seq
 
 	list_for_each_entry(e, &cache->all, all) {
 		struct inquiry_data *data = &e->data;
-		seq_printf(f, "%pMR %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %u\n",
+		seq_printf(f, "%pMR %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %lu\n",
 			   &data->bdaddr,
 			   data->pscan_rep_mode, data->pscan_period_mode,
 			   data->pscan_mode, data->dev_class[2],


