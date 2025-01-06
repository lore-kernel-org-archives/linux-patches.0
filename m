Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A3E146D6B;
	Mon,  6 Jan 2025 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178244; cv=none; b=e7upfI5HQGsFjHUpI8gbUazHM4Km1w73MlaVCifLyGwfXKnRtuoFJ5KRbRdAy8CjHIJRXVpuFe81P1AO0e/+l4b7rSSvdvbGlzSh4PIRvgV1YLdb8SqnrseCPosn/4H42qlCxTv0jImTSXTNU8ec+mwfNR/bjOvA2yKMLsv8DdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178244; c=relaxed/simple;
	bh=SaahdEcRye9aXgaI+hYg+Ukj3WDZzF8B1RqNwziMelU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9YT/u8li2EbW1PQYYSRe24tjinmw6VAY1aAN/UdFvISohxgFq5lvh1Ly8Vad+saE+leAIWoRUH1//FqqPG7UsFl0gsxLhhyNF3XPjV1xMQr9hju6d99AG7o83xtbuRmgMAaQR6iWjobhcdBwWcuCqAjmKRCY00+wRFDfwUrptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJT+CJlJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJT+CJlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794EDC4CED2;
	Mon,  6 Jan 2025 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178243;
	bh=SaahdEcRye9aXgaI+hYg+Ukj3WDZzF8B1RqNwziMelU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJT+CJlJTigUy0wFDzA4FmWtwF39bO6WqowjP36lARWuFOFczUjMpBgNZ+GF4nLIy
	 PRxDzpbgZF9gbAMOf9zBRWsxiC8iCfbHsAnSubxyimhzZpjI+zVxYuN0fJeCFNwJab
	 EoGTan4H7rIXvpH1Tw0zzsCXWyLLQUw7Yfv1PmlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 022/138] chelsio/chtls: prevent potential integer overflow on 32bit
Date: Mon,  6 Jan 2025 16:15:46 +0100
Message-ID: <20250106151134.058294712@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit fbbd84af6ba70334335bdeba3ae536cf751c14c6 upstream.

The "gl->tot_len" variable is controlled by the user.  It comes from
process_responses().  On 32bit systems, the "gl->tot_len +
sizeof(struct cpl_pass_accept_req) + sizeof(struct rss_header)" addition
could have an integer wrapping bug.  Use size_add() to prevent this.

Fixes: a08943947873 ("crypto: chtls - Register chtls with net tls")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/c6bfb23c-2db2-4e1b-b8ab-ba3925c82ef5@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c
@@ -346,8 +346,9 @@ static struct sk_buff *copy_gl_to_skb_pk
 	 * driver. Once driver synthesizes cpl_pass_accpet_req the skb will go
 	 * through the regular cpl_pass_accept_req processing in TOM.
 	 */
-	skb = alloc_skb(gl->tot_len + sizeof(struct cpl_pass_accept_req)
-			- pktshift, GFP_ATOMIC);
+	skb = alloc_skb(size_add(gl->tot_len,
+				 sizeof(struct cpl_pass_accept_req)) -
+			pktshift, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 	__skb_put(skb, gl->tot_len + sizeof(struct cpl_pass_accept_req)


