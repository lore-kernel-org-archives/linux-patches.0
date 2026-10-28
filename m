Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211112;
	b=1P//fAmab6r/ES9CAzxeTzBI4vk6nq8mspi2F5aX38SiV5vEosE4fsDRgldKnLJ+8Dhy
	 BmIS3eeL09kpNCOs7ZkEc9dHfSvfetU9Qkey/EcCOF5g/qLd4fZHvWh2WMUXqv63Wx/eJ
	 cduv/0J5lFAJfU6C5GrgNeEeSLMMdo7dYURUj9FCw99hIe2R8cXmmXWlYJtvBC6BJ0+3x
	 Q5HIhblYCacDJzIEQgFPv4nxNlF4gMk6T4Dr7fTEZhJKnX4cKoh8kx7zvNDrM0lrxDyoy
	 axh8455MAZiRKaA0i+zycNQGeQDx4X3rttb9dcgtM7ZfzEkJxyzxX1Mxbu6g/A4tejQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TLXZXiult/niWn8tkZie10I+ZtC9F25B877tRHvChE=;
	b=GOFmZtLLH0YYY2FwRCTGcCCjQY0qw2kurBYnGa45HcpElwG4c+XWhyTltoPNex+bVYE/
	 6wx3llfkBRHWc2eQcNDSaVDbk4LvExk6BF/0wjsVR6LNqXhlSUJy3QvJr+MApUfLTC7LO
	 398xuRViIlknRbmpHWBdgYk6iaKXWfAbpUs/khsL4em8c76XtWTRatyaJdWozhZuEx6dl
	 UfDv87x5p6Qx+D7XEsoPkMCRd/mIh6tzO2qKcJbK0QSbfbSkvgf7y5pJtRXkQOiaYCafd
	 VIfNcsJVsDIUn6JFV9hGdzPIgPXez0WdRmnAndfQcPxQE8DQwoxvi2ggQaoUZ9Vq0MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKAd98+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E1606A336;
	Wed, 28 Oct 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKAd98+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C511F01828;
	Wed, 28 Oct 2026 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211111;
	bh=2TLXZXiult/niWn8tkZie10I+ZtC9F25B877tRHvChE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKAd98+zgp02dSNEPlxeKG8yrbTY/pg0Bxu287FdfKvP5EiOA5S+tVgrReKEL/X1f
	 xXCGnCbP1VEpY8ztxMLM0o5ohek96/WU8Nm27AqDspdZyRuKwKpYGOdWvBtjBCpLeF
	 oS4SozLD0PCuVi6AHCrMOkX4SjRJFC/+8UJzOz5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 226/571] Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems
Date: Wed, 28 Oct 2026 17:56:13 +0100
Message-ID: <20261028170013.364546133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -60,7 +60,7 @@ struct inquiry_entry {
 		NAME_PENDING,
 		NAME_KNOWN,
 	} name_state;
-	__u32			timestamp;
+	unsigned long		timestamp;
 	struct inquiry_data	data;
 };
 
@@ -76,7 +76,7 @@ struct discovery_state {
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
@@ -366,7 +366,7 @@ static int inquiry_cache_show(struct seq
 
 	list_for_each_entry(e, &cache->all, all) {
 		struct inquiry_data *data = &e->data;
-		seq_printf(f, "%pMR %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %u\n",
+		seq_printf(f, "%pMR %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %lu\n",
 			   &data->bdaddr,
 			   data->pscan_rep_mode, data->pscan_period_mode,
 			   data->pscan_mode, data->dev_class[2],


