Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE713597E;
	Mon, 23 Jun 2025 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716461; cv=none; b=eeRVf1cEoJ0Y0rj2BfjZDg9c2OkxKEwA1ZAzDNIJyeeIJoZyqsXtWMxB76B60yiB0YWRSARQa5oQ64iDdpXkgBS0hIb/NzhV80rNCmp5944FlK3PSsgP0Et100kG1iB9ec7GWLwyplG6hDRONL0Okc6FVNq+hCtG7iBjIslNhSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716461; c=relaxed/simple;
	bh=XCVA6T1QomhMtjP1XuceDEiSqtiF0LCHIePXyDv92w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiiUrC9gw3A9KkykkH02kTrSlA7W/HE4ThejYCzbHrS5X88xW+BsqYYt6+dFyM9IF/4IV7zRNCk8nb/HPsw0v1tQSbSZ9f6d0RyYz8fX1rdDunkBxZ4eTz92tbKsuVIfAgRWh+FN7ZHKHwA4IeG1tya6HuJQpsKdHcHa9Cbfprs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI2dScGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI2dScGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9376C4CEEA;
	Mon, 23 Jun 2025 22:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716461;
	bh=XCVA6T1QomhMtjP1XuceDEiSqtiF0LCHIePXyDv92w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI2dScGebyP2Et20PWhJDpHR78nZPAlkZEz+/A0kehNySKV1KPDNV6mS7xfecTFAy
	 /d7TX5IL5G4gIblnpgQD74mQ7hQuaL/i+gaJntzixCfVNJzkb7j0ItzHuN7v3P0NKW
	 JK+lvBdoW/fCkZSIiDcBeS22cj0ONwLk46FoodGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/411] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:07:54 +0200
Message-ID: <20250623130641.955587097@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 31e4e12e0e9609850cefd4b2e1adf782f56337d6 ]

software_node_get_reference_args() wants to get @index-th element, so
the property value requires at least '(index + 1) * sizeof(*ref)' bytes
but that can not be guaranteed by current OOB check, and may cause OOB
for malformed property.

Fix by using as OOB check '((index + 1) * sizeof(*ref) > prop->length)'.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250414-fix_swnode-v2-1-9c9e6ae11eab@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 15f149fc19401..0af6071f86641 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -524,7 +524,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



