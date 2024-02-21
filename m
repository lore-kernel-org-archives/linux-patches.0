Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E112D7CF08;
	Wed, 21 Feb 2024 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523378; cv=none; b=p5N7MP9y45Gb8jC07sZRMDbtU91tcOLiFTEFP17Jv7MoeGdBwCNQdBUX/juRBJ0b5h1r5YTo6tY5BvpXBBc//BnvTVFWOB7cALAnsGttQnw6v+ARC+o2QFr8wfP7AIpPeeaUzMgkDUT5gUsQ4S4VN7m0jiYMtpQ9lTxsHKFwmWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523378; c=relaxed/simple;
	bh=LmYXUH1Fvs9wRH3PZ0fllRKVSAQ9N/B8o2cNIHi7GqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKY43GYRxCKmb3R4H/cP0V91dKIoix+dmrkDECez/X5cWfcecBaYmejk82tOU1/0SLskDQRkQTwTIkrWQYKrVuDRgNdgeCYBRfhhfJMRAqepIPxLFRpkN6I6FJQB9xVcD801TTjo17D+elg1NmZWMqkQNVNJ3ABHA/tnANI6Fh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/c3ypFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/c3ypFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E321C433C7;
	Wed, 21 Feb 2024 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523375;
	bh=LmYXUH1Fvs9wRH3PZ0fllRKVSAQ9N/B8o2cNIHi7GqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/c3ypFaMBlXBy22ujcdYO1rDk6aAAXVMtd/IF7Q+MK5xpWiwRQ7KxcbOXLKpaLI8
	 BQuKep5QlZMs3eGpJAHdTbhZY7f+XY19oyT1AuZ21h4dKcY9m2FP4Yx6f5lctj2m3F
	 L+4H1Y27cxNlXoLlo4YT2u7iDGoIHXZTzRa+mgFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 416/476] s390/qeth: Fix potential loss of L3-IP@ in case of network issues
Date: Wed, 21 Feb 2024 14:07:47 +0100
Message-ID: <20240221130023.394103906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,9 +254,10 @@ static void qeth_l3_clear_ip_htable(stru
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
@@ -277,9 +278,11 @@ static void qeth_l3_recover_ip(struct qe
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


