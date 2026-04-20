Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0112D2E093A;
	Mon, 20 Apr 2026 15:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700387; cv=none; b=g1vQS4XlmSp0SbF4H3ubm66vuERwsI2WitQ7qreArQ9XXFrNHGJey69WqSi4hJZvyK/Yo5isS5RGnorLigRO54nROGAdQ4sUd/PloPCvHGPXKWcmwBnLem85a1qqpX/GqzSc3H+HB0YWjb17GP0wJRQpEpJy6437AiwkL5K3Tis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700387; c=relaxed/simple;
	bh=rQXyCmG0OC+DTY4TqWf2h6vqFkgdnyCHPTHqZO+kLsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRePt8fymXN7MWix5ciDrym6dqODNES2qhTSEIOoIek9vLFYUyai4hZACbZw5YKAQlw7gV4dNwo3ub7UHnw93pPcfwbFoW9ca8xIDogppYjibe2DvTNIYwQl6OiDcij8rqi91fBxm8ishs+AR6d8ktEAiFOYh1nQXJr2EiWv7Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnZF6mUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnZF6mUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDC5C19425;
	Mon, 20 Apr 2026 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700386;
	bh=rQXyCmG0OC+DTY4TqWf2h6vqFkgdnyCHPTHqZO+kLsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnZF6mUPzKNuWe/whZJuDS2wNVP2/KZcJD+g4x4lpNvj6kA2ySA1yJGd363UWrkjT
	 770VZ8yvn9gTmAGWz9stzY0rruMVcFngyvJbBspStWf0Svr5N27heC0tGEaH7+FiC4
	 o43TAaauzOfK/c3lsDehHPjkYmF95wN/3KoVoX4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 153/220] usb: gadget: f_ncm: validate minimum block_len in ncm_unwrap_ntb()
Date: Mon, 20 Apr 2026 17:41:34 +0200
Message-ID: <20260420153939.537195508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f993d30b95dc9557a8a96ceca11abed674c8acb upstream.

The block_len read from the host-supplied NTB header is checked against
ntb_max but has no lower bound. When block_len is smaller than
opts->ndp_size, the bounds check of:
	ndp_index > (block_len - opts->ndp_size)
will underflow producing a huge unsigned value that ndp_index can never
exceed, defeating the check entirely.

The same underflow occurs in the datagram index checks against block_len
- opts->dpe_size.  With those checks neutered, a malicious USB host can
choose ndp_index and datagram offsets that point past the actual
transfer, and the skb_put_data() copies adjacent kernel memory into the
network skb.

Fix this by rejecting block lengths that cannot hold at least the NTB
header plus one NDP.  This will make block_len - opts->ndp_size and
block_len - opts->dpe_size both well-defined.

Commit 8d2b1a1ec9f5 ("CDC-NCM: avoid overflow in sanity checking") fixed
a related class of issues on the host side of NCM.

Fixes: 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040753-baffle-handheld-624d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1210,8 +1210,8 @@ parse_ntb:
 
 	block_len = get_ncm(&tmp, opts->block_length);
 	/* (d)wBlockLength */
-	if (block_len > ntb_max) {
-		INFO(port->func.config->cdev, "OUT size exceeded\n");
+	if ((block_len < opts->nth_size + opts->ndp_size) || (block_len > ntb_max)) {
+		INFO(port->func.config->cdev, "Bad block length: %#X\n", block_len);
 		goto err;
 	}
 


