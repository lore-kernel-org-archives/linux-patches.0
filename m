Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9A3321D9;
	Fri, 21 Nov 2025 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731321; cv=none; b=ZOxHL4fVy7x6jk+iV5r6VPr+beqU7yCviAHUidszF1SfHGKxuFevJL+XpMXivy5nAAIIr5Fi7TpFvMNvrrE/689fl8458ULi9SuZj1T11KBWd9TGBpgmS57NlZdhVexzU3XgPLghW9tqFjsbUsPv3HwxX7E5Im9mLepwIw8vBMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731321; c=relaxed/simple;
	bh=fI2whQr/xZGTgkMvVMKqgjdXrzq/Ani1Y2DzKLumVTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ9LFCaG7D/W39XrEuAUErTccPZcEwbP+ek+ES6Fp4GSjjYq40uBt4JE5wBDhZGq7A/0l6C3uFJx66QrUNB7nzL6wi82oavAs+ZP/KB97kdOfxSUcM7DMINLjuLon6GPttKfUpnBoKLb8hheOayYihbIT89jroy8sjTdg93fy88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjpK8fya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjpK8fya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC0BC4CEF1;
	Fri, 21 Nov 2025 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731321;
	bh=fI2whQr/xZGTgkMvVMKqgjdXrzq/Ani1Y2DzKLumVTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjpK8fyaYhu/AeiL1gDdeYQE7XRzYUAA9Kz1hqzdB+mS1qWQojSAD+j49Ev46OnVP
	 Z66Uzo3jph7zSuwDJSaZG6wIiisWuTAHZWTz+gvwYxV8lMuYUOsnA4fl+l4vr3Y+U/
	 77jC206a/sXh1+9g1k/bGM4B0oZQlfM1qd6PczZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nate Karstens <nate.karstens@garmin.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 168/247] strparser: Fix signed/unsigned mismatch bug
Date: Fri, 21 Nov 2025 14:11:55 +0100
Message-ID: <20251121130200.750365117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nate Karstens <nate.karstens@garmin.com>

commit 4da4e4bde1c453ac5cc2dce5def81d504ae257ee upstream.

The `len` member of the sk_buff is an unsigned int. This is cast to
`ssize_t` (a signed type) for the first sk_buff in the comparison,
but not the second sk_buff. On 32-bit systems, this can result in
an integer underflow for certain values because unsigned arithmetic
is being used.

This appears to be an oversight: if the intention was to use unsigned
arithmetic, then the first cast would have been omitted. The change
ensures both len values are cast to `ssize_t`.

The underflow causes an issue with ktls when multiple TLS PDUs are
included in a single TCP segment. The mainline kernel does not use
strparser for ktls anymore, but this is still useful for other
features that still use strparser, and for backporting.

Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
Cc: stable@vger.kernel.org
Fixes: 43a0c6751a32 ("strparser: Stream parser for messages")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20251106222835.1871628-1-nate.karstens@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/strparser/strparser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -238,7 +238,7 @@ static int __strp_recv(read_descriptor_t
 				strp_parser_err(strp, -EMSGSIZE, desc);
 				break;
 			} else if (len <= (ssize_t)head->len -
-					  skb->len - stm->strp.offset) {
+					  (ssize_t)skb->len - stm->strp.offset) {
 				/* Length must be into new skb (and also
 				 * greater than zero)
 				 */


