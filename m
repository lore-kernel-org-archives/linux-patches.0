Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810DE151CDC;
	Tue, 20 Feb 2024 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464045; cv=none; b=IS8AgFN+AdQJdfQIw2Tw6evWcWpDEPEGDFuxNXcLp0wXNVF1XRS1IJF76O+XmIqihQKQ7rNU338Q3V6Z/pkqHEMI50Ngj29Sl54r03iU1VxktrvN6yiFl/W7ChVLRwibJcImZac9Z+z5/S5WogIKa+6vhes3gWHN3jPR7ALfKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464045; c=relaxed/simple;
	bh=v8WPpqGBDSY3hXm8GFiD6MO1qUjQCPxvy6A4y6AMytI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPqrmv6LHnjkc28whf8Dj3y/nHWeSz+lSYJMKh0zqBBsauD6Kp0TXflej4ZFJs7hDrQ/ROvOrI7artENV8HMGvo8vvGBF0OrXenFXu2h8CaEtkLs+kMDlLdY8J6S+Cqwiqz2/ak3XDBcTrbbI5277usyF7bMUL/1PQU+OFNlLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKcv/7YT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKcv/7YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1438C43394;
	Tue, 20 Feb 2024 21:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464045;
	bh=v8WPpqGBDSY3hXm8GFiD6MO1qUjQCPxvy6A4y6AMytI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKcv/7YTiKwt5b8UtGtlcKrnUif5OjiH/OFZqjvoVonC467OZSTQxVv7YgkklQbOs
	 9edIWwht2svOtBKnf3EWTuhQD2qM6wJRQYrLfAugkBI4LnhM34+aLv+DYZ1CesehDe
	 gdOjGvmHXhjObFjMLHdc4LlcW8ttIUwouhVULFt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 234/331] s390/qeth: Fix potential loss of L3-IP@ in case of network issues
Date: Tue, 20 Feb 2024 21:55:50 +0100
Message-ID: <20240220205645.141536537@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -255,9 +255,10 @@ static void qeth_l3_clear_ip_htable(stru
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
@@ -278,9 +279,11 @@ static void qeth_l3_recover_ip(struct qe
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


