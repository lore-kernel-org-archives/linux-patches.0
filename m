Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55D628751B;
	Mon, 12 May 2025 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071809; cv=none; b=JzurIjYO5i5Pgx1rpzFQhGv41UGU6pY/JvAmCTTpDBefiHHwq+TSmi2QneGNRryjwWYJgPFv+pfnecAGLhrhq5urxqIP9GvmHNk+9JUWxRQ73cifgiZsfE62C5Mm5E+moNYJqbWRryZeq/d3TJS6mLaabm81Tv4Q3ARao/QThqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071809; c=relaxed/simple;
	bh=k+9ZcLoS0vZhOZC7iU8PjBdvWCayhN9Qr+xeMdjmrPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5BX9UBMV1VIdpHIhkFxnfc4uoyCasWi+LAyZ1c4FxKNYLe5ecJi5MtW4RjArP3nH+va6xw8ETfPe/MMnFxgYa9LOz2dDlkBRugH6L1Suk1E0m2s7eiKElEHtZ4va7X5sRPUvp7doTw6a7RI4xMe1Vv2+6XSvsZSI1qsVLknfCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJ8FUsnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJ8FUsnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB64DC4CEE7;
	Mon, 12 May 2025 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071809;
	bh=k+9ZcLoS0vZhOZC7iU8PjBdvWCayhN9Qr+xeMdjmrPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJ8FUsnbLy9xjz7TGBZK0ZDn9peRQgRATPGxnNm7j/eOgx9llgBq0q1AkksBbIbE+
	 ftW9wPX/GQnWk3ymVxrpj2+RODokFivdDVVbKt3h78JkIIOU01bJ7ZBE/gqlb0rFka
	 3hm5UjjKJ6NJ+0mjbIFKMDnbRS/zuV4is6y9xpFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.14 008/197] wifi: cfg80211: fix out-of-bounds access during multi-link element defragmentation
Date: Mon, 12 May 2025 19:37:38 +0200
Message-ID: <20250512172044.686800428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veerendranath Jakkam <quic_vjakkam@quicinc.com>

commit 023c1f2f0609218103cbcb48e0104b144d4a16dc upstream.

Currently during the multi-link element defragmentation process, the
multi-link element length added to the total IEs length when calculating
the length of remaining IEs after the multi-link element in
cfg80211_defrag_mle(). This could lead to out-of-bounds access if the
multi-link element or its corresponding fragment elements are the last
elements in the IEs buffer.

To address this issue, correctly calculate the remaining IEs length by
deducting the multi-link element end offset from total IEs end offset.

Cc: stable@vger.kernel.org
Fixes: 2481b5da9c6b ("wifi: cfg80211: handle BSS data contained in ML probe responses")
Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Link: https://patch.msgid.link/20250424-fix_mle_defragmentation_oob_access-v1-1-84412a1743fa@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2681,7 +2681,7 @@ cfg80211_defrag_mle(const struct element
 	/* Required length for first defragmentation */
 	buf_len = mle->datalen - 1;
 	for_each_element(elem, mle->data + mle->datalen,
-			 ielen - sizeof(*mle) + mle->datalen) {
+			 ie + ielen - mle->data - mle->datalen) {
 		if (elem->id != WLAN_EID_FRAGMENT)
 			break;
 


