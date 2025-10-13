Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6458B2FE564;
	Mon, 13 Oct 2025 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369552; cv=none; b=FaMa4l1faAc2aN6P+NROg6buhC1c3AzznH0AYl7lAB8i0WLWiRKPWZDKjdvtPnZEtU1OMaqIMxgzbfO+1SypN/0G2JbBD858oaW7G0Uec9bs6LU+mYKRs4zS1IhlHUXxIf2/vWHtlqx7vfIyKpzX4z9Xd+HJf1JExdA7ZhRpw2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369552; c=relaxed/simple;
	bh=5UVdqTPr+TNpu++CYmLE8vu320R1qoTuzw349w/mj1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=me1hbIH61X9StPk6AqgGLVgt2oLtE4BoPdEC0jo+9T9eMbhDJaBEIgjri3CskPJcSjC+nKulQmu0aB6KRqnWRbGavjQGC60IAwtPNRsVehJe7DlQjZ7skq5CqcxCp8QXkeyory12tPhJ224NceOy8RN5KZid0uzElu2Ahlyvus0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0+3Cs3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0+3Cs3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86110C4CEFE;
	Mon, 13 Oct 2025 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369551;
	bh=5UVdqTPr+TNpu++CYmLE8vu320R1qoTuzw349w/mj1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0+3Cs3WvRRY8gc2mCX3g6fMFEAHF1sXSS6mnKecgi1FbsAH2mjlQyt4j8hBOikuv
	 8VyQEcuxKg5QvCgaix7tKlaKXatl87+kPeScZN+ZRGKtAQ2RtlWfptKfSctAgVHIkG
	 JCHspAGTRy/zTsUqJK14/klJX5zjBnwCDe+YeDfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 269/563] net: phy: introduce phy_id_compare_vendor() PHY ID helper
Date: Mon, 13 Oct 2025 16:42:10 +0200
Message-ID: <20251013144421.020763433@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 1abe21ef1adf0c5b6dbb5878c2fa4573df8d29fc ]

Introduce phy_id_compare_vendor() PHY ID helper to compare a PHY ID with
the PHY ID Vendor using the generic PHY ID Vendor mask.

While at it also rework the PHY_ID_MATCH macro and move the mask to
dedicated define so that PHY driver can make use of the mask if needed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250823134431.4854-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b4d5cd20507b ("net: phy: as21xxx: better handle PHY HW reset on soft-reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index bb45787d86848..04553419adc3f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1273,9 +1273,13 @@ struct phy_driver {
 #define to_phy_driver(d) container_of_const(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
 
-#define PHY_ID_MATCH_EXACT(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 0)
-#define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
-#define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)
+#define PHY_ID_MATCH_EXTACT_MASK GENMASK(31, 0)
+#define PHY_ID_MATCH_MODEL_MASK GENMASK(31, 4)
+#define PHY_ID_MATCH_VENDOR_MASK GENMASK(31, 10)
+
+#define PHY_ID_MATCH_EXACT(id) .phy_id = (id), .phy_id_mask = PHY_ID_MATCH_EXTACT_MASK
+#define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = PHY_ID_MATCH_MODEL_MASK
+#define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = PHY_ID_MATCH_VENDOR_MASK
 
 /**
  * phy_id_compare - compare @id1 with @id2 taking account of @mask
@@ -1291,6 +1295,19 @@ static inline bool phy_id_compare(u32 id1, u32 id2, u32 mask)
 	return !((id1 ^ id2) & mask);
 }
 
+/**
+ * phy_id_compare_vendor - compare @id with @vendor mask
+ * @id: PHY ID
+ * @vendor_mask: PHY Vendor mask
+ *
+ * Return: true if the bits from @id match @vendor using the
+ *	   generic PHY Vendor mask.
+ */
+static inline bool phy_id_compare_vendor(u32 id, u32 vendor_mask)
+{
+	return phy_id_compare(id, vendor_mask, PHY_ID_MATCH_VENDOR_MASK);
+}
+
 /**
  * phydev_id_compare - compare @id with the PHY's Clause 22 ID
  * @phydev: the PHY device
-- 
2.51.0



