Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59F4502F;
	Tue, 16 Jun 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628785; cv=none; b=uH7oS6bFICyttQhLDRBG5YxSrKNOWV+yLtjQLxSwLgNoU5Udt4RVrwNIVz1lj6SV66YY8ihbpJvGDtlO5ligb9WVH/t/PBix5NjDBL8m9a9zWceFBQCBfzrODAEOHmyGKYWY5vtQfNER3SR/zClmicHcerAEhZqtvrfGGxMzNYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628785; c=relaxed/simple;
	bh=ePOGGGUvdwO+M/P5W+yNNQ76qo/43BbBKU/dE9dhY38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXc9smINeuN2rkA+VBJ//YbIJ/LUViWwfhgjkIsdCsMLlt6skhQciqSzzl/i3TyNGoWtAyljEbUHIaDLeAI/SNkVU/VGnbxJIkMlHqUnBRRDDOlqC8J5R9COftJFB53RQMw9qDys+04OsnLyGdfUWdVej0wWXY9Exeqctr/iWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsLL4K/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsLL4K/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BF41F000E9;
	Tue, 16 Jun 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628784;
	bh=XhMymvyHan5/NBN4pgxXMdzjn46vI963lypASt1TDZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsLL4K/HgpKH+uxFmfaoslE+PZMbrbyecY0KdQmrTAdQ/z4/Q4egZT6C0FChAOZ+u
	 iqHoxhzRiB1z9W/laN1WZFF1UowdOs3n9R1U1c611ZyeHo2wZZgcg/25FEEf1w1ysV
	 9AXRiFvGQy7lz7TAcKp5KM9AILb1DPhow4fidwGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 162/452] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Tue, 16 Jun 2026 20:26:29 +0530
Message-ID: <20260616145126.297310187@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1188,6 +1188,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


