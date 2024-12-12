Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1552210CF;
	Thu, 12 Dec 2024 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020702; cv=none; b=mA8wu7dY00ZCMYX92yvpicMvFePJkN1kNfHpwD0Hgei3qm7sg146dsDKEH2e4/EiU2Dm+7gpnPP4ym01zzSaJ1C1M+KWJ+uVLLGBIuIU3clPjM5Qxahw7NjbFwrqJM6WrZGAu3hN3plHycE5i26eg+u3OIMt/gwVRkXBBzKO3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020702; c=relaxed/simple;
	bh=CJtDW593F2IzLLtTfq0aqYqFXIPQkqVrhZKW4T9Rpyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBkyrM+IeZM9OkPqRXxfKYkVUo7QZSh8JKPVra8/Dz3euxTla8o9QQPb6bcvZp8chNY3c8nARRK5OesU3tLmYFrjpY28SWCoY3a28e/TaiHJk7Jm1qnvJ6eFS7LBObcD3RmOQPpaH8dGCAjScOyvjIeahimhzv/H2h5Fm8nEeh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQx/9/XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQx/9/XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68545C4CECE;
	Thu, 12 Dec 2024 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020702;
	bh=CJtDW593F2IzLLtTfq0aqYqFXIPQkqVrhZKW4T9Rpyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQx/9/XO9thkbLjeDgbFe19fTujb7RLv72JGGwbehMqONwEQUrUujNZYb+ApvpVv2
	 oLf7p6C6SC9v/7/mNO587MDIKI29jNf/ImJWK7Hh4Ejlcx0Cs1qnu+oL+eKoZ8ZamR
	 rQfYxP3lBUoQIlr+CHj/thaWsVP+Y17xCHB/NOh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Forestier <florian@forestier.re>,
	Louis Leseur <louis.leseur@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 537/772] net/qed: allow old cards not supporting "num_images" to work
Date: Thu, 12 Dec 2024 15:58:02 +0100
Message-ID: <20241212144412.161334020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Leseur <louis.leseur@gmail.com>

[ Upstream commit 7a0ea70da56ee8c2716d0b79e9959d3c47efab62 ]

Commit 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
added support for populating flash image attributes, notably
"num_images". However, some cards were not able to return this
information. In such cases, the driver would return EINVAL, causing the
driver to exit.

Add check to return EOPNOTSUPP instead of EINVAL when the card is not
able to return these information. The caller function already handles
EOPNOTSUPP without error.

Fixes: 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
Co-developed-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Louis Leseur <louis.leseur@gmail.com>
Link: https://patch.msgid.link/20241128083633.26431-1-louis.leseur@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 16e6bd4661433..6218d9c268554 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3314,7 +3314,9 @@ int qed_mcp_bist_nvm_get_num_images(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
+	if (((rsp & FW_MSG_CODE_MASK) == FW_MSG_CODE_UNSUPPORTED))
+		rc = -EOPNOTSUPP;
+	else if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
 		rc = -EINVAL;
 
 	return rc;
-- 
2.43.0



