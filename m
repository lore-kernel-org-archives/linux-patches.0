Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11B1E3DF0;
	Mon, 21 Oct 2024 10:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507421; cv=none; b=aiWidAPQMaNtO09pQeE5cmIoj57W64BXioSJiTi9+ZemDHHoph40kQBAfwowklZP4EnuyKZLruW/stBSbT2RNmXhup1h1mShSJvRXnNkzXFCEpkA+YjAZj5+Vq866v0PD0LURCIGsMn1jXn9KF6vDQIjiKL1zUApVr5GsHrEIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507421; c=relaxed/simple;
	bh=VgIFgpAuUMgHkU6PM5rm5wzZShG/3OgB33UXTFNNsaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuGw56YWhUOBx9U7/ruw1PFkZzuP9ZSBIdj2OZ0hGeXCtiYFZHFpEbH4nMUcikB2vOCgTlViEaMXwG0uKaI31yPS+Q+8eCsY8jhI66+sa5ZB8EgqyDFtJ/ZQn8lN5hDfUjHrz6KO7EdPXEdYIaPl6s7L9kg1QqqTxoUBOgkySOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LP4sqc/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LP4sqc/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA28C4CEC3;
	Mon, 21 Oct 2024 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507421;
	bh=VgIFgpAuUMgHkU6PM5rm5wzZShG/3OgB33UXTFNNsaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP4sqc/WS+bu+U8Pe/cNlF1C0OsWjjUoS4REJ1H7/Ybviv3d87Od6tlNya3KLtWe+
	 x3h/aJ14rJfaTo/X0lkhUkYf3D4PtuWdsLMJs9RsizhcD7vZx9SYJlRp6RNQWzrm/x
	 3F8dD22VcDuZYcKbfJ/1h/QvdU1YlrpeUQFynNDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 72/91] xhci: Fix incorrect stream context type macro
Date: Mon, 21 Oct 2024 12:25:26 +0200
Message-ID: <20241021102252.630301722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


