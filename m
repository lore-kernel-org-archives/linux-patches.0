Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A218314A8E;
	Mon, 13 Apr 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098805; cv=none; b=tQmbd1D4Yti/jxes9d5zCMp2kyP0JhfnSdgx5r8m7ePFHOfPjWcu6t9akfrgWjPtIoRMRmVRJh1rL8KJjbcbcTqMYB3bMvf4yucecAv4PBQP4n82PJlc4q5AKH0dIUJCKxQ00Qkd6riqZoIWtYMR1Av3RfjSCFq0ea4c3Vi1rco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098805; c=relaxed/simple;
	bh=bJlR6GewDZONBV+hrgTx8W6xwIS/SyTmDUFUYYmzLZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdht8clH1vRvAXgaQ6GSiWVVTQX2WdW6pyTipmEl6Zi7Vg1IajrsnW05NVW2Lmlbq0dUpxS7IHtkqGBQYUl1K7bX0CuJDJVg33kzGgszQnj8VecTcMkCtPuW0LPzvBKRUCagnSU5z18Z5S7djN1oEcEoSSzFKu7om/C2C+uQM20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOxO6ANj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOxO6ANj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844E8C2BCAF;
	Mon, 13 Apr 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098804;
	bh=bJlR6GewDZONBV+hrgTx8W6xwIS/SyTmDUFUYYmzLZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOxO6ANjKevKg8dnY65aaxsLv/RiXNTRaMMsh2+3S/UXZzFAyu9AqtdaRqZQBgihn
	 lVrsDc9r4xXLDJR3L4NpZdUIM1buHfmLaFM7NlmavHtR9I5pNRMpibiKzuDys079om
	 dAta9qRbZJTaJgNXuMxOVrSXzrQuqEY4uYjtSdZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 095/491] usb: misc: uss720: properly clean up reference in uss720_probe()
Date: Mon, 13 Apr 2026 17:55:40 +0200
Message-ID: <20260413155822.601539766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 45dba8011efac11a2f360383221b541f5ea53ce5 upstream.

If get_1284_register() fails, the usb device reference count is
incorrect and needs to be properly dropped before returning.  That will
happen when the kref is dropped in the call to destroy_priv(), so jump
to that error path instead of returning directly.

Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Link: https://patch.msgid.link/2026022342-smokiness-stove-d792@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/uss720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -733,7 +733,7 @@ static int uss720_probe(struct usb_inter
 	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
 	if (ret < 0)
-		return ret;
+		goto probe_abort;
 
 	ret = usb_find_last_int_in_endpoint(interface, &epd);
 	if (!ret) {


