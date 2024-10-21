Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375C1E3787;
	Mon, 21 Oct 2024 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507204; cv=none; b=KdEXwBZh+Y0vbRfx7l/BAzADWcEyjc+DW9B1cFZuh7NQ0/yyt7cHrepg2OB5pllH1LESFle3yxoPQ+amDrpNkS2Eo++zTBgsv2D21fERqc04/3Jvh+Nao7+n30NnXHQHdEjWdlCQJjvkZmauJl1rqkAlYc+xSUSu/kQSk2HGGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507204; c=relaxed/simple;
	bh=hXdIJ05HZJcd9EKeJGb7Zf9vfEOCoUtwaYhMka1q8ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/DjyK44lRaPzprMaP5e2+yx1JEDjkDcRpfCeJOpsKcevIfehyv+KcGIdrmmJV4Cncv6nBW104e2tyzIX5x+e0izt7amkFJUuLV7/pYnj9GpKJ0A3ZAKEN/L1JFtc6GJgZFwbFi7y7acVOzDIqP+9dZzmWaOkAMJNLcsiMD3nkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg9Idv6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg9Idv6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4256C4CEC3;
	Mon, 21 Oct 2024 10:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507204;
	bh=hXdIJ05HZJcd9EKeJGb7Zf9vfEOCoUtwaYhMka1q8ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pg9Idv6hzkhW9gJt7S457dDtQtvKRfitEeJ1T7G9U5CDKVL37aFQ5D1hZEWNy6Pp+
	 QdowQ+ieAlG+FgVhS1E/FluPO4D+0Vef5ZE5dc1cklIld6+Hb2iiNYfsMY8NQIIb20
	 7lhfugm54vudTzSSGSMmCCWYQwocUOF2RIEbuYbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 093/124] xhci: Fix incorrect stream context type macro
Date: Mon, 21 Oct 2024 12:24:57 +0200
Message-ID: <20241021102300.323844639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1286,7 +1286,7 @@ enum xhci_setup_dev {
 /* Set TR Dequeue Pointer command TRB fields, 6.4.3.9 */
 #define TRB_TO_STREAM_ID(p)		((((p) & (0xffff << 16)) >> 16))
 #define STREAM_ID_FOR_TRB(p)		((((p)) & 0xffff) << 16)
-#define SCT_FOR_TRB(p)			(((p) << 1) & 0x7)
+#define SCT_FOR_TRB(p)			(((p) & 0x7) << 1)
 
 /* Link TRB specific fields */
 #define TRB_TC			(1<<1)


