Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8BC3AFB1A;
	Sat, 12 Sep 2026 18:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237169; cv=none; b=tPJNAAaofWm4sFfVPSAqb2ao2rOSAAkYIKfdFZFMh3wFDN4/tMT5Ony3aVqJ0acobgejvWmwzWcFyk1yqwmxfqJDM09TVAZOTi8ivfTDH+I56MJzUYqLcoFHch+u4latQRjBfpxqRIXlrQvicLOHDJL3bQn5+JcUixum2Vn+7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237169; c=relaxed/simple;
	bh=DC7Vuv7Yat9JL6VljBTgs86CJfAAGOYwsPRyDhslbb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOnAdktmKlhnUJmfhEz0+Jlkf+ZV5BFu8ETjeUjIqR45qTnoNaSwmXGzOuGiVQgdRwwtO4FfP1j2DwHajxLGzxeoQ/PhzO9fjc7N7ah6OKddtDy0pHUrl2srzNJSfrzRH4/I8dxvKJtH2Hp1RMVV1a0g/S6r0ea8+EneiJyAOto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khCC63qU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khCC63qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B161F000FF;
	Sat, 12 Sep 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237168;
	bh=WkbA6wdhS88vVE11B3ij9ueIHTRj1BeDGNhr/oaLAKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khCC63qUTxzroM/wBLSWPQuzhibkCvx0pqpcoyayJoC8AaFZMBvLvaXfacr8GjqTV
	 Wn4NZLNjc8vwrwE1CWInFAXX1k3xfswzeMPM2CjWICD+e1IRRFVMbnCZHhMJUZBlz9
	 FxlD233v4V/LP8rQuDaZhc5ryfF73R3uXUT8RAoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 203/935] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065531.473136096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 0d10db8e94fcb23a799789aaa696b4d8f937e207 upstream.

The memory allocated for buf is not freed in some of the error paths in
brcmf_sdio_read_control(). Fix that by adding vfree() calls.

Cc: stable@vger.kernel.org
Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
[arend: rework as suggested by Johannes]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260803093506.1647790-1-arend.vanspriel@broadcom.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1825,17 +1825,18 @@ gotpkt:
 	if (bus->rxctl) {
 		brcmf_err("last control frame is being processed.\n");
 		spin_unlock_bh(&bus->rxctl_lock);
-		vfree(buf);
 		goto done;
 	}
 	bus->rxctl = buf + doff;
 	bus->rxctl_orig = buf;
 	bus->rxlen = len - doff;
 	spin_unlock_bh(&bus->rxctl_lock);
+	buf = NULL;
 
 done:
 	/* Awake any waiters */
 	brcmf_sdio_dcmd_resp_wake(bus);
+	vfree(buf);
 }
 
 /* Pad read to blocksize for efficiency */


