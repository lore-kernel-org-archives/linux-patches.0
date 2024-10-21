Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AE21E47B7;
	Mon, 21 Oct 2024 10:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506731; cv=none; b=tYI+T+4CrpHSs2UM7Ax3gzJfIbjnr+9vfIZ7qfstz33uug2aE4f6Sk3FohY/eLx+dYG/gVlC1ch0S3cr5q4i09HDE4YrZaVnb5q8mV8qau6xjVzLs3r47t3QZubHfi1ZAp9JGEXXkfWGOntpKkVS8/XKv6t5QYQVT5qb2/jTPwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506731; c=relaxed/simple;
	bh=8RhylegYv2E8d3B8GuQFhv1wLLkoERVDEGB8ZHURlsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmqvMc9A1EREDbkLY0hc+7tBVDxAamaS+fg5PMKSoxQjlXC81AQLnvj4O1kc8l+lVEx5mv+BT28zY5qzS/CmMNFO3lZi2Nrq7hxKCJmf1a0C9dZGy9aCd7VgT8vo3MyKgsumgWPcKx9EBIxGJt9wxvwQE+DP7fjLCgiQobit/hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSB4YlE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSB4YlE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB9AC4CEC3;
	Mon, 21 Oct 2024 10:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506731;
	bh=8RhylegYv2E8d3B8GuQFhv1wLLkoERVDEGB8ZHURlsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSB4YlE3JHtC74fykPJUwu2KqmA6tAqMRipYk0r115WFqdxsZxRClUEo8P7KdUqg5
	 pbB/b9Yo62zbdJMSPsDPnFkPuz5jHIrSp6Q/quNHQLkXjiA1ZWhUjHT2MGMgCaA/8U
	 RPKQqbiMVBMamMayhluso1jcCgTyo/5+ySQz9eJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.11 101/135] xhci: Fix incorrect stream context type macro
Date: Mon, 21 Oct 2024 12:24:17 +0200
Message-ID: <20241021102303.277352649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1001,7 +1001,7 @@ enum xhci_setup_dev {
 /* Set TR Dequeue Pointer command TRB fields, 6.4.3.9 */
 #define TRB_TO_STREAM_ID(p)		((((p) & (0xffff << 16)) >> 16))
 #define STREAM_ID_FOR_TRB(p)		((((p)) & 0xffff) << 16)
-#define SCT_FOR_TRB(p)			(((p) << 1) & 0x7)
+#define SCT_FOR_TRB(p)			(((p) & 0x7) << 1)
 
 /* Link TRB specific fields */
 #define TRB_TC			(1<<1)


