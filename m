Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC82F398FA2;
	Wed,  3 Dec 2025 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781140; cv=none; b=cy0SNI0LIk9EAYiD13c9HQXFY8AyVhkoDlZfqZNoaju047n42IgLfXPCK7dCY1ll5Cld4ocumegVGifE+z2+wrSB3BWSB0oaCMunGmuAkti7LrfDUshnEqe+8xx9ljmUhuFpy52PDjNOb/56dJAXtx0hfFGPjE39jbdXlMdZybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781140; c=relaxed/simple;
	bh=O6lR0d6dEzOovhya8C0mJMD9UFRi87VUbgUjqwhl+Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmkVBu3FjwZ1/R/0KyGoKJ0v8THI7huSOw3HzcM7UaKgsbtJdFqZWDohRZqLiz9254O6crSPr/BDA/OADRMac2BJAfFhxBoUB67mkVI3x466w+8DH5VLRMKW7ObpD/vqRiOgg523zrcv4MjMdqKo9nWMhuVx55+j8vhEJJ3k8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRIoAQei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRIoAQei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC696C4CEF5;
	Wed,  3 Dec 2025 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781140;
	bh=O6lR0d6dEzOovhya8C0mJMD9UFRi87VUbgUjqwhl+Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRIoAQeiA3Ujp6Hg5vBk4oxn4Yc/gPO3xPWx3E7sjvtR/ZBJB94DMelLf2XYC3S09
	 pBKXlfGO64wBjbAwF/5dQZXuv7BAKuNVS8z257R0kJFuF6wSEtrIEBjOEAFq9Ktn4V
	 ufuNeEOqLeuKW30J4ggs58C0Hx6wf7bmQgwcr+xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 62/93] usb: storage: sddr55: Reject out-of-bound new_pba
Date: Wed,  3 Dec 2025 16:29:55 +0100
Message-ID: <20251203152338.817016216@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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


