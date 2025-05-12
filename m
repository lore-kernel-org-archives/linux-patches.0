Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737272957BA;
	Mon, 12 May 2025 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073250; cv=none; b=qCXoKS8Lv9dxUQqAgBmNHMf7r/pzDsKTi7/avNuh4FgS5Oir4t2Tkmot+7rxPIBWbSrQHy3OLZsunCnZ1ugWLABfRSipr4LL3Wk0e98iztvMGHeOHgHXytdoAhrWVbUFVoJOEYGvzCvbrBU9ztIgEnMLcS3v6/PvRpC2wo5VfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073250; c=relaxed/simple;
	bh=oY09K1Y47VbL3Hor+z29qGa/ioou0uQdUuhiNQlirDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC9Ffwcv0BHsmhSfHPeGVWIxFbkGELvGiDDs7h7VmNEsZ51RSmfW1kIR+vLbZsYNosqwnsVi7RuajCz5xGfdlac6d2WPASTg2FWiQhKpmycLZ1Myvp6DjUFJordx9ioZI6NUk6sapeObKgXse1V0L8NVtXgpJyZBHCLY43B1Tlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpWssnsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpWssnsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E29C4CEEF;
	Mon, 12 May 2025 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073250;
	bh=oY09K1Y47VbL3Hor+z29qGa/ioou0uQdUuhiNQlirDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpWssnsJs+XQWJto/I9vqXvXAd4tiTL1MU3QorBLrMoCWweu+j/5aGN6K7b2VBvid
	 Kb9e+WISi+W/EuSbFF+C2Bh3ftraZX6CJBp478KBiW368Iy/L2rCTw1FDmUzPeKZTt
	 wMsJAvsxGBIVBpdSLfbm9acm0N5QuegfdJAVTFYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 004/113] wifi: cfg80211: fix out-of-bounds access during multi-link element defragmentation
Date: Mon, 12 May 2025 19:44:53 +0200
Message-ID: <20250512172027.882137086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2511,7 +2511,7 @@ cfg80211_defrag_mle(const struct element
 	/* Required length for first defragmentation */
 	buf_len = mle->datalen - 1;
 	for_each_element(elem, mle->data + mle->datalen,
-			 ielen - sizeof(*mle) + mle->datalen) {
+			 ie + ielen - mle->data - mle->datalen) {
 		if (elem->id != WLAN_EID_FRAGMENT)
 			break;
 


