Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD3143E066;
	Mon, 17 Aug 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979425; cv=none; b=dTHOYaOyVyp5IoCPpFu18jlIjOQN8WJtzXYuO+Ikqh3xqtUDj6VIXap0xkgjXOw/8BFIdXQZUMDdHyaWJjAVMc6akif4udsxOaw6jt1G/En3uu5oyAIo6jxzOjHYqvaIUNu+ggSg8ZmhSHGg9XN+eJMMhPWonpoVOUE0fBrE5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979425; c=relaxed/simple;
	bh=AUb4MXukfcD18+72u73qckMJ1kUq+pG5OwZls4EkMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baI6+PSyedODu6Uur95J7Iz7fEgH69fTbaGv0bpP5/t6a+EHruVDthxh4WsqNUVwN7f5S8sZh7djsI/ex+vRPTOm3kh9f4lNOvW/ySKXuCFPsUkyzwi8BiKK+aGUEzy9SHMpjsZ9wt8m0YPMGEADH776SqtMu5KZQgKRRD3QV3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2LDy4Z7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2LDy4Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB051F000E9;
	Mon, 17 Aug 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979423;
	bh=XFF6DcPMIp8QbcBeIxTtOM7gaxQ9Jxg+n5F8E+7c1cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2LDy4Z7OiFxSuMKa2mzsQXN4h7JNxS/Qvb6XvNiUA0aJRxCk8iWKd0+wml7Lz/DV
	 /3DIpdauVMZmTBJ/Zd4y7KHPHHgoDgR8fEApMTIAERGNm187LiSjFWwnOBuq6YtyB7
	 FNEphYG0oZzt4yFtKGi4XQ/cma04/A1/WzycP8ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 220/609] wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper
Date: Mon, 17 Aug 2026 15:28:36 +0200
Message-ID: <20260817132551.455670996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit c3d68e294cbb6a4090bb219d3dcaca85a011809b upstream.

mwifiex_tdls_add_ht_oper() gates its follow-the-AP-bandwidth path on
bss_desc->bcn_ht_cap being present, but then dereferences a different
pointer, bss_desc->bcn_ht_oper:

	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
	    bss_desc->bcn_ht_cap &&
	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))

bcn_ht_cap and bcn_ht_oper are populated independently while parsing the
associated AP's beacon in mwifiex_update_bss_desc_with_ie(): an AP that
advertises an HT Capabilities element but no HT Operation element leaves
bcn_ht_cap non-NULL and bcn_ht_oper NULL. Setting up a TDLS link to a
peer while associated to such an AP then dereferences the NULL
bcn_ht_oper and crashes the kernel. Every other bcn_ht_oper user in the
driver NULL-checks it first.

Guard on the pointer that is actually dereferenced.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 396939f94084 ("mwifiex: add HT operation IE in TDLS setup confirm")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260716103042.88469-1-doruk@0sec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -215,7 +215,7 @@ mwifiex_tdls_add_ht_oper(struct mwifiex_
 
 	/* follow AP's channel bandwidth */
 	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
-	    bss_desc->bcn_ht_cap &&
+	    bss_desc->bcn_ht_oper &&
 	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))
 		ht_oper->ht_param = bss_desc->bcn_ht_oper->ht_param;
 


