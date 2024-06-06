Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446FC196C9F;
	Thu,  6 Jun 2024 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682977; cv=none; b=UtdNrzTjUiFCDK11+DtFFxsd8uAa+ejb/oFpLc4iDOXpxmNy2Lq3bMScm0lOuUb8BlysMLTOOIjdVFKOhXwLfnb+mfBpeuSQNFQ9wKfyRwYB/4QN1KFFRWVpcMjbB2UPTK4ppQFXP8JY9KAMiRRT6U809R6ByXEunQUHv0cT7ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682977; c=relaxed/simple;
	bh=ZekKCP6fxZKaX1JhZeO2DsDGQ0EInZBUD/dUnNNPIa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0r5PirL74ThG03hYLtrSxWlecpRcOc4jZQFfHBc9pAf8z8zEvdrCzYbW0JlTWdaYVyKODMHzYWD/GA/QuxaOcVMvZDPwY4Mp39nRAxmVBda7vKuvDjzlTnS66SYy6C2Z4a6YKMn8Kj9Qcr7iECwyIZz2Og7PFY5C2EJmVNsKgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9r71Og+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9r71Og+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AD3C2BD10;
	Thu,  6 Jun 2024 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682977;
	bh=ZekKCP6fxZKaX1JhZeO2DsDGQ0EInZBUD/dUnNNPIa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9r71Og+/7QHWjGhTFJrMNu54QiIaXLMQ7Nj8/RYhlk/DEjeg4zK5g2WTDCFjqsKF
	 4fSHgKccdHYlmcX5tP24BwNHmNeCeIFdJ9fssPU/yG7vjpqLdrBJARQGd/EaFH4t8g
	 5hl5B1BfVXoWlgw9wq+/YWFvmu0LnndbvY0kzsq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 138/374] s390/ap: Fix bind complete udev event sent after each AP bus scan
Date: Thu,  6 Jun 2024 16:01:57 +0200
Message-ID: <20240606131656.524434054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 306d6bda8f97432f9cb69b5cbd86afd3a8ca182f ]

With the mentioned commit (see the fixes tag) on every AP bus scan an
uevent "AP bus change bindings complete" is emitted.  Furthermore if an AP
device switched from one driver to another, for example by manipulating the
apmask, there was never a "bindings complete" uevent generated.

The "bindings complete" event should be sent once when all AP devices have
been bound to device drivers and again if unbind/bind actions take place
and finally all AP devices are bound again. Therefore implement this.

Fixes: 778412ab915d ("s390/ap: rearm APQNs bindings complete completion")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index cce0bafd4c926..f13837907bd5e 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -767,9 +767,9 @@ static void ap_check_bindings_complete(void)
 		if (bound == apqns) {
 			if (!completion_done(&ap_apqn_bindings_complete)) {
 				complete_all(&ap_apqn_bindings_complete);
+				ap_send_bindings_complete_uevent();
 				pr_debug("%s all apqn bindings complete\n", __func__);
 			}
-			ap_send_bindings_complete_uevent();
 		}
 	}
 }
@@ -929,6 +929,12 @@ static int ap_device_probe(struct device *dev)
 			goto out;
 	}
 
+	/*
+	 * Rearm the bindings complete completion to trigger
+	 * bindings complete when all devices are bound again
+	 */
+	reinit_completion(&ap_apqn_bindings_complete);
+
 	/* Add queue/card to list of active queues/cards */
 	spin_lock_bh(&ap_queues_lock);
 	if (is_queue_dev(dev))
-- 
2.43.0



