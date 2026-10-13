Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B64FDA59;
	Tue, 13 Oct 2026 12:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895956; cv=none; b=ONbQ/dC2XPZaN9phOL07P8n66DHbmQLklEexN/tDO9Kam6GKFQ3FfVW7cpapelLFZ0joJHswJEtxv0iAHu3mC2AwW0svvnWINbrGgY4Ycep1ohEHP8LuB20eRUlisCUZ92VPoQ52ve7IuFGyOgyoLHprg9CduChtdjnic+HtwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895956; c=relaxed/simple;
	bh=M2AAmWripVfLBVxIpZ8fKkGgkDWg6JdHEIYlMX+4qfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoIxqOF2453iYGih7+waQk8ZplLixyhlPoInnA/KUC8o/ZfIRZUf4VSLxtiL/QtULdiQGvM9yaAcIj3hQzKLzkRcpMT80zA6PElurtmfOPav+75np91WgWSe882iXTwpFqBDVTa5c8JdyfFLVdqsGLAuXDxl7JM06COZxq8rX9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9QuiLhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9QuiLhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C951A1F000FF;
	Tue, 13 Oct 2026 12:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895955;
	bh=k28s8Q+VBvgFQ/8H4eacuXDLDZhiTcuyauICPVeS08s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9QuiLhswzdwZcbcTwH1X0OSn6Eisk2BnHIFfqcSIkTCBO7mdecLbQ9EDkwgEe9fH
	 xtCl5uzZRgzq6h5n/66UVokWZ+z3lmytVMhXvSyE5P9pgbFHxnPjFxuiGFRSttM38g
	 ZClCbSA0lFcUPHigbgb22pksWsU7BOjNwSUq56Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 448/497] Bluetooth: btintel_pcie: fix TX descriptor bounds check
Date: Tue, 13 Oct 2026 13:40:15 +0200
Message-ID: <20261013112918.515315819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 735ebf2c33798..68e22f6022afe 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -145,7 +145,7 @@ static int btintel_pcie_send_sync(struct btintel_pcie_data *data,
 
 	tfd_index = data->ia.tr_hia[BTINTEL_PCIE_TXQ_NUM];
 
-	if (tfd_index > txq->count)
+	if (tfd_index >= txq->count)
 		return -ERANGE;
 
 	/* Prepare for TX. It updates the TFD with the length of data and
-- 
2.53.0



