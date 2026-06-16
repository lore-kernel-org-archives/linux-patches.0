Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122BF3CE4BA;
	Tue, 16 Jun 2026 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633653; cv=none; b=VKu52w+ifgeE32iFIVHV01mI3kVmBVNWuOoIouvrmsS/K2BA+dklfHosA2HmYutiMSc85ecS/4myCzN147ff5xwcx3WjjZEXEic9gx45IlAWJAcDss2m0BOBop38wk3odl1y29uDrsJ3jS8LfGHrFs4mUy8+hvn4+vMsrJcToJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633653; c=relaxed/simple;
	bh=ZFOz4wDD7dZar9Zf4FHSA5WS7vAwc9YxNNPWDCfr0qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adex3Zfx90LM/LCI3Qz/5QiNgSqYIlTNqxl4AJPwTmLMDBW2U8kIW7hj0okeqG4Q8usYpWAuyg0UXb64Fz1zUXYu9M6HmtX7sLJE4wmARkfCiPi0uC7QHsLzv0qEkrtMBbtwgMcHWjBBewB6eJK7CXEIL0wnEkFHcnJgxQKVSWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMI8lMte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMI8lMte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C277B1F000E9;
	Tue, 16 Jun 2026 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633651;
	bh=HMy+KdGiQbbeou65H2ua1JRx/fSzYg40JGn0OHSBs10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMI8lMteukFordyRciT9s5KU88IUjF0jhtFkVGtMAxePRKiputvNTMzOKwkVnT10W
	 +jslNA/7+J4ChfkJFCxOpgWvUIwHvzffUrhoCUHdck0gatEf+Dml3zPaninwHWYCux
	 uI7eySM2LnJ8xddeYz9kcluH5i9vp3+CzT70SdQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 118/411] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Tue, 16 Jun 2026 20:25:56 +0530
Message-ID: <20260616145106.580992962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

commit ab8336a7e414f018430aa1af3a46944032f7ff96 upstream.

Add the missing sanity check on the size of usa49wg indat transfers to
avoid parsing stale or uninitialised slab data.

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Cc: stable@vger.kernel.org	# 2.6.23
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1184,6 +1184,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


