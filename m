Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662857F7FA;
	Wed, 21 Feb 2024 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524863; cv=none; b=KCPjDgG9GO+2biglHoPkCmOWf81gsTo4QpK1MGA5XCnIWyvnWqdN06921EsqkdWJQqj4IO353/eUe5OnWliEw1iQ/XZ5EyXLxPftSxyGmUEvLNYceMMoDhzERtn0sonEN47n43nSzq0zYRRNJyvT3ial6WRSRd08g84byIDllfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524863; c=relaxed/simple;
	bh=qWLqr4i95JYBR9A9FwJnEDF6y8o3QAPW1lXLxnLCVI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoyKR++Ab5SA4DLU7EEiHW5pykKcHF6S1hPxY7ZIPH5tBIiTF7Zt6gVnv194VMypmBmZvAHiPzQ1uUY0YdAydtbLUZ0MpLlBnaFSWEnyGhPB57s41PLd5VKyChPYQ+CXLjnjIsT2WyX0Kb/i94UMyqupOtZhxi52kto26DOlRtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7WeZt1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7WeZt1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C975EC433C7;
	Wed, 21 Feb 2024 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524863;
	bh=qWLqr4i95JYBR9A9FwJnEDF6y8o3QAPW1lXLxnLCVI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7WeZt1jv2NrEtckwtu3Q9Ud6ZwJpvxG/pBK4u2D+nmU5o1YNGA7yt8OdsBSJtEqf
	 Q5FK6hLXe+taFiDWGMNeR6N7+AuCNXRbEvDZWhXN7LhmgGJpu3L+/whOu5nmcPE12U
	 QV1OzYyX3/shEYHYj2vSJW7zAb7dazAsNHcFN7XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 343/379] s390/qeth: Fix potential loss of L3-IP@ in case of network issues
Date: Wed, 21 Feb 2024 14:08:42 +0100
Message-ID: <20240221130005.135414723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

commit 2fe8a236436fe40d8d26a1af8d150fc80f04ee1a upstream.

Symptom:
In case of a bad cable connection (e.g. dirty optics) a fast sequence of
network DOWN-UP-DOWN-UP could happen. UP triggers recovery of the qeth
interface. In case of a second DOWN while recovery is still ongoing, it
can happen that the IP@ of a Layer3 qeth interface is lost and will not
be recovered by the second UP.

Problem:
When registration of IP addresses with Layer 3 qeth devices fails, (e.g.
because of bad address format) the respective IP address is deleted from
its hash-table in the driver. If registration fails because of a ENETDOWN
condition, the address should stay in the hashtable, so a subsequent
recovery can restore it.

3caa4af834df ("qeth: keep ip-address after LAN_OFFLINE failure")
fixes this for registration failures during normal operation, but not
during recovery.

Solution:
Keep L3-IP address in case of ENETDOWN in qeth_l3_recover_ip(). For
consistency with qeth_l3_add_ip() we also keep it in case of EADDRINUSE,
i.e. for some reason the card already/still has this address registered.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://lore.kernel.org/r/20240206085849.2902775-1-wintera@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_l3_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -257,9 +257,10 @@ static void qeth_l3_clear_ip_htable(stru
 		if (!recover) {
 			hash_del(&addr->hnode);
 			kfree(addr);
-			continue;
+		} else {
+			/* prepare for recovery */
+			addr->disp_flag = QETH_DISP_ADDR_ADD;
 		}
-		addr->disp_flag = QETH_DISP_ADDR_ADD;
 	}
 
 	mutex_unlock(&card->ip_lock);
@@ -280,9 +281,11 @@ static void qeth_l3_recover_ip(struct qe
 		if (addr->disp_flag == QETH_DISP_ADDR_ADD) {
 			rc = qeth_l3_register_addr_entry(card, addr);
 
-			if (!rc) {
+			if (!rc || rc == -EADDRINUSE || rc == -ENETDOWN) {
+				/* keep it in the records */
 				addr->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
 			} else {
+				/* bad address */
 				hash_del(&addr->hnode);
 				kfree(addr);
 			}


