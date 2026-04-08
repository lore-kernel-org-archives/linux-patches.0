Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9503A3D8912;
	Wed,  8 Apr 2026 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671840; cv=none; b=OJ7mmp0BKwVcZmBQiITrq7b2fkF7hEs9YnH6fInmp0Fk5A84ZUTP6HLa5LgSgB6z3wphmaFgAP/MuXhgcCUpwVNKICuKey46Jea0GRJVyvD+dOo/ut6irWcVHtiZ8MvI2ZhZiECnrbjbaFoBIbxPSM2rS0r9Drsq9zs6Pos6GZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671840; c=relaxed/simple;
	bh=FabBSR5bU6WEGGcoBsTFZ5sGhPx0OSmxacFzrNPZvtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNFjh80Rx/ixGLarrXOz3y9MIu9nfi9r7YyVE1BjffmpV1v9/FZczgXiQYUOI2aDK5p+EOLpIPEOJYP/LvIwomsRR2uuvSNx+rgqxHqIODKbQXKQ76NJSkUEiEC4zWPtKVbUNSt/+qkW1qOuuN62Tjpm3KtRg6XmDRpsFeaVHSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8xbrbYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8xbrbYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A434C19421;
	Wed,  8 Apr 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671840;
	bh=FabBSR5bU6WEGGcoBsTFZ5sGhPx0OSmxacFzrNPZvtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8xbrbYp+MfAk3YN5xOoPUQhoLlnSMO78yEPxL02B97DvSLTlarRJ5De+y61LwpO+
	 f+xEGgrDdCgokmLKmKKYBE6dQayyTmcz6FxWIwyIUgDYV7mEGZ5nEsjJPy2l+yu76b
	 s9LlLIUuQdHvXzCtX48+dG5Q0n1KU6ehGfEM9isQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/312] Bluetooth: btusb: clamp SCO altsetting table indices
Date: Wed,  8 Apr 2026 19:59:32 +0200
Message-ID: <20260408175935.792100688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cc5ce7a984f6c..25d713856a103 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2096,8 +2096,11 @@ static void btusb_work(struct work_struct *work)
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



