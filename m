Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D30214210;
	Tue, 11 Nov 2025 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822713; cv=none; b=VThKzZu/SArvoUJtkiAmAPW1ZRhaiwac0IkfaOj1Frvbv5djFbkShEZXLQwmZhNvID7WT56EC2cHHVG7X08RlpY/qPZNoh4MriWlaiIHY25LTvsbSCUgC21FS0UgWVkKU6mhwd5CeddIl0BAO7GkiatcNWMrWmUXLK3gg6zybSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822713; c=relaxed/simple;
	bh=Dl00yJqRW3/J9XBgvL4hVBMd7DxwWky5iR+lcrg3/qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtxN8EThaMVAtDuEwtxbFxe6GoVxp+qVtBRdAdTa54colf31ziMMlAjivFqNci//m2tlveB2Wn6dNHEEzuWpq/XZQvlTTsi2qZ3OgVQ2K1Pov2tY9YLhJhtu2hbsSTZgn/QtIw7jJgpciDP449HNIxvvu9Gc2dAgFl/gdy8u1qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk4JO8Q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk4JO8Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5BCC116B1;
	Tue, 11 Nov 2025 00:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822713;
	bh=Dl00yJqRW3/J9XBgvL4hVBMd7DxwWky5iR+lcrg3/qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk4JO8Q4fy0AGIBKdZSXpHM0FdiRcu+qnjH0d93Hrqaws0+WMutAp54DTRQBjpMEE
	 H5mfnc60FSKXMOZis1UO7v0ZTCTmga7Z6q79uf8cn2b0raIH/Npl+5rLaZcdM0QOYF
	 1sQNygAMUJ/lHe3GKSog5I8XbMebGyHhGoR+Pcjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Ruehl <chris.ruehl@gtsys.com.hk>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 153/849] power: supply: qcom_battmgr: add OOI chemistry
Date: Tue, 11 Nov 2025 09:35:23 +0900
Message-ID: <20251111004540.122582475@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Christopher Ruehl <chris.ruehl@gtsys.com.hk>

[ Upstream commit fee0904441325d83e7578ca457ec65a9d3f21264 ]

The ASUS S15 xElite model report the Li-ion battery with an OOI, hence this
update the detection and return the appropriate type.

Signed-off-by: Christopher Ruehl <chris.ruehl@gtsys.com.hk>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 99808ea9851f6..fdb2d1b883fc5 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -982,7 +982,8 @@ static void qcom_battmgr_sc8280xp_strcpy(char *dest, const char *src)
 
 static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry)
 {
-	if (!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN))
+	if ((!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN)) ||
+	    (!strncmp(chemistry, "OOI", BATTMGR_CHEMISTRY_LEN)))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
 	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LIPO;
-- 
2.51.0



