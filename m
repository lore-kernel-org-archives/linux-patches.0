Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894913B2B4;
	Tue, 27 Feb 2024 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043777; cv=none; b=SCcsZjK67aqXjfcsgfTz4iPu9SWGSmGp9HkMXMME/R01kaY+zxx1ZNPfGcOZOEtr2rAOsXIswP5qlrlEJo9kGtYIkOOkQYHR2xUTUBK9TZKCfNgCUAOlP3FE2nlC7W0aw4DdtFG1O5Zojr697C6ojPng3U9P+1nLhdJ7BNO0zNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043777; c=relaxed/simple;
	bh=fS2rH83bn/glDJPmN1QTSs4fmObRZsHsiGdkQWGKksQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti9Eu4T9CpZ/yOSgz5LgV2YYBzMsZJqWF2BpaxskrWYrN5JewEwANtlsZ1ouTEgVcs8u1oNJWW+xNYcdciaoqi8iHskD1+vB5sd3c9/QUvZjRlYxAOcHKw/HPkAOl6GfHMDzNZBA4Vqi12K1rTOgyt1HDSI1T9N8AFlMdu/zPtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2eoUUE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2eoUUE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC648C433F1;
	Tue, 27 Feb 2024 14:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043777;
	bh=fS2rH83bn/glDJPmN1QTSs4fmObRZsHsiGdkQWGKksQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2eoUUE8alSziOkwP156l/XsqU0UdKWV6r3VFTZPDL2Uf6EElKw5QBN6rZn7yZciF
	 J2+fxTq32nnIaRoDdaT2YNdy+3FpGBTeJMNB3b9lfkPXSGgez5UFpXNyVtSU6X/Azn
	 BbDml09QVUFCQzTLjiUx646jgg4vXAhVSN1TQi+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/84] s390/qeth: Fix potential loss of L3-IP@ in case of network issues
Date: Tue, 27 Feb 2024 14:26:59 +0100
Message-ID: <20240227131553.909225821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8dee16aca421f..fe2bea2409427 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -305,9 +305,10 @@ static void qeth_l3_clear_ip_htable(struct qeth_card *card, int recover)
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
@@ -335,11 +336,13 @@ static void qeth_l3_recover_ip(struct qeth_card *card)
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



