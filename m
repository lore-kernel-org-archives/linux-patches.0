Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24551FCFFC;
	Sat, 12 Sep 2026 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223332; cv=none; b=htfk0AF3QOjHlyxk6PO+hqz+VtSEUyhUzESW99Kmp/4DkV/nEPBj3Z2oZ8uyJeb3EtLS2YIgLmVsZE0czD/UlsOVIpMd9CCJSPfbC9Q9iyPtnCZF4GJOCLQin15WyfmjQzB76CFJoH/4+k7MqwicOSOF8pvoKPreQRfTckiLFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223332; c=relaxed/simple;
	bh=DAms+81qYwi3dXApMGLRKmXETBt64xyYkypR5jIzz6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoxONt5WZ1l0UEEM7r2ZPI2pKFU1CRDXodnZ0314iNNIptRWOhl9+CjrBXHSTFRaXrKzBABIBJLR6/qEFoa+SRIgfgE+Wh59noTazaKhEdN61+LKdsX/bySx++I5Th3SGXC7FJd54/oFM8d5zd+q9J3QIYJ+eIQzDbsD+Nl9l8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mf2Bw7O5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mf2Bw7O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2401F000FF;
	Sat, 12 Sep 2026 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223331;
	bh=Hwaf+sSZybAXOclnkW2G3W0IAmzu5AsE6UbA8oz6Eg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mf2Bw7O5nKd5SPRbv1D98M+libPaNdWj/mFGAxn4diPCSaPGvoQFvFIy9lhFXO8B3
	 iOK9AdbuBw4d2bWpvpTTLtjLFI3E0WV5u0NfeMeeNamIPwkhtlyHMeFMVyjBV6L3DR
	 l5cA5uhvtaT2NNQ54BDly6OfbI2mKQVhR/Bn5O0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0725/1424] ALSA: hpi: Check transport errors during HPI6000 adapter initialization
Date: Sat, 12 Sep 2026 08:52:37 +0200
Message-ID: <20260912065623.526841041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit cc15c329663e3ef1aeed0b68e49a5d5ce4ae0d5c ]

create_adapter_obj() retrieves adapter information by calling
hpi6000_message_response_sequence(). This function reports transport-level
errors through its return value and DSP-reported errors via hr0.error.

The current code only checks hr0.error, causing transport-level errors to
be ignored. As a result, adapter initialization may continue with an
invalid response.

Check the return value of hpi6000_message_response_sequence() before
examining hr0.error.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 719f82d3987a ("ALSA: Add support of AudioScience ASI boards")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Link: https://patch.msgid.link/20260708141147.18253-1-evg28bur@yandex.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpi6000.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/asihpi/hpi6000.c b/sound/pci/asihpi/hpi6000.c
index 72aa135d69f85..8aa5832f1f2a5 100644
--- a/sound/pci/asihpi/hpi6000.c
+++ b/sound/pci/asihpi/hpi6000.c
@@ -537,6 +537,11 @@ static short create_adapter_obj(struct hpi_adapter_obj *pao,
 		hr1.size = sizeof(hr1);
 
 		error = hpi6000_message_response_sequence(pao, 0, &hm, &hr0);
+		if (error) {
+			HPI_DEBUG_LOG(ERROR, "message transport error %d\n",
+						  error);
+			return error;
+		}
 		if (hr0.error) {
 			HPI_DEBUG_LOG(DEBUG, "message error %d\n", hr0.error);
 			return hr0.error;
-- 
2.53.0



