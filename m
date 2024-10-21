Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EC71E6DEE;
	Mon, 21 Oct 2024 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507843; cv=none; b=CF6nx5YuN7BUUBHywUL4gIi4B4jatuGt6dnUlKIfSjAkGOofvG9hJmbzaUg0wrRHoui1cSFUbOVqK5yUwHTR+TaFU7X6pXxGSI7MCEbU8kGfHvnFIWXt2k2JWSPp+whxOt8vjlyDKNxPmw76H+fmmSwLZvCxB9SDr/YsGxxj2tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507843; c=relaxed/simple;
	bh=8mQ0ZwzPh1hNDw52h5UlwkCrrzwZJCmx8JUNz/zv9RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJGvlUubqNKL5b5pzo9eMv2zybjnY8R9LL+Pez558ej3oeRgARFR8rE7P1sjJYoKP0PR8SEeox0mP07GIDGNqN8OIpV8RoRZYoQyw1FsiMihG5R4vSHZcHqDH/+XoLvQbxRETavTuG7SC6XFgjtlYFECS2ly2qJnbPPsVkM4zD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV+wPKbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV+wPKbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8C0C4CEC3;
	Mon, 21 Oct 2024 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507843;
	bh=8mQ0ZwzPh1hNDw52h5UlwkCrrzwZJCmx8JUNz/zv9RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV+wPKbx9++pDma00n1aChcPM4o9FhLplDt5LO3uYq2qw3iKVdsghCrTUGoZ9TA+3
	 2M6mqw6PseH+ji1eB2Z0RtSg6LTvjLvkogexyxCrYNip49Ncuwjs+xTYgvIjDpZpnK
	 846HglmRh4NlAQHpwCJlJ4g8oRDe29uLw2iCT9KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 38/52] xhci: Fix incorrect stream context type macro
Date: Mon, 21 Oct 2024 12:25:59 +0200
Message-ID: <20241021102243.117321011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 6599b6a6fa8060145046d0744456b6abdb3122a7 upstream.

The stream contex type (SCT) bitfield is used both in the stream context
data structure,  and in the 'Set TR Dequeue pointer' command TRB.
In both cases it uses bits 3:1

The SCT_FOR_TRB(p) macro used to set the stream context type (SCT) field
for the 'Set TR Dequeue pointer' command TRB incorrectly shifts the value
1 bit left before masking the three bits.

Fix this by first masking and rshifting, just like the similar
SCT_FOR_CTX(p) macro does

This issue has not been visibile as the lost bit 3 is only used with
secondary stream arrays (SSA). Xhci driver currently only supports using
a primary stream array with Linear stream addressing.

Fixes: 95241dbdf828 ("xhci: Set SCT field for Set TR dequeue on streams")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241016140000.783905-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1282,7 +1282,7 @@ enum xhci_setup_dev {
 /* Set TR Dequeue Pointer command TRB fields, 6.4.3.9 */
 #define TRB_TO_STREAM_ID(p)		((((p) & (0xffff << 16)) >> 16))
 #define STREAM_ID_FOR_TRB(p)		((((p)) & 0xffff) << 16)
-#define SCT_FOR_TRB(p)			(((p) << 1) & 0x7)
+#define SCT_FOR_TRB(p)			(((p) & 0x7) << 1)
 
 /* Link TRB specific fields */
 #define TRB_TC			(1<<1)


