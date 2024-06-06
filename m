Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B85F19AA79;
	Thu,  6 Jun 2024 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683322; cv=none; b=oY9d2Zi26qclbk2mfdpzzoM+7ruei1xf7wNcpZ6ZgePkDwaTshhrF1S+8J/we71OVO2k67mtE8/Xd96CDQNDsVn1B7BRDR5J+LV8VMtlhBGOpdt7TxPtOnpBDhKURRauWNuhOH8UgXe5HU4Ftjfo1dpI4tbwrG7APaWXEnDlU/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683322; c=relaxed/simple;
	bh=sCDbQ3+4yK/luxgDtTY+9ttQ4qFnRDvOPgbC6NEJj0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCyTG9ys3WCYzDE1fyQyVk5p0a7mePrFWm8O1nVcvD2f/nvFFquTzp2Ch2QkrHR0D32LGH7DR+M2kNCbgTvXEY0S3/BPWT2fnmAzNYUZs38dfvwqocswIunA3giJzRhVGiQ0P2CrrQgcdtfYjGxtv3VUAaI71QvjoinFnrAUly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL35378G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL35378G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4FDC4AF07;
	Thu,  6 Jun 2024 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683322;
	bh=sCDbQ3+4yK/luxgDtTY+9ttQ4qFnRDvOPgbC6NEJj0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL35378GObCdrGos0xw5i5O2qJ6fpcJqFcxl+P5Du3oOMWKgnK7BjUY7Qmq68A1Ro
	 Y/DIrYDCvR73Gvvbud62wLAKeAB7Is+2L7QUrfZ+lYxcuOMV4qyDreTuizU/yE4hpo
	 UsTO8J6qLhI11v3fGTNCmjKalSvqJL1Sk7fyKU4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/744] Bluetooth: qca: Fix error code in qca_read_fw_build_info()
Date: Thu,  6 Jun 2024 15:58:54 +0200
Message-ID: <20240606131740.801562659@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a189f0ee6685457528db7a36ded3085e5d13ddc3 ]

Return -ENOMEM on allocation failure.  Don't return success.

Fixes: cda0d6a198e2 ("Bluetooth: qca: fix info leak when fetching fw build id")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 638074992c829..35fb26cbf2294 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -148,8 +148,10 @@ static int qca_read_fw_build_info(struct hci_dev *hdev)
 	}
 
 	build_label = kstrndup(&edl->data[1], build_lbl_len, GFP_KERNEL);
-	if (!build_label)
+	if (!build_label) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	hci_set_fw_info(hdev, "%s", build_label);
 
-- 
2.43.0



