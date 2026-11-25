Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626194;
	b=HvrFkgWaILuAVBoITyAOa2wP1xlh4QTOCKpWVqiSBFLcE4nah+WBnHEBUPRbBeFQzdlO
	 MC0fbXnUseTikmz73nyHLwtjCzHsU87Gl2RcWRwYdKhiinqNc2f3EqYxAMerxdg9TVmBq
	 eCKHwCKKLOApnykR+Z8/ibV1slmkXwUBAaRcFBBhCGBGzSAmJb3IW1e0OjagUiV/meC6t
	 5L5WM9crElyaZgxiJr3UK15pgqyU1HiaC4PFsGFJgXB1h303mRWbgBDC7mTdnmBYWrOzb
	 JyL0AsuKFxNYlsmeomo2z4rleLhOSvkopNNJ+M0u6M0R9g4f3K94hcHciPUrSunXqaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CVu8Ys5Blu3SwNw3ZYE0NsClCZAaAx1WjM4+Dzi5qdA=;
	b=w5QTcPasDVgca1zlzVMcBqEiJU8Sk58WWFsCWLYtlhiEG7U+Vseua7xsjp0oFsvvovCn
	 BtmmaWcEGX0w7Vsf99FAytRKWpALGhboIhNAoun+hMXkWNkHVsW9FfEEOq0pRjaqhg2Tc
	 uKPwIY5MMfFSYUPC0JPMQUtUoqZmCeRDftNA9sBh3gptxQC+YTrbo6YVqjb3y6b3gOQKL
	 myBlOcb0YktGyW1pJwp0htuxvWd+VAnP8Icxo9S5PJvtYQvPrNJdWMkHsMvLOnArdY7yS
	 3lo07A4ezwpA00J3zJqZ2kp+K8e7h+jUGFPgRSM5yaNJeRto6PORs80pnws6wj7Uaig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebfbK3Ah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0BB606A323;
	Wed, 25 Nov 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebfbK3Ah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81A51F000C6;
	Wed, 25 Nov 2026 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626194;
	bh=CVu8Ys5Blu3SwNw3ZYE0NsClCZAaAx1WjM4+Dzi5qdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebfbK3AhsTi5gMcQ82ei0h+bH8PX/LG9GpucpgTaRfa/pHMVj5laYzzSBhO1PD1FQ
	 DpTgcLCVkf1VQuFFzjefqA4BhX3AaRF3V+0CDwpipiUI2QS++oNuaNtSVP7mvl1nl3
	 bJpIpxKhmCz4uCVCHobphCqls092Hd10P8w8TuJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 6.12 764/816] w1: netlink: drop the slave after the bus is unlocked
Date: Wed, 25 Nov 2026 15:38:32 +0100
Message-ID: <20261125143906.856470962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 847fa880a3e1b2fdbbf72d89e830566108457637 upstream.

w1_process_cb() executes the commands of a netlink message with bus_mutex
held, and drops the reference to the slave which the message was
addressed to before it unlocks the mutex.  If the slave has been detached
in the meantime, this is the last reference, and w1_unref_slave() tears
the slave down on the spot.  That waits

- in device_unregister(), for the sysfs callbacks of the slave which are
  running, and

- in w1_therm_remove_slave(), for the readers which have taken a
  reference to the family data,

and both kinds take bus_mutex to talk to the slave.  Whoever is waiting
for the mutex at that moment is never going to finish, and neither is the
thread of the bus master.

Unlock the bus first.  The reference keeps the slave, and with it the
master, alive until then.

Fixes: d3a8a9dbb903 ("w1: hold bus_mutex in netlink and search")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-6-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1_netlink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -480,15 +480,17 @@ static void w1_process_cb(struct w1_mast
 	if (!cmd || err)
 		w1_netlink_queue_status(node->block, node->msg, cmd, err);
 
+	dev->priv = NULL;
+	mutex_unlock(&dev->bus_mutex);
+
 	/* ref taken in w1_search_slave or w1_search_master_id when building
-	 * the block
+	 * the block.  If it is the last one, the slave is removed, which waits
+	 * for users of the bus.
 	 */
 	if (sl)
 		w1_unref_slave(sl);
 	else
 		atomic_dec(&dev->refcnt);
-	dev->priv = NULL;
-	mutex_unlock(&dev->bus_mutex);
 
 	mutex_lock(&dev->list_mutex);
 	list_del(&async_cmd->async_entry);


