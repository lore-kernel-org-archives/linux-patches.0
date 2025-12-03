Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62E639A254;
	Wed,  3 Dec 2025 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780802; cv=none; b=Zh2YhrDsigRqwqhvEafztBkmYfn9z8HJOM+zim457qq4JiKHZi/7IbC7wyHnWOW6hsIUFqR9yo2G7zV0NaAsTCnQqB5q1XZETuGI3sbVvWT3VPEhOrFsd3yTEuLILDFSuSEOJ+9fOV3wtchr87fjCaFo7b6GLgTNpQj0O9PtJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780802; c=relaxed/simple;
	bh=sghb4c0fYWMWaaPnu5D2mU9gzWI7Gbx1Z3L1FgLqhdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMfXYhRdT/erzq1xA4/NorPpZwAFuYzVNIrq8E1QiNVyZjN6GRO6zdEfI9+7vVRtNy8lki9Lf0OyezVmawGG7TMsVzpjVsJHZNLmnQ5eDkPVY02hVv50LyqCOaIrZ2Cs4qXfXfHsQf2o3sTqKrr/861jQ2EjQ0gDV841PJNVa7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHYz7p05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHYz7p05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4857BC116B1;
	Wed,  3 Dec 2025 16:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780802;
	bh=sghb4c0fYWMWaaPnu5D2mU9gzWI7Gbx1Z3L1FgLqhdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHYz7p05HhHPsVFvE/GTVbmCsh0tlKcvzINHjFwaScknmWzMqgG4+KAF13N5WFzuE
	 SmABWJCblTvlZlTDtIhKt6bzbhNhChx8DcHTEqT4QyY3rzwFDHQbACD4hjq/P/fVcS
	 GSSolcgcFZCWNn3m+1yjvrYTbAoA/K1pCP3uPVIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 093/132] usb: storage: sddr55: Reject out-of-bound new_pba
Date: Wed,  3 Dec 2025 16:29:32 +0100
Message-ID: <20251203152346.737092964@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit b59d4fda7e7d0aff1043a7f742487cb829f5aac1 upstream.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

new_pba comes from the status packet returned after each write.
A bogus device could report values beyond the block count derived
from info->capacity, letting the driver walk off the end of
pba_to_lba[] and corrupt heap memory.

Reject PBAs that exceed the computed block count and fail the
transfer so we avoid touching out-of-range mapping entries.

Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/B2DC73A3EE1E3A1D+202511161322001664687@tencent.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/sddr55.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -469,6 +469,12 @@ static int sddr55_write_data(struct us_d
 		new_pba = (status[3] + (status[4] << 8) + (status[5] << 16))
 						  >> info->blockshift;
 
+		/* check if device-reported new_pba is out of range */
+		if (new_pba >= (info->capacity >> (info->blockshift + info->pageshift))) {
+			result = USB_STOR_TRANSPORT_FAILED;
+			goto leave;
+		}
+
 		/* check status for error */
 		if (status[0] == 0xff && status[1] == 0x4) {
 			info->pba_to_lba[new_pba] = BAD_BLOCK;


