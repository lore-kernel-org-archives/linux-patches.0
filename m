Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0083EDE55;
	Tue, 12 May 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609069; cv=none; b=uUyHRxFdFudC9htsZyg0eZucBcbrA9zmTNzXTXBEHjf7AVNuGKq4bsQoBjLN91sU2ZvGuwxUpj5ouUB7mx65Z0cX9BRYuFTRNPU9J4fxt4PMvOgiXeavC3PJAf6E/fMkRJuLdMvZOOQ91Z7XOdjEWp+7GEvSsDpg5ZqScI1l1Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609069; c=relaxed/simple;
	bh=Ky0sEBLiwrPooJzxP22px/7qWQd19cQiZg/gSDAZveE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAduuESDx5xd+A5dzFiaSUg/4qe3lOAFE1vgWGBKqdKGe7WGsY3aPdSlSaWJYvJ2QERnm3VHXinP3nK5oraCF2YJiaiNrzwlCUX17Ua/c0brVQNFGLjdzajVZdS3YtrszdAWDF/+8bc8UT29HqIPQtKy4+eKWgcNwz1iseZmbgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+vQTiw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+vQTiw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF0C2BCB0;
	Tue, 12 May 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609069;
	bh=Ky0sEBLiwrPooJzxP22px/7qWQd19cQiZg/gSDAZveE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+vQTiw1qcRLu6DIAMkyvDrpYrgv443xBszEJY31AyLSOjHpmcJUY7X50mNn50zmv
	 TNX/Q2HrhjoTWaOexSRAe6Z8EjNIXmzGrxd+gf30JaN7QtfDss6pq+J2L05xMVTO08
	 WdCuvH4q5RQmg7mHaWlzXXcSHc9r+LhwzH+EJ47A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 026/307] wifi: b43legacy: enforce bounds check on firmware key index in RX path
Date: Tue, 12 May 2026 19:37:01 +0200
Message-ID: <20260512173940.677371002@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit a035766f970bde2d4298346a31a80685be5c0205 upstream.

Same fix as b43: the firmware-controlled key index in b43legacy_rx()
can exceed dev->max_nr_keys. The existing B43legacy_WARN_ON is
non-enforcing in production builds, allowing an out-of-bounds read of
dev->key[].

Make the check enforcing by dropping the frame for invalid indices.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260417111145.2694196-2-tristmd@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43legacy/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -476,7 +476,8 @@ void b43legacy_rx(struct b43legacy_wldev
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43legacy_kidx_to_raw(dev, keyidx);
-		B43legacy_WARN_ON(keyidx >= dev->max_nr_keys);
+		if (B43legacy_WARN_ON(keyidx >= dev->max_nr_keys))
+			goto drop;
 
 		if (dev->key[keyidx].algorithm != B43legacy_SEC_ALGO_NONE) {
 			/* Remove PROTECTED flag to mark it as decrypted. */


