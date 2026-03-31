Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32A3426D23;
	Tue, 31 Mar 2026 16:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975032; cv=none; b=LD0IPGVbvTd1k//aERb7N8hxgbEa18B75zlVnLgTRxC6wkELpSIzpvDpqvs6ZL7lmWMChgNeVk38blQWwDG2cWi6TQbl59+p+0VE2eiNqY2GwLf/oMZ56BzHl7VB/51HqvXVaz9DzTIufnm1A43BN99Z6MF1jvqW2428Lm089Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975032; c=relaxed/simple;
	bh=iErTbnJBxuP5b+Y3Gx3CnMgvRGLrRgOrabDnDl9IWcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNtZTCpXqLFnPVW9ei8/cnaRFw5MY7dExyagVDoaqH/Fdw5SkhZGk4kP26TTa9jsQJ/LpUZPpnS+giGKlnvKL2BdB0ZK1a+IXJzT2IoVvY2Sn9DGERZXxjcF+Ozk2PI/3Z2tiW73ZYZcbADMNo4r019NEtq/pSnmXxaU0db0RjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DJ5ZZVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DJ5ZZVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4846DC19423;
	Tue, 31 Mar 2026 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975031;
	bh=iErTbnJBxuP5b+Y3Gx3CnMgvRGLrRgOrabDnDl9IWcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DJ5ZZVLIGRdk177v9xhUVnhXOR9gg2OEjbj0T+7kgYJVEqFpSCnqgvjYZ+gRWEEb
	 6Ia0ZId1a/owKRo8DtGOxisfPYvn6uVAw8t//X/a+OchD/6s5Da9u+Utk5X10a4crS
	 NsKleDzMm31XmPqMfYWBixcTAY7BRrqushq3JI+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 138/342] Bluetooth: btusb: clamp SCO altsetting table indices
Date: Tue, 31 Mar 2026 18:19:31 +0200
Message-ID: <20260331161804.086322563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 129fa608b6ad08b8ab7178eeb2ec272c993aaccc ]

btusb_work() maps the number of active SCO links to USB alternate
settings through a three-entry lookup table when CVSD traffic uses
transparent voice settings. The lookup currently indexes alts[] with
data->sco_num - 1 without first constraining sco_num to the number of
available table entries.

While the table only defines alternate settings for up to three SCO
links, data->sco_num comes from hci_conn_num() and is used directly.
Cap the lookup to the last table entry before indexing it so the
driver keeps selecting the highest supported alternate setting without
reading past alts[].

Fixes: baac6276c0a9 ("Bluetooth: btusb: handle mSBC audio over USB Endpoints")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a41bb1e2a279a..4e161dcca00d8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2378,8 +2378,11 @@ static void btusb_work(struct work_struct *work)
 		if (data->air_mode == HCI_NOTIFY_ENABLE_SCO_CVSD) {
 			if (hdev->voice_setting & 0x0020) {
 				static const int alts[3] = { 2, 4, 5 };
+				unsigned int sco_idx;
 
-				new_alts = alts[data->sco_num - 1];
+				sco_idx = min_t(unsigned int, data->sco_num - 1,
+						ARRAY_SIZE(alts) - 1);
+				new_alts = alts[sco_idx];
 			} else {
 				new_alts = data->sco_num;
 			}
-- 
2.51.0



