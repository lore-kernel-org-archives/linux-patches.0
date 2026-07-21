Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D5D40860E;
	Tue, 21 Jul 2026 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658743; cv=none; b=jzIKGDMsQq5pCdxJAEiWz5QQEDU7gLNHe51UFYYeUHj2lz2GQvbpv9qp38qJ+QRBWLebUfHUalJJxeVZAxMR5xnFAG8X3rE0JK6pKHRQ1h7xJC4I/TGDUl0Fh9+RfVNKEpi41uoLeJQFaZYjHg5Zq+9AIbaFc3455Zkp20yk96U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658743; c=relaxed/simple;
	bh=OHwrDk7W9v7cwfheeH/dQdPtwsFWW0wYHoSpNjdQP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BisYN5TP2L5fredtIE5EQBqv3svJbu6RUerRklFagb6rH2p9wE5jHvbVKMnZVOlhzoWNOlpkZBbOiNgCbAKh3JeDmJpuBKTLA8V8bWZLkvkMCFc9eiY5TrJULx194Ce0xy4tgef4hhgcQ+Uu15BlaT8NnEbJJJBhO140TwY4+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Df6dIZ0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Df6dIZ0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900831F000E9;
	Tue, 21 Jul 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658742;
	bh=h1f/AuwSzBdYp6iaTvW26T1h6cD3XlW29SdVMnDP/0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Df6dIZ0Ux1dQF1w/An0bJBwWv+/RLSUuxkoV5PsYiifirtWiSkAP92m0JXksSEHPQ
	 iFaO7glsD5b2SmEdByWafd/ljyU7ThIX34UW+QshOL8Skq88c/tJNjOQsotJOWwuoc
	 WxSEMa+BvqpV+EDXzOb1ytyqAjIlcNpJL03egyzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1204/1611] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:22:00 +0200
Message-ID: <20260721152542.515981477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -516,8 +516,10 @@ int batadv_frag_send_packet(struct sk_bu
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


