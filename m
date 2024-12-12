Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6AB217F46;
	Thu, 12 Dec 2024 15:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018697; cv=none; b=uDfoEhTRWX1GN1JSIppNJ9Sfnq7IHsWyBT83GtE72+PRTJeAhUlhYr+IkmIhVUByMfJBl4qyiA1F9ykdXwIbLE4qZa2sJnkiC9lmav4yH8eeN3nsqNzY/CarKJuxOQzcnZThWBSn7CC13Gx2M7vtIUZi9BAvKsc/ru2WZND73rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018697; c=relaxed/simple;
	bh=3A1PFGGOkdvwReNfV8Qd1igdeYbtXRjhACi2BlUg6iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geJ5J49QokvLYdHynfLiIb8manaoe4gTvKnRjPBNRFdQ8HpmkW3T9yiSUmHmNiOkZQD4xtGf1izPJxP4ropg33lJBJk7maCCUfydBfRX+rDNb/3PBT1kSwJ6m8UMglLhf86uIAq5EFNKQKmxQ7PFc4GGNNfqxwj4uA+yMBaw5sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTrfYqFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTrfYqFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A054CC4CED0;
	Thu, 12 Dec 2024 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018697;
	bh=3A1PFGGOkdvwReNfV8Qd1igdeYbtXRjhACi2BlUg6iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTrfYqFItiYnoPEpLjvyOZjJlDq4cJsdb7lVZVs49sIYH88xORnjoBnCiUJnHHryH
	 z6HKYfdLs+d+KUcth1Dtd++gpuR1HwMyUvTAZN5e+01Prt+ncuABtO7CQds8ErSVLy
	 ptlTd0Fb72epEZtT/mOAwRJSNvlRN+SlAhSPzawA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 356/356] i3c: master: svc: fix possible assignment of the same address to two devices
Date: Thu, 12 Dec 2024 16:01:15 +0100
Message-ID: <20241212144258.632742181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit 3b2ac810d86eb96e882db80a3320a3848b133208 upstream.

svc_i3c_master_do_daa() {
    ...
    for (i = 0; i < dev_nb; i++) {
        ret = i3c_master_add_i3c_dev_locked(m, addrs[i]);
        if (ret)
            goto rpm_out;
    }
}

If two devices (A and B) are detected in DAA and address 0xa is assigned to
device A and 0xb to device B, a failure in i3c_master_add_i3c_dev_locked()
for device A (addr: 0xa) could prevent device B (addr: 0xb) from being
registered on the bus. The I3C stack might still consider 0xb a free
address. If a subsequent Hotjoin occurs, 0xb might be assigned to Device A,
causing both devices A and B to use the same address 0xb, violating the I3C
specification.

The return value for i3c_master_add_i3c_dev_locked() should not be checked
because subsequent steps will scan the entire I3C bus, independent of
whether i3c_master_add_i3c_dev_locked() returns success.

If device A registration fails, there is still a chance to register device
B. i3c_master_add_i3c_dev_locked() can reset DAA if a failure occurs while
retrieving device information.

Cc: stable@kernel.org
Fixes: 317bacf960a4 ("i3c: master: add enable(disable) hot join in sys entry")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241002-svc-i3c-hj-v6-6-7e6e1d3569ae@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1018,12 +1018,27 @@ static int svc_i3c_master_do_daa(struct
 		goto rpm_out;
 	}
 
-	/* Register all devices who participated to the core */
-	for (i = 0; i < dev_nb; i++) {
-		ret = i3c_master_add_i3c_dev_locked(m, addrs[i]);
-		if (ret)
-			goto rpm_out;
-	}
+	/*
+	 * Register all devices who participated to the core
+	 *
+	 * If two devices (A and B) are detected in DAA and address 0xa is assigned to
+	 * device A and 0xb to device B, a failure in i3c_master_add_i3c_dev_locked()
+	 * for device A (addr: 0xa) could prevent device B (addr: 0xb) from being
+	 * registered on the bus. The I3C stack might still consider 0xb a free
+	 * address. If a subsequent Hotjoin occurs, 0xb might be assigned to Device A,
+	 * causing both devices A and B to use the same address 0xb, violating the I3C
+	 * specification.
+	 *
+	 * The return value for i3c_master_add_i3c_dev_locked() should not be checked
+	 * because subsequent steps will scan the entire I3C bus, independent of
+	 * whether i3c_master_add_i3c_dev_locked() returns success.
+	 *
+	 * If device A registration fails, there is still a chance to register device
+	 * B. i3c_master_add_i3c_dev_locked() can reset DAA if a failure occurs while
+	 * retrieving device information.
+	 */
+	for (i = 0; i < dev_nb; i++)
+		i3c_master_add_i3c_dev_locked(m, addrs[i]);
 
 	/* Configure IBI auto-rules */
 	ret = svc_i3c_update_ibirules(master);


