Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C02A3C09E7;
	Tue, 12 May 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608314; cv=none; b=Fuw2eouQhDBIqUGG4nufegxdpCMmrKBExSzXB5Qlba96YFssyWhD/k4jIt/vvODKnNIZ9SJa+MP0SjyBotp5Q2v9iMDqcV78PZyk4Do/CA0dlSoii158aWlwuJ8U5It8Osw8kWh1f3UMmuLQbjuWqO+iqU2/F0Q+VImtLuwDgEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608314; c=relaxed/simple;
	bh=LkAGbcf20sI8+2Ejy2GBJCVQA6oiFT3w8prsb2Qoz4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUHc/myNWnVeGgMQE7rOXJept7uksn4IZn27Vr4RBOoW3tU/sVmuMoMkjIHOeC/5zxSK1usrrSzzQ3aQBELHNgGRhgmbcBKH3dWLevFbFl4oo5hOubFMMtGUH9Vb0NJeDwejPrWxl4Db5mkNs1ol/LFmatXUCsSkbam02GCuoGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trUcdD6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trUcdD6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6899C2BCB0;
	Tue, 12 May 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608314;
	bh=LkAGbcf20sI8+2Ejy2GBJCVQA6oiFT3w8prsb2Qoz4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trUcdD6N9BZqU8DbF+vBw6/bbP2H+q0j6OYxo4hcXBznKpiMUkt+Vjdmt2J0hk8O9
	 7ooqlYIhtj/lisjaxfbujbbX05hD+sEBCLGph7VqXatZ2Jc1IOTyffw6o65FIK+EJB
	 gaUK0IreXXm0nVqOoplo4SpxxsEX2H374eVN1CCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 030/270] wifi: b43legacy: enforce bounds check on firmware key index in RX path
Date: Tue, 12 May 2026 19:37:11 +0200
Message-ID: <20260512173939.091307307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


