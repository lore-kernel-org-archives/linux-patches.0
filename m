Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E917016F27E;
	Mon, 21 Oct 2024 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507673; cv=none; b=rToaUBIroyPyHgFdp0CIq5q9e96/OjnW4cYre8Xf0LlEtjI5PmR5YLoKNXpJPKjmig7rpi6nxQ38Jv2M3U3WGTujp9lCIzZdjYGZHtx8+cZnl4uR3FvA09Be8iZam23zLx3HnhFYTlzVPOqtwqwtSc3ApOfoFaFFjUg0/uqmuM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507673; c=relaxed/simple;
	bh=1QPxQ/vCGTdZMX4nFTQRBK1ubd95oJ0GR3u7gXjC8Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA0X031v2b7CyYR9vGzyV32THjqRL8wnYhB1hkYSc5HsJq1DcBOgdirpeq4bpR02AqQ60EN4ouwmtdLpXR39oLrBhqyOn2vDtdd3t6455xzLgIU3who/8DU+jcoBY6ejkTBLC5xNECQOMpGzT+pAFiVutuwanwZJEsZLKmUFTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te6CLTHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te6CLTHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF5C4CEC3;
	Mon, 21 Oct 2024 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507672;
	bh=1QPxQ/vCGTdZMX4nFTQRBK1ubd95oJ0GR3u7gXjC8Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te6CLTHCSkq4epMCHO3Bk4+XONA8uYHaEY8RVAup+qHxVrqA2Gut/+7Ms+Wfv9NRk
	 6ovYQnmdJI1vPZswdEVSNVc0kQdbII8YfVnzX4Me/LavZD2eKF15Ehr763b/zfAbZk
	 RxS1O70VKZyUIiKBXfuAKwT+uST8jouZNvlBflCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 63/82] xhci: Fix incorrect stream context type macro
Date: Mon, 21 Oct 2024 12:25:44 +0200
Message-ID: <20241021102249.719083994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


