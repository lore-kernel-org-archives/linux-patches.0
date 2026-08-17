Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE9C442FAE;
	Mon, 17 Aug 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980349; cv=none; b=YBBeyQ5KlRV7+12ifgqRc2/GYLfA5ZkVkG3IiSy3RJId5LtQ+6OJmdMIp8zj+4zsomlt1IyQw86JKZm3QpfuQheEhknbIDjDMsDW+ooHmBJG7ii115rRnI1DDRwhWJ+lteItXTAWqfe+IjheJQrcin5Jb82EeBA+QhaajTxw21g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980349; c=relaxed/simple;
	bh=nS0paiB6WzPuEVmNRi6rEpBMy5jNbTcPltKrIOZeFBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQoysLbw7aSYw5Q5lkFW3zmGCsUKMCRw6a1ISEKKyb7bLuYsRHZqJ/yu/pmKMuDcqzdV4kZJ2UzH7NEFonXw4J8zPPLlluhpWCV5X1jUX7VZ216nN017BX2aDCxkNgp/T95q9tADOm9lbdNF9ol6SQ3bCJA/8KWopLK398inh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0tDB/zk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0tDB/zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E791F000E9;
	Mon, 17 Aug 2026 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980348;
	bh=RIhWvQbIirwFhIl9shGGserjmXxTRw5vx/9tLbgXsVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0tDB/zkzRZC3MKYyypsB3HWMjkC3TaoHpHBp/6N04q0byKB61rKKoBG8HvJ3Hbeu
	 kT8g+dkWgY3759n2ioqQYkqKQhWd+1R9AnMpDs8fFfWB0TeiiY7wkBWsCBcJwgTuU5
	 YIo/3jD8irNp/dX/Z5Dymjra21EZ3ipvFo78zwoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 6.1 543/609] usb: gadget: f_ncm: Use unsigned int for ndp_index
Date: Mon, 17 Aug 2026 15:33:59 +0200
Message-ID: <20260817132601.939308837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 6b1c8a9403a26cb0fed7a648916c74dc236da591 upstream.

The variable ndp_index is declared as a signed integer, but it stores
the return value of get_ncm(), which is unsigned.

A malicious host can supply a large offset that overflows the signed
ndp_index, making it negative. Because ndp_index is compared against
unsigned bounds, this negative value bypasses sanity checks and leads
to an out-of-bounds read when calculating the address of the NDP
block (ntb_ptr + ndp_index).

Fix this by changing ndp_index to unsigned int to ensure consistent
unsigned comparisons throughout the function.

Fixes: 370af734dfaf ("usb: gadget: NCM: RX function support multiple NDPs")
Cc: stable <stable@kernel.org>
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260720165654.2224591-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1176,7 +1176,7 @@ static int ncm_unwrap_ntb(struct gether
 	unsigned char	*ntb_ptr = skb->data;
 	__le16		*tmp;
 	unsigned	index, index2;
-	int		ndp_index;
+	unsigned int	ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
 	unsigned	block_len;


