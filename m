Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E268F4FB9C3;
	Wed, 30 Sep 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787793; cv=none; b=rb+jIhX3uvFVIoekHgvDqr0s2gpCEjgz2s1plKF0/uuCDqCAO5zuEmefe3EnlGTEqNfb5aHgFUrorUCgl9BkJNxKVv0SkLwJMneIzXrnBOel6Wj+DMQPI6q/JNiE6gBoJcF1e4oswpPDmu/E6X84tx3f9a1I/0Z4bXOyl2mlZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787793; c=relaxed/simple;
	bh=UpLIM6T1SGHvMow93z+r+NiILiMAoEz3T3KxMxnHQUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHFNOdCd/z3aYE+fRCg5MkdGp/DUeMeiBtUCTvt3pkgkAFXlRR78txq/sDro9LcK8uDrueMxCTQQsFrABnVr16KANh/Rk/xu1H5m76nasyvVnynoI6Kl+2U+KD3D1EeVMmHWLDl5Hv4BJVsYTOE3KsrOmP4wP4XzKvFaWaGrdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrHxljxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrHxljxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103861F000FF;
	Wed, 30 Sep 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787791;
	bh=XscU+tZAzw8U4qfIbbKrbawhSx8GZkJGk7NmPt3x6kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrHxljxi5ZOgjaO6DR4cOBPE2tskOiagguqjhukq5Vpv1mFiKup5tAIdsS1oV66+N
	 mdo9CK1y7H4vO1H8HxXHi+HYb7bDUpaGYw02hyN9ffKXbxPOmMBJZZ+VDndlrEosZ2
	 eLh3I1APEea2BZ8RDIDAWfD0noi+HGMQVK3X8ebQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.2 356/457] nfc: trf7970a: power down on startup RX gain failure
Date: Wed, 30 Sep 2026 17:27:41 +0200
Message-ID: <20260930152353.691892391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit d2acbde7e67df44efa8f0963462d1192e7694ffc upstream.

trf7970a_startup() powers up the device before applying the optional RX
gain reduction. If the register read or write fails, it returns without
undoing that power-up. Probe's unwind only drops the separate regulator
references acquired by probe, leaving the additional VIN enable from
startup unbalanced. The system resume caller also has no power-down on
this error.

Call trf7970a_power_down() before returning the RX gain error to deassert
the enable GPIOs, release the startup VIN reference and restore the
powered-off state. Runtime PM has not been enabled yet, so the full
shutdown helper is not appropriate here. Preserve the original SPI error.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5d69351820ea ("NFC: trf7970a: Create device-tree parameter for RX gain reduction")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Link: https://patch.msgid.link/20260913042625.31296-1-mhun512@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/trf7970a.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1997,8 +1997,10 @@ static int trf7970a_startup(struct trf79
 		return ret;
 
 	ret = trf7970a_update_rx_gain_reduction(trf);
-	if (ret)
+	if (ret) {
+		trf7970a_power_down(trf);
 		return ret;
+	}
 
 	pm_runtime_set_active(trf->dev);
 	pm_runtime_enable(trf->dev);


