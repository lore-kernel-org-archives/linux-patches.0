Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D511419B4;
	Tue, 27 Feb 2024 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041496; cv=none; b=lSOF1+8ItkrNzRHlUnha1aR4kxrvLMpGfew+Mzn959BA3d8I5LAlv4v/BTiyo7lzFwYDtf2oIqSXpOPBqAdfcrYNPCJiTIwMX0PlGhPgmJ/cY5ywtU5kHASJaNcBIUEoJaUDVv189j1zwlA6GZwSzyXxCV5UN+ScE4LEI4xHcCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041496; c=relaxed/simple;
	bh=iNm2DNs9hRjTYiYbyz4+IPAbYhShYGOwdKWpS/o0Buo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bafSQXR8+NXlsLMUzQuRmpmXOULVBkLnyciFTrtiLcK866D7E4c/hRr4E6Wx33uEP5I48oKwAMBdjrgV3TvTZvvF3feUFQ1cicUltlb90ltuqD7za3bEHi6QjTDFh3hAB0qsD5/w1OsgPL7giX6jji8LwVZpgbzl2+koLpFYiLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh0W0KFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh0W0KFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02566C43390;
	Tue, 27 Feb 2024 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041496;
	bh=iNm2DNs9hRjTYiYbyz4+IPAbYhShYGOwdKWpS/o0Buo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh0W0KFsXwSAmGOnSjXqk+vxfuvYUIyhIBozOu3yR7fMdjXHcVFfE7/NtJl2a5u97
	 JygOE1cYAUdiHPKnKGrYqBetRQPnIMExlQ4jVuLNtMzd/XsJJXsxrcsfvhb1v0DkQl
	 O+PwY9Ge0CpTptMTeFuY9LQH7pQZiM5PGZUov3Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/52] s390/qeth: Fix potential loss of L3-IP@ in case of network issues
Date: Tue, 27 Feb 2024 14:26:12 +0100
Message-ID: <20240227131549.358561388@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 2fe8a236436fe40d8d26a1af8d150fc80f04ee1a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l3_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 52e0ae4dc7241..e9102359e3134 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -285,9 +285,10 @@ static void qeth_l3_clear_ip_htable(struct qeth_card *card, int recover)
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
 
 	spin_unlock_bh(&card->ip_lock);
@@ -325,11 +326,13 @@ static void qeth_l3_recover_ip(struct qeth_card *card)
 			} else
 				rc = qeth_l3_register_addr_entry(card, addr);
 
-			if (!rc) {
+			if (!rc || rc == -EADDRINUSE || rc == -ENETDOWN) {
+				/* keep it in the records */
 				addr->disp_flag = QETH_DISP_ADDR_DO_NOTHING;
 				if (addr->ref_counter < 1)
 					qeth_l3_delete_ip(card, addr);
 			} else {
+				/* bad address */
 				hash_del(&addr->hnode);
 				kfree(addr);
 			}
-- 
2.43.0



