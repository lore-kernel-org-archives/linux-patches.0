Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC78A2EAE6;
	Mon, 23 Dec 2024 16:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969844; cv=none; b=IdIjtd6S0E9f+JwrlrsLn/mQq9W5otoUZamg3Fogx1Pg/D3HX+YSCBHeaHoy3nnFbfxKremZe+6m3PjxGjA42+pOrQ1f73F/1DhajC8wT6o7wGXco1pUoLzSpX5jAncud6KUGkmM1q5nmETKWqgxwLuSMMXjERLgW+hGFrcJ+fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969844; c=relaxed/simple;
	bh=/f9BewhLlCIs3t43Br2tyGBEJCFajvttdN0VetKYeOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhq4Fs1HOVjJjJT/qe4tkJGBXJyqnG03S+I3fSy9k1GmJQUM9MwS6plBhwDg8lEz3O+NIYBA/V9PP8ohzldQMDUnsjE5FiwBdLtO5KiUyHYdSqiIVSUD2StzMiYsf1WZDilo8pn0baZl8gb1/g5rFBH399/d1A/SbmHjX0RI7RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHANYl20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHANYl20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E56C4CED3;
	Mon, 23 Dec 2024 16:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969843;
	bh=/f9BewhLlCIs3t43Br2tyGBEJCFajvttdN0VetKYeOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHANYl20kvTsrN3dp/4mQNPtl5x1q7RC/WP3RSss73vFpUwti3poJkYB24hXUF5MK
	 +IBJZwC/0hqapN7MYlAPLpqAAZfjyUBB3yoCgNWW6/vUp+/wfLY+0UakFJDhcloiaQ
	 5D5HgvOkKA/ecMSYSNjwB9GcHbTvjTZX+VxjB6hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 070/160] chelsio/chtls: prevent potential integer overflow on 32bit
Date: Mon, 23 Dec 2024 16:58:01 +0100
Message-ID: <20241223155411.382071447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


