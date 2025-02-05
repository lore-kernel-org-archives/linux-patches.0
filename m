Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224FA15990C;
	Wed,  5 Feb 2025 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765374; cv=none; b=ODuvv0M6h4czTE+4afJhTBaZVeHGXkVfvATcPBotey3Y7qWm/gG0UowqHkC87uBd3mpZHxUWenWCgVavvonSh+dXjxQZY/3HADQPZHRcShrVgSHcCdPUA4NYHqZuAUOxv6uslOGWXEiRLhQNkRfIuMlxksI0qsovYkKy2jWRPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765374; c=relaxed/simple;
	bh=nkyXBCqIaFO6Y/tpOgWLrrP6W7rB/YaSCBXTkxrxnRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q56wo2DuhIk7DnRr1ajrD+Y77ROpbF3ez7zwF2NfqfSnReFFcurRpu8MIybWITp5P9vhHeIPvKBzhVTgnaMNNooRmA+vPIAUwOexenKW58dSAOtM2tRYcfV1xOuGNdWSCHX41kswaTVSmuCkcd2QFBBDlK/qX8lgkINRvQ2MyfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEPHehWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEPHehWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22415C4CED1;
	Wed,  5 Feb 2025 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765373;
	bh=nkyXBCqIaFO6Y/tpOgWLrrP6W7rB/YaSCBXTkxrxnRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEPHehWup/wnPCcT1WTPi1Ov1xPlEXAr5jLLzVw7+4+mifZsB3WcLWATIpkhhTnaa
	 CaxQK5ZJ4nZVX//oEnUgXuXt00RPZpZAaZR/2kyoB+aPlYGZ41s0cerZRc7dZO9+/z
	 g862Z2BAjnhjLaim5X5VJaB/vzQP7DQEstrKAZrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/590] Bluetooth: btbcm: Fix NULL deref in btbcm_get_board_name()
Date: Wed,  5 Feb 2025 14:39:29 +0100
Message-ID: <20250205134503.475198945@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit b88655bc6593c6a7fdc1248b212d17e581c4334e ]

devm_kstrdup() can return a NULL pointer on failure,but this
returned value in btbcm_get_board_name() is not checked.
Add NULL check in btbcm_get_board_name(), to handle kernel NULL
pointer dereference error.

Fixes: f9183eaad915 ("Bluetooth: btbcm: Use devm_kstrdup()")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index a1153ada74d20..0a60660fc8ce8 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -553,6 +553,9 @@ static const char *btbcm_get_board_name(struct device *dev)
 
 	/* get rid of any '/' in the compatible string */
 	board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
+	if (!board_type)
+		return NULL;
+
 	strreplace(board_type, '/', '-');
 
 	return board_type;
-- 
2.39.5



