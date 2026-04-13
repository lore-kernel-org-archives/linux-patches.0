Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D59317148;
	Mon, 13 Apr 2026 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099246; cv=none; b=dZiB69oF2LKcjOUTfDdQxY1jqiq7/aOw8v2ObHQjWqoVLuEEwLRsMSOLNI+qWZK4LOwuxKrju31zO/cJXxcoBFUoRxP2TUXVegxlQ542JPBAfWvgzhtU3Lp8e4GLfwgOm09rZFJD6cSmsEKC//qzEbHPpy2QbDoKfz1yN3S8HwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099246; c=relaxed/simple;
	bh=ZrWiu6zqmeJKtA7nQFj/vLnenivoxmNDlvQ1+Lx/E/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtVrpfTDHXyx9+eQmOCOYg2iIheOxDe5Zaopw/KbW+CcllSrU3aFgFJAlwHs5nyKD8EV6xKyXl61sonk5udoNUiQQT3KoG1k6yXGUxWMeLEH3cpg+oFlEwHj7uadBpI52OBHayvLZPhXCUs2sU/tKzhyvSAAOUKykCHGpgCp/4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0uvTbjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0uvTbjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A94C2BCAF;
	Mon, 13 Apr 2026 16:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099245;
	bh=ZrWiu6zqmeJKtA7nQFj/vLnenivoxmNDlvQ1+Lx/E/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0uvTbjMdklgq6q5PV+Ic9upiQ7w+kHc/aC7wsxXiBAHn+67qr1JYPs7Y4VDyKhgH
	 MNcAEDUq9yBl8geda+W+iLqR6AA9E1wMc+SuVVsngc4nZCidcW/mCSWe+NXC2jI8QU
	 ys1kBojjsCiOkxpkBSmZhXCNkyEtniDAIZxfPzcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/491] Bluetooth: btusb: clamp SCO altsetting table indices
Date: Mon, 13 Apr 2026 17:58:31 +0200
Message-ID: <20260413155829.010052703@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3010044f0810b..a27a6ab6c2b61 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1780,8 +1780,11 @@ static void btusb_work(struct work_struct *work)
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



