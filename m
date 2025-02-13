Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D54C1CAA7B;
	Thu, 13 Feb 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460342; cv=none; b=A/ARBwI8DXGRQ/ftSTCsYu+ZAU/Zzw5IfWi/svcCTZPmeIHgIucIspbAyy3qvPqfE4vN8A0xjmkl/mVJKb1UqDWYm43pUtjlkxrfc8PG982n0WKdKn2djhIQ7NuwpDCXLudH79KB6j1KlYiwi4GH8jfzIHBpv81PuDJQvuaWzKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460342; c=relaxed/simple;
	bh=3aU55NzPKnS4mE+Jfk2jd/EhaslA8Gdor+XR67vZzL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbMW0zRnDfnvxX/kEeDo1M/Jsv8ZA+tq3OtShvMpQTztntfksW0YPM0gjOA1DV/aZU4HQO6YvdTE4m/RvykrRsps7kPkR3RVjTJTMqa9eZPmeISax0JbB2BILPc6MKdC0CMDGNxrymbS1eaCulkNKVzJETyCsUA0Zc+Pp7q+sMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik5tisX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik5tisX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F26C4CED1;
	Thu, 13 Feb 2025 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460342;
	bh=3aU55NzPKnS4mE+Jfk2jd/EhaslA8Gdor+XR67vZzL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik5tisX9qDpCH2T2TT6pVrCiI/KW7ruSRG2VeE9pTbCbrNnEsFSpIBkUrb8MKFssg
	 XVIwJ4ZwlEv8xQFIfx2w8fhMRBc8sQhu4SMLPBYKDNeptKJUTWSkjc9ZDwU6xNU8g0
	 aG2uftd3zoEnmAm14j0cl+UGfAyXMNpzXTWw0QoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/273] ice: Add check for devm_kzalloc()
Date: Thu, 13 Feb 2025 15:27:18 +0100
Message-ID: <20250213142409.964268476@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit a8aa6a6ddce9b5585f2b74f27f3feea1427fb4e7 ]

Add check for the return value of devm_kzalloc() to guarantee the success
of allocation.

Fixes: 42c2eb6b1f43 ("ice: Implement devlink-rate API")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250131013832.24805-1-jiashengjiangcool@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 80dc5445b50d4..030ca0ef71d87 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -999,6 +999,9 @@ static int ice_devlink_rate_node_new(struct devlink_rate *rate_node, void **priv
 
 	/* preallocate memory for ice_sched_node */
 	node = devm_kzalloc(ice_hw_to_dev(pi->hw), sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
 	*priv = node;
 
 	return 0;
-- 
2.39.5



