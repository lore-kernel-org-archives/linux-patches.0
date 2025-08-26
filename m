Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F66B17332C;
	Tue, 26 Aug 2025 11:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207951; cv=none; b=eamGltbpHaszceWIdhF52OpFL9j2YDVrAuL0CTN48rz8IZk4RhIwpDJKYnpz5EZRz7K1yqHsWoM5qCLLgwxrxXpfaNxSfdTfDNJa4oR8kyYTvyzJQrXJ5E1zEH1I5Glu1vMixFBuSOMPk3+EDNazP3dTfz9yPw2IRJ5+BT0FJE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207951; c=relaxed/simple;
	bh=PQvG66Pv2KwdZSyHyLYm54AwgODdy6ov7gOI1fl3cxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoaEmK+9gsB3YL79V/j73NreIsNBRWeZQAUNpopv3RN1Y6GM9TAaKoyqCx3xKLgctjw4vdgZRGRCK/WX5nT1FxU7dTG8yizuMcrqU4h5hAPcSChFF6MuU3S/bjWQXVu/q3gdB/X8rq2d4qbWn3tOUxJcjOcgCpmZKAiG0RgcJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqLEWj/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqLEWj/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38CFC4CEF1;
	Tue, 26 Aug 2025 11:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207951;
	bh=PQvG66Pv2KwdZSyHyLYm54AwgODdy6ov7gOI1fl3cxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqLEWj/oLmbROcmHbojAARm5/3CgCfkt03jbU9g9lJAW4B/quL50K/1vopgT6tk4d
	 T4d5bTVhW0esUis2EcMNBQlq19jou7anFG9lu94Y9Mf2Fwz3iTJ7ML/WzRAYq9eKn1
	 lLhZB1drSouc9XAMHJEF6TxBDZI+2zt4ilUMDEWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 379/457] Bluetooth: hci_conn: do return error from hci_enhanced_setup_sync()
Date: Tue, 26 Aug 2025 13:11:03 +0200
Message-ID: <20250826110946.662665473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 0eaf7c7e85da7495c0e03a99375707fc954f5e7b ]

The commit e07a06b4eb41 ("Bluetooth: Convert SCO configure_datapath to
hci_sync") missed to update the *return* statement under the *case* of
BT_CODEC_TRANSPARENT in hci_enhanced_setup_sync(), which led to returning
success (0) instead of the negative error code (-EINVAL).  However, the
result of hci_enhanced_setup_sync() seems to be ignored anyway, since NULL
gets passed to hci_cmd_sync_queue() as the last argument in that case and
the only function interested in that result is specified by that argument.

Fixes: e07a06b4eb41 ("Bluetooth: Convert SCO configure_datapath to hci_sync")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f5cd935490ad..2d4cbc483e77 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -339,7 +339,8 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 	case BT_CODEC_TRANSPARENT:
 		if (!find_next_esco_param(conn, esco_param_msbc,
 					  ARRAY_SIZE(esco_param_msbc)))
-			return false;
+			return -EINVAL;
+
 		param = &esco_param_msbc[conn->attempt - 1];
 		cp.tx_coding_format.id = 0x03;
 		cp.rx_coding_format.id = 0x03;
-- 
2.50.1



