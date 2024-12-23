Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6871B4139;
	Mon, 23 Dec 2024 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970507; cv=none; b=m0y2BB0fq6Y/tpjOA18dAwDocBdBEFhB+dVBFj7AGuIKvXDtKQ1p58tOauS3gepunj8tA69bd6W6uY1vRzzHg89Yn76jGO2Xd52ho7DvUqzgxi36ODSQht/od7cgD6hgZIOWqqSatfR/3IJPhF1estD3GIF+Mva2AuzlbAE2caE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970507; c=relaxed/simple;
	bh=ZL4iX1fIgX09k8RWF2m6gE8UyY781GBgi2h2Drvi5rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERV5VgafwkbCebShmtTDnef1wWD0WzQO16hI1QPy/2cnjyNWWvaZBMHSjsFBBzUNnemZOikI5g8mqPKIQhp4CsIuHofAoB2X6tbFS1k4YmThPW88/VOpFE1iNCUGxp+AcMyzSStqlV24zIal+dhDklaUNulOTI8JAqjWVr69P5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUYejeuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUYejeuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EB8C4CED3;
	Mon, 23 Dec 2024 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970507;
	bh=ZL4iX1fIgX09k8RWF2m6gE8UyY781GBgi2h2Drvi5rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vUYejeuZKb27Mm3mny4wkY8aJZKaw/5jPmSgPx/H4PJ5J1/94PrwAVZWxfF1A2bXd
	 xhUVrsemV87RfD9ACxT/u0hNNIMCamISlogc8lsxmkdF6J/H0wSZwUr0tRtZJ6NkUy
	 3r6J17HRBMprwNwexySCEkxUCnBtNGRefLQpGLrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 063/116] chelsio/chtls: prevent potential integer overflow on 32bit
Date: Mon, 23 Dec 2024 16:58:53 +0100
Message-ID: <20241223155402.008710985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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


