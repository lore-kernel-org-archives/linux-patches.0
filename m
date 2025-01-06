Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD221DED77;
	Mon,  6 Jan 2025 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178577; cv=none; b=cFUFfqxp4UGmztLQXujfMMwDqMpbtQQsNQTRfvQOCdlhd/QMyjZ8f7/l2kY3kxKYvLuMBOXtUCmuG/SvD9ie+4ImOocdSrIMBkhYCH9g42M+zNvLrYCU2fbQ2yWwVyrnmKezhGmUO0H8fG3quDUbat91uhXGosXydp7reP945L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178577; c=relaxed/simple;
	bh=ZH8NfqiNROEHZR9ZOGcV0EtT+6iwGhyyaedcZzNZV0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=er0fcEu4yVf2+6HQ8Dt0IB/oM2by4O7kxgqIZtXJNO6MHjlmf4ikTLNmqSBDUbTmCcZO5pD71qcvsK0Rd+N1/19x2oDto7jR4Tlfyz14IWOGsUAthIiLwy2t84vc3np81tdSytJMVNrO3qAiQ8NaUBag+GZ+RUamiy2g70EwF0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMJhFJ4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMJhFJ4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D573C4CED2;
	Mon,  6 Jan 2025 15:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178576;
	bh=ZH8NfqiNROEHZR9ZOGcV0EtT+6iwGhyyaedcZzNZV0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMJhFJ4PsJVA5oUq8rfcF/dTmzbHQb3/cGUByn54MAWaqU5k9zFo1tuoIlHtJwIiP
	 FaGE6yg7XIMK3n9EnPhUvsyBwObeBIkbndR8qhBf1PCuZ3ZfcJAgVun/YR7wDarvsX
	 0vfEkOKvzO68S9GfT9Ao8fV/YBdLyMq5VqU9bP+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 025/168] chelsio/chtls: prevent potential integer overflow on 32bit
Date: Mon,  6 Jan 2025 16:15:33 +0100
Message-ID: <20250106151139.413501051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


