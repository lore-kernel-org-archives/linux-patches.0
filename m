Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097AE22C34C;
	Thu, 12 Dec 2024 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021543; cv=none; b=Jp3/CBCeuNdzVkOochbiEtakYzkXNK+2j4T/TFOP/h0Fu/Y/MjN7e0wsCWLQL+EtQj2lUOSXVksjSvz61NtbkJ4pGNiwq4Wd9sZcrIz/0N9R05Ez2Q2OTjjnSig03Z+h5Td2RjnFQaZpfU/tcx3NfgQYNSGfdIEJK6lYRVQWreg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021543; c=relaxed/simple;
	bh=1enGG8WQNkSOGy5lQj6WHr7h40BoVxsG+2CMJ0EUP2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKuzCUCX0GXb1/+1lhH0vP/cpu9tzWcVsf061F/XKepIeNRcR49owWVRfC2yLPd/hl4jBbQlMjo5/IV9T/0agBuo0wDipIB7yI87IDwxM+XOEd3s/QJg/jIsBb1vJO9AfLqlv0XgdmoXUPX9ZPmJSCfeOyQekj7Q9TqqRuKWBy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwLvwGYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwLvwGYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA29C4CED0;
	Thu, 12 Dec 2024 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021542;
	bh=1enGG8WQNkSOGy5lQj6WHr7h40BoVxsG+2CMJ0EUP2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwLvwGYbWdzg50Ybpa7ODNqrtgf1pR9VXDyeKossptowycG+x85zNeZlsosYVr9jA
	 U4l0s036L6+4acJQIlwFYqIj9eQBi+yvBrcGgZ7PHC6fszSV68iEuT3G20g6FfXkco
	 JIBCPtcJxKUEqS6MIcefXfrfiTcOtB5f6XuAQgUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 767/772] i3c: master: svc: fix possible assignment of the same address to two devices
Date: Thu, 12 Dec 2024 16:01:52 +0100
Message-ID: <20241212144421.628721466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1010,12 +1010,27 @@ static int svc_i3c_master_do_daa(struct
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


