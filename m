Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F2317727;
	Mon, 27 May 2024 19:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838297; cv=none; b=C8900hLYnRH6YjzGZsKQLgfTOfhDJs2y4VeYyV9CQVwnQm2QJi9h/r7Dm1YtyZrxJ3IQ1rgx0rdHcRZAwldYVPXSeCwf0QvTOOb5bfELY8aeqYxf1hDynEsJVjdA4F9RcwZEdJpIyFAi96OEqQe8u5IH7eJtgyFSQrqbfpKGkbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838297; c=relaxed/simple;
	bh=VMFZZ+JD1NjC9LAyPUTNTHpKg5hc4oLbg4s35q20zeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U++/kmlnpecGlR3Sld7Bh60Y3UYhJYXt6c2xUIhp24EDxVpaI2STDFJvErWYjsirMW9TkQ/MvxEKdkLzCIPOY62MC2ueJhcRDK7uSG5qdXW5yjjjf1ufBRzTQFxi194PUkNGwXINUxI9Pkk2mrgWSjmkmFELH8wE6Ev9LyfDZls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAYLK2j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAYLK2j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E42BC2BBFC;
	Mon, 27 May 2024 19:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838297;
	bh=VMFZZ+JD1NjC9LAyPUTNTHpKg5hc4oLbg4s35q20zeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAYLK2j23y6rnbMR+23m8ZOZSEH78vDQERMraTH0M6UCi5PTqmkDa+F/e5EjbW+s0
	 N242OLLnBLhnrzIi2exi9Y4hC7fKfIVwKzfYDXDtBDSSz/4PtL1wbalh6VSJaEwszz
	 6Pfhr2M+/Vyj2tAWL+HbwOp0V5YxFQ1j1t1jhXew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 338/493] Bluetooth: qca: Fix error code in qca_read_fw_build_info()
Date: Mon, 27 May 2024 20:55:40 +0200
Message-ID: <20240527185641.332707258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



