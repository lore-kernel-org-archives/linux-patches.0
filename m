Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5C7261B9E;
	Sat, 30 May 2026 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163686; cv=none; b=sDONx/jy7WC939seaOgCU3od3f0VswRzp+DUKFbahoisKWwPuOwV4Df/GfJb1fwr3KMjdDglfmUTqq7v+GDmi2CWiTDt3jvO07+M42/2Tkk1DjE3nJ/kOC8DqsrrdcAtLs1SPDWSfJ3Rogjiyqhg8BjS75+SRnUII4PI/NAKLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163686; c=relaxed/simple;
	bh=OYFNNuXOjli8aWivnMShWt547Cysr8vAzlKX0/NBCmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l43cTIhGUNglq2IQCyOG3oIBd+2UTlwt6di//ssEhKi39Mvo277ZJa8PS/U7DbFcK0RHqPHGaktX4EAuhgIygbwK+388F7ykEN69+a4F1Ekq9ah6m/JieegbQc6rjhYbI6zGDWU9FiIO//3XU+modG/u8OuYielNK4avvnEv/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyCGxSkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyCGxSkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4671F00893;
	Sat, 30 May 2026 17:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163685;
	bh=jkEU9G3LivK0Wvh6S1sfpZnmJaulc0+hjYUFOfViI1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QyCGxSkvz7Ew2zhKncAYe0ecLLi6afKHfMgfvHtWkhi5ZDea8KN5FA978PNhtrniq
	 m3NWSw9h3cHPhuAUQnINlvoTm37EqvTOWi3dT1XtYJEZJWk7pIa9V09giZMqnTFUKj
	 2i3eNePbkwTMhYncP6FP99UfgFTNT+5/DkpS4mfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 292/776] wifi: b43: enforce bounds check on firmware key index in b43_rx()
Date: Sat, 30 May 2026 18:00:06 +0200
Message-ID: <20260530160248.107276824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 1f4f78bf8549e6ac4f04fba4176854f3a6e0c332 upstream.

The firmware-controlled key index in b43_rx() can exceed the dev->key[]
array size (58 entries). The existing B43_WARN_ON is non-enforcing in
production builds, allowing an out-of-bounds read.

Make the B43_WARN_ON check enforcing by dropping the frame when the
firmware returns an invalid key index.

Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Acked-by: Michael Büsch <m@bues.ch>
Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260417111145.2694196-1-tristmd@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/xmit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -702,7 +702,8 @@ void b43_rx(struct b43_wldev *dev, struc
 		 * key index, but the ucode passed it slightly different.
 		 */
 		keyidx = b43_kidx_to_raw(dev, keyidx);
-		B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key));
+		if (B43_WARN_ON(keyidx >= ARRAY_SIZE(dev->key)))
+			goto drop;
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
 			wlhdr_len = ieee80211_hdrlen(fctl);


