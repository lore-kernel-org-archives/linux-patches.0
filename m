Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA7403B1E;
	Tue, 21 Jul 2026 17:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654908; cv=none; b=RIDpTzfv1Ip6nueKDPTrnIxOM0zT8pHk+cEshRms/j6phFEo8eI116TUNFZhoEOclU9RWyINfnZK7zUlAMuKCZ/xicBu5bPDxl1AuOrpNAjU21g3yqY6kLKb2xvcWB6++mvEgWWLY5G4FqJJ8MWd74kWQkgGaGipvcKyMXf+V7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654908; c=relaxed/simple;
	bh=/+9qxvhSNb6nFcQbKY44CZ2+vSl2XhrntD4weNRsgoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ0s3iI/bTsCXMlGf8/vvAzxG4Tn+8oZNXIM/YeMXGj3ZDfpiWiydsEMXIrGFoX+fHUIaJmt1L1nk45FTRBXCuDAEinr6TKGczaJ3KAYriT/g9VGHNKriX6nBNiqexX4Os3WQSW1JaNBgSYjrIslDcowHJcscOzABkn/myIQVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLhRacrZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLhRacrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE90C1F000E9;
	Tue, 21 Jul 2026 17:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654907;
	bh=2BmXnUQgsFaZmcDPx5IcciLv5KT8+HO4Bt0W3Cusqpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLhRacrZ2BA1HNXdu+z5JkVBQyNOkcJRnRxckjr1jYnkbsyzoQ/BwmYsnSAW96u/k
	 3gnCqRk6BRceJYIGSNde0XRopShR4Txr3NJoE27D4OB5i25Xi5RKNUn1ze4Z/jDhK2
	 p8JfTn3O+5gfbbL6ibZWBswPQ5vqYYAAdXG5CLxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1882/2077] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:25:55 +0200
Message-ID: <20260721152637.113353662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 441c510a649c8ddce38aa0311334ed8bb546b36c upstream.

During probe the driver claims the data interface, but it never releases
it. Release it in disconnect to avoid leaving it permanently claimed.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -2096,6 +2096,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


