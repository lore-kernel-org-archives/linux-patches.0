Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFBB3368A5;
	Tue, 21 Jul 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667156; cv=none; b=VWL2U6XJ8aZD9WRdQpPSZMYynmERoOa6V1zG7pPu1QPod3iKAgb1FWo3xE5PNgVSgzG1wRtmj0lXToYrFvzDfnAELr3tthi40wQG0xDU1EicOrf1rtMZVLEk4GGmA47ruV7R1gNO5qFsULHP7CN48hhFbV5DoZ+GuRMUD8MSKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667156; c=relaxed/simple;
	bh=gy2DRE/r2xR9xxekta0K9BR74BQ17aBQWol25sTkrQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHA/Spozks7uP3CkHwSHqDUpNQXVhg6yvgNq7qtPMnXIZJmSnrKlgq67bG2clJiL3BJCy74aWHGGLkRARMjzCW+mun+NGNOttsNcEpAW6Chwhl01x2Y0SR6bOW3rb90O0xex3a/uVD6QL8lEhNU2v0tLRXp+XswRqAGu9mIyKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC7jfBmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC7jfBmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7D1F000E9;
	Tue, 21 Jul 2026 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667154;
	bh=D8fCOp/hjVde+xsUEYADl0LrSMh0mLkfnJcE1TDFhLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pC7jfBmJ3GYiGzOQjjjOuobGdoCKbTdWMm8N4El6HGT7+RxCedBi6JMlDbvG7t3nC
	 v8phUnBRT0MtjqEyodvL76gno2z/mcynlFuol4QpNKAhs5/du3oMXYxLZh3De/OVg9
	 Z7HIewOgxnMkSzzTIcRCE6ST6ynReEc8GAV7YTOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0953/1266] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:23:10 +0200
Message-ID: <20260721152503.152462473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 6b628425aed49a1c7a4ffc997583840fc582d32b upstream.

The caller of batadv_frag_send_packet() assume that the skb provided to the
function are always consumed. But the pre-check for an empty payload or the
zero fragment size returned an error without any further actions.

A failed pre-check must use the same error handling code as the rest of the
function.

Cc: stable@vger.kernel.org
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -522,8 +522,10 @@ int batadv_frag_send_packet(struct sk_bu
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
 
-	if (skb->len == 0 || max_fragment_size == 0)
-		return -EINVAL;
+	if (skb->len == 0 || max_fragment_size == 0) {
+		ret = -EINVAL;
+		goto free_skb;
+	}
 
 	num_fragments = (skb->len - 1) / max_fragment_size + 1;
 	max_fragment_size = (skb->len - 1) / num_fragments + 1;


