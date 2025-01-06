Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD12BA34;
	Mon,  6 Jan 2025 15:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179154; cv=none; b=GNmDNkzFyGnflUJIf/d4HlqRDxDzz51iHXiMcnuFFXVzCIjmgx0VQAuYvB/npEMOVXCn+yHOZ9x+glSAIaSPI5s+tMu4otkrnHNBTmx1iELfKIDLZ9Kifcol1A1VN0taJmIpgPYyNGQcvRC8tkakz9nonjD36MCcYOZ2DTJubZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179154; c=relaxed/simple;
	bh=A+4yphVHcP1nphcRRrISWtnh8u8sj7SPv2K0dAy3lww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cwsklx0iZusNTMh3Vfpn2nzzqBSqbcmp/Bo5G2jd2qqIL4bshHoYxrrwtFcEyV+VzzbleJ5vnqzyKXJfkfIdT3261ERn9j8FphkXQHqOonmWqRkmSTuwr0mm+8Vkk49G8pUsBYGrMY5QN73mZ5K0ahppgDbhF4X9C6qpchb8B2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQZPpVNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQZPpVNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6323EC4CED2;
	Mon,  6 Jan 2025 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179153;
	bh=A+4yphVHcP1nphcRRrISWtnh8u8sj7SPv2K0dAy3lww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQZPpVNVlx0Wb9jCksODVq1c79bdPuoUrmtqMeU42hPoZsSu8EHKnCNqpgye2K8oW
	 bnsxACYkcu/dOXunqKW2JxdHuMap6DovkaJhFuUiYS96uyV7k3nxHjTSjElDqd2crW
	 2xwyhnCAKVCWGJJTmimdKCp/oLlntYdmuksZ0LGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 16/93] chelsio/chtls: prevent potential integer overflow on 32bit
Date: Mon,  6 Jan 2025 16:16:52 +0100
Message-ID: <20250106151129.315396369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/chelsio/chtls/chtls_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -339,8 +339,9 @@ static struct sk_buff *copy_gl_to_skb_pk
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


