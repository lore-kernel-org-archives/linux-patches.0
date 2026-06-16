Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EDC32ED55;
	Tue, 16 Jun 2026 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631084; cv=none; b=M73s12+DPdqIFThS/2ve55leMcBlTmy6Pxf31ya97hnAhalrNNhkQUuqTT4VFpbZB4Qu6gA4GOzX/7c+gra8akb62RWBG5Ca5J6+SOpFJnYQoaqxqJiEHErUBoOuLvM4i/q3SKmSGzzb4x7R4mJQwq0K2VUPgKGEhpUUYDWO0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631084; c=relaxed/simple;
	bh=9oywh7t1eZDZ88qVBT4naegnrvvMe+YdMXVG4EP8UUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE6qGZgkG+8eU+A649/fuSWP6mEtzRYKGaAr1zSarNjouWG46iYJWQoU5LQkoFGc9rvF3s36BgUKKJZ+/0RRJbx3QCG/UUHsoPifwGmPB55JJghwxd9qM2ltXWe7EOBYwqQ+BO6FSk8eSTw7sWmQzzS4uVhiEkTLQalp+T5047M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCCasX/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCCasX/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227E1F000E9;
	Tue, 16 Jun 2026 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631083;
	bh=CvQppVqFFLpRSiOwdDWiNHMDpjr9loRKml3Gl+2chCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCCasX/pezskqSD9snBVSoTqZOvhrAYjakUThmGLz5+E8d5NfVhwtPjLSMfAr0APP
	 XI2WW+Kce5E1JdDxgDTwgn9FpdKpKnFkVCw17BFd1n2o59PDI3xK4JYyONLcsK+tGF
	 eZdaHmtMXcJxMTmADt9ALOMWyD4ckXLTdmSU75lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 154/522] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Tue, 16 Jun 2026 20:25:01 +0530
Message-ID: <20260616145133.301308809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1185,6 +1185,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


