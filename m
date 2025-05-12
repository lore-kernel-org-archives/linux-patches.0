Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFE6254863;
	Mon, 12 May 2025 17:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072714; cv=none; b=LYdJCxTrZrFHOt4SRPGIdPxVDF/YLFGOU8Dx/uwIikYYFkgMQHDYuOHcxs7yUGRUWLEi5a45OXZPyx3efOLjxyR7LJ+cClR+oYQjGXpWZjf1uxHoYj2uofhGykbz2F8SiXt0SNhY7oG7FrR5iczEiFjhFab/5LaLrHZnnkI2TRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072714; c=relaxed/simple;
	bh=Q36xFH3zuKPSw9hjvYb+Y/rFFnYuRqw53ObxGNeVGsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwEV2NHUraJdVNBUXSu6rlZAtDcCpEiAvzZZqQ2/tru5qhje4A0gTfT5sWHQSi4/w7JaV+HQpZ9en2ft2ykmqLWufiLJ1OeGxFBDx9PdH1/96fuqVYiZtXF8zQGkm0T7KX4prjkEy2e/qcwuiUNDnMKKngOzmUgmyq2B1cEBqx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYqtSyWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYqtSyWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEFCC4CEE7;
	Mon, 12 May 2025 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072714;
	bh=Q36xFH3zuKPSw9hjvYb+Y/rFFnYuRqw53ObxGNeVGsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYqtSyWmFu1xOsLZwlJPgkKvUZcXaAbJXgT32ukhm8pCMeikPJ4yNZ6WIejJHpn5K
	 PYVNiXnStpiNt/z9wB3IlWP7eIrQlf3PaaeO3u5tQCPy6G/g+9F9y2UqmK9xczlmFx
	 7RiDLmQQUnBW69XHHmdYXRhe6sPE5XyuacyQUCmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 008/184] wifi: cfg80211: fix out-of-bounds access during multi-link element defragmentation
Date: Mon, 12 May 2025 19:43:29 +0200
Message-ID: <20250512172041.991725325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2644,7 +2644,7 @@ cfg80211_defrag_mle(const struct element
 	/* Required length for first defragmentation */
 	buf_len = mle->datalen - 1;
 	for_each_element(elem, mle->data + mle->datalen,
-			 ielen - sizeof(*mle) + mle->datalen) {
+			 ie + ielen - mle->data - mle->datalen) {
 		if (elem->id != WLAN_EID_FRAGMENT)
 			break;
 


