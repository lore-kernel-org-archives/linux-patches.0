Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950B243E48B;
	Tue, 16 Jun 2026 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622916; cv=none; b=kRvItps+CAMjpJS7pfB6m7KklZaXCXP38Ji4DpYeC346CNVY74TJnJMvDlaJGVNy0XhrsFwTnrUMj/RI1yWYQJeAR5FSix0V6PVCiNbYLGYmX2iN2w6n784NyzZ90YY9Yv34fBxcrv2pPcRYPFqiRkSDs7hdecG0W0a7MMhvfYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622916; c=relaxed/simple;
	bh=3G8JVLJrMrx9dbRaruQvi/DkvRBmCdHKjyt6lCAiqwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaSTMYrY83pRqzMNhckLKpvGKrDzu4I/q4UjQFUrKWz5KP98DSD9cpWGf9q38joqL3CqyaEwAgzqStJ3eyza0CNHCSmicePRh4aCALdrXudsfG+QPrxCud0N9CzQLGBJyIE/DU6O0JlvxEUtFVtKxelMgpbxoBL15fGZBfIhikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpkZ08Ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpkZ08Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D341F000E9;
	Tue, 16 Jun 2026 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622915;
	bh=IrWVsSBhnrABPHOWVVDIPpaEzghk/XOuP4145gk1mho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpkZ08GemyV/pPjSTuc1wwCg5OfmX/tC2yYJvpco8u7OTjNSEF5FsogOdm7HKUwDf
	 hQJipuYR9Kpv3eylfs5nox3Rqcukh9C0k7E6o6HZYCU+rAU1A5QRDbZs0k8eTTmsbi
	 EkLf7kY99QHlEcNi9DzESrh+jhuN1xgavtFho8eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 053/378] Bluetooth: MGMT: Fix backward compatibility with userspace
Date: Tue, 16 Jun 2026 20:24:44 +0530
Message-ID: <20260616145112.752493599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 149324fc762c2a7acef9c26790566f81f475e51f ]

bluetoothd has a bug with makes it send extra bytes as part of
MGMT_OP_ADD_EXT_ADV_DATA which are now being checked to be the
exact the expected length, relax this so only when the expected
length is greater than the data length to cause an error since
that would result in accessing invalid memory, otherwise just
ignore the extra bytes.

Link: https://lore.kernel.org/linux-bluetooth/20260602204749.210857-1-luiz.dentz@gmail.com/T/#u
Fixes: d3f7d17960ed ("Bluetooth: MGMT: validate Add Extended Advertising Data length")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 027b266ccc747c..f4aa814a039759 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9114,8 +9114,9 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	BT_DBG("%s", hdev->name);
 
-	expected_len = struct_size(cp, data, cp->adv_data_len + cp->scan_rsp_len);
-	if (expected_len != data_len)
+	expected_len = struct_size(cp, data, cp->adv_data_len +
+				   cp->scan_rsp_len);
+	if (expected_len > data_len)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
 				       MGMT_STATUS_INVALID_PARAMS);
 
-- 
2.53.0



