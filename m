Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5096E3BB57;
	Mon, 17 Aug 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974228; cv=none; b=g3iT5czWeqgKjvsuymLjT55ANvVPExshOJqNU/kBGea/KlRTL6S9pPl58njkPYh2TmjZEe28RbJxIR02wSLb1Uhqn+M0BOV6Ij5p31IxolrPds9/EebYTgKcQP8XsqVV3pUOPDGUxcGfZNL2aoJeRTmSaMOLktUh4vUOlRJsNSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974228; c=relaxed/simple;
	bh=AwOcTOV6SsDWOjoz/cCqTolckSn7nOTOhwC9D5IeQys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ37jpcrtEgvyfS+VciJ9ggKzFsPvjMPLwMnsVX06fmFoLOTOsQQws9z0hKEniU0WFnTtKnxCzHMGU4lVvrOBS0Fs7puooAVePpiumdP0Dm3nrMlXCQoocnt0+QimWPc25gt/R1hqI2eOH95FTM1a4s4efAyUFVNzzXByzLBQGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZlhkmSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZlhkmSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B251F00A3F;
	Mon, 17 Aug 2026 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974227;
	bh=pCGAXd86nX5EO5IoYcVx03El2DBCX7lq432Ol8Of7vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZlhkmSL280TizPmYW74KT9sRgjR5+yGcaDYQaC5IJNBIAWfHjXNgj+estW87j1Cf
	 6XXrCys/HoWYDt8Q7rG9O4MILcQ1TV0KSfMUhi+qw7akJvjossfgE8waZIB41XBxOG
	 VKp+VF9KVs6a4H0PJNXMh1o3k1jwDlCt6o9+NJDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sonali Pradhan <sonalipradhan@google.com>
Subject: [PATCH 7.1 134/271] usb: gadget: f_ncm: Use unsigned int for ndp_index
Date: Mon, 17 Aug 2026 15:30:59 +0200
Message-ID: <20260817132542.367521796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit 6b1c8a9403a26cb0fed7a648916c74dc236da591 upstream.

The variable ndp_index is declared as a signed integer, but it stores
the return value of get_ncm(), which is unsigned.

A malicious host can supply a large offset that overflows the signed
ndp_index, making it negative. Because ndp_index is compared against
unsigned bounds, this negative value bypasses sanity checks and leads
to an out-of-bounds read when calculating the address of the NDP
block (ntb_ptr + ndp_index).

Fix this by changing ndp_index to unsigned int to ensure consistent
unsigned comparisons throughout the function.

Fixes: 370af734dfaf ("usb: gadget: NCM: RX function support multiple NDPs")
Cc: stable <stable@kernel.org>
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260720165654.2224591-1-sonalipradhan@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1171,7 +1171,7 @@ static int ncm_unwrap_ntb(struct gether
 	unsigned char	*ntb_ptr = skb->data;
 	__le16		*tmp;
 	unsigned	index, index2;
-	int		ndp_index;
+	unsigned int	ndp_index;
 	unsigned	dg_len, dg_len2;
 	unsigned	ndp_len;
 	unsigned	block_len;


