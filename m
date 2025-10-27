Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C1432A3F9;
	Mon, 27 Oct 2025 19:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591998; cv=none; b=NkRgluKo3E2R9FJ+13+f8k2rzwzV0ID/5Mk4+2HyoCk8czcZmREnXpXpeew/194IIlH6fDsEz5PEvLXy/Wp7l8/7HQRaVPy+pjL+2OlaIvrwz/86EKVTZz3eFHhFDyVheiTIcAdMUTSGUSbHEdvCSgQgYg+3bXG3AugEPwPYDzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591998; c=relaxed/simple;
	bh=+QU1J1PAMbiqeTfpefZokaY0aEiK/pOrhw2ZGCXYPAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGh8Bv/SO/vQ97YNv5qgw9qRg/eiP/O7z6wmzHJsyPep59DDnfKhksn23Z8cui3Xkq8tDLYez1wjzrpjUPB650Q70PymEoGUXUUlS2UCKYn4FmNK7dzQrdaoahHiNHkOPEFvbhTIDMQRqVD5DlMP0wEoiubnAw4Brcv9t66I1tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvvz5hU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvvz5hU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C33EC4CEF1;
	Mon, 27 Oct 2025 19:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591997;
	bh=+QU1J1PAMbiqeTfpefZokaY0aEiK/pOrhw2ZGCXYPAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvvz5hU+PRlNRiLSFqpBItGOPNPPkI+1Fzbk1D+Ilic0LNzvcK/k36xc1zK4DinJl
	 zVebfOGXOc+ose2zofwJAe3Qrkj+G6DW6PA4b7tF5uvgNGzUHx0pt7XmkToMuGGUrY
	 jewzHbyLMzvOiibdFambPyNdMP/gAQ60K9LK9jj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 5.15 079/123] usb: raw-gadget: do not limit transfer length
Date: Mon, 27 Oct 2025 19:35:59 +0100
Message-ID: <20251027183448.509000381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 37b9dd0d114a0e38c502695e30f55a74fb0c37d0 upstream.

Drop the check on the maximum transfer length in Raw Gadget for both
control and non-control transfers.

Limiting the transfer length causes a problem with emulating USB devices
whose full configuration descriptor exceeds PAGE_SIZE in length.

Overall, there does not appear to be any reason to enforce any kind of
transfer length limit on the Raw Gadget side for either control or
non-control transfers, so let's just drop the related check.

Cc: stable <stable@kernel.org>
Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://patch.msgid.link/a6024e8eab679043e9b8a5defdb41c4bda62f02b.1761085528.git.andreyknvl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -620,8 +620,6 @@ static void *raw_alloc_io_data(struct us
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
-	if (io->length > PAGE_SIZE)
-		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {


