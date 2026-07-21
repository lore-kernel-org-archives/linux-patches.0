Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A54D44AB9F;
	Tue, 21 Jul 2026 22:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674380; cv=none; b=tWqwsX2Ad99iN6U0sJz2nJhYQjnNZQbluM51AwoxM+7wAxP2jZDPls5mVeSjZIGHz+FtSywips5wZKIrjEiKcQeZues1rQEcB81pzEELxYGLKLVCMg52F9Ae0DMZovkjI99RSY8O5q3Ojkrf8t9Q2Xt63jg37DSbl/ez3rpGxgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674380; c=relaxed/simple;
	bh=vOA/SB+HcQ1IH0n+VUYbLW7ZYT5AmhhRa4GCtmGhcJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieVPTUgweiwDMWJfINDZBksq/ODpcZO8Kuv51IBzNPPbcXRALrMagjWlORM2SrVTPAaUGLdYLBVEXZICusKmsZiVpNooPBzmR5R9UmF5ChZnqolMFmVYGnsB6uJY0j6Qv1SC2Y9at2JCi4BpA/63ocCdlUM3oiIANdaEA5N/WFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AOqE1NN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AOqE1NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0D81F000E9;
	Tue, 21 Jul 2026 22:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674379;
	bh=sohMcJnLlkH9+rRR5fgDv+T061bmTiKzb0P+7Q51gGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AOqE1NNuGRG1XllYtTLlFg824hUm1xRMhrgZCqAKqlby6sbyv9LCdH54z0NE2oFL
	 mfhyN4XTFlNuJoA+XHVTspad9cse8Vb0ClKOPpOZ1fB+HDFg7PdLv69RctrbC4LZZ3
	 Vnp/lx0dJnLgMMiA3TrK2ipcT/vbfPykVc1dsw1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 519/699] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:24:38 +0200
Message-ID: <20260721152407.405393432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2086,6 +2086,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


