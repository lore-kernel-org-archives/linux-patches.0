Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0639E357CEB;
	Tue, 21 Jul 2026 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670009; cv=none; b=Rqfepu6xPxe40isWSDLakDzMGRIojCZv0apQ+tBb5MzvCKIi1G6tF8drf7suLbGjsZYnzYM3McJSfkZ0rNvw9lJnUNQVYtCCogmgi5FDueoKpxa7/v4UGIsad8jxiMelsqHIAFnkrvwl1BsVN1QUlDJy3DGRPEuh6M7Kb7YUVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670009; c=relaxed/simple;
	bh=6PHWbejjKNMTxSw+AJNNDU/WZu9GfL4RarY+8XYcSd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYbexN66pggKHseXvIGUS68bCMV1DE0gLvh9q/dARbqAvoAbYRf3EJjxT4iOKqquSI2rSM3nI3SVqREa9+3oUfobBMRel3Utz0CmQ2Px7KEz5P3yNcAVW/abdyX2MgSA3b2JEdQTHX1P3eTdc8T8K3GgsyfLlJcy3238EVnDLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAc/7ZFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAc/7ZFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3A21F000E9;
	Tue, 21 Jul 2026 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670007;
	bh=N++uyaxYwCyFTtI5kDTcZjTC266ShcJuhX9kSqQeEls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAc/7ZFxMToW/44g9026nHPmbDlnugGT8TJT+1Xq30Lrs9Pwa4mrYS3rZbrjRaXR1
	 5f1LIne4/bVtZE0E1pO/6iMKsrHRwvtnEtzQAT3Zv5/avHpCkzSpN5TLBB+xYQvPuX
	 oYcKEmlfmEpMLfMY2ZDbsXvp9RQDBDGR1mQ/o50Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0770/1067] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152441.797204180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


