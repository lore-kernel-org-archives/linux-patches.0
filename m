Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE73A3D5241;
	Tue, 13 Oct 2026 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892477; cv=none; b=UAN+9BYa3KqQDNmJmAMo0fnkMshJtP12rlPThCL/bSRTpkkQp+EOb3cEvELAeCVPSLggi8RcQVdez73A3W45tk5J8olP1TRGzyYaOEstn7ekcpuwteoq3JtCKRa1TCKzbcHMHxUkoqquRg9zA9x+0145+B/wRU1lE/eV0Uich0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892477; c=relaxed/simple;
	bh=Zvk35JGF8kCzJuNgKcJ8m6aEomvXKpDvNasWmj+ueIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgzs7NebYdx3pvHajjnmAyY+tSBz64x+m6qa4B+zTM21kosgT1Br0/S7/8De/8MAX2yQIUBQ2hQ34aqu2r/LiqLNDuCxjwV7UhMBACg1lu8FyQoPovpLVD5DYfTDwnlkHMe5V5OweXGjUuzvbZscpzOhg55BQuHpe+v77dcEurY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jX2d7hPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jX2d7hPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE831F000FF;
	Tue, 13 Oct 2026 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892476;
	bh=0iR6On0bSYTZeXJczWzGMqteFOBnDk+1peiMOcFqHfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jX2d7hPhAsMbgUo7yJ8ScHIrYMYa7xXip0IW3in8Nun/pAZG/faEhFcZRzVq54A3N
	 tQNf8x2A6UHIcp1cn8TPkwe0T2YWU9dkirh5J5NJKZqm+u5CZ63ph0yNelywJow9X+
	 bH43LusyjEG8beYO/stJD1zI8+Ulu7llYUYZFzys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 187/281] Bluetooth: btintel_pcie: fix TX descriptor bounds check
Date: Tue, 13 Oct 2026 13:38:23 +0200
Message-ID: <20261013112859.703206229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Ravindra <ravindra@intel.com>

[ Upstream commit baa53af641c9e3644e717b8dfd1b95a55a0c111b ]

btintel_pcie_prepare_tx() uses tfd_index to access the TFD and data
buffer arrays before the index is advanced modulo txq->count. An index
equal to txq->count is one past the end of both arrays, so reject it in
the bounds check.

Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index ed2a6286892c5..34899a5507339 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -401,7 +401,7 @@ static int btintel_pcie_send_sync(struct btintel_pcie_data *data,
 
 	tfd_index = data->ia.tr_hia[BTINTEL_PCIE_TXQ_NUM];
 
-	if (tfd_index > txq->count)
+	if (tfd_index >= txq->count)
 		return -ERANGE;
 
 	if (skb->len > BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN) {
-- 
2.53.0



