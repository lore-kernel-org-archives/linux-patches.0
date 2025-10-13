Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF615309DB0;
	Mon, 13 Oct 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367020; cv=none; b=oQ6W5tUWZb1i6uwhvu5Dcoibv5T46pZHDy7om3yxVwy7c5pLAEf0frDF0Z5fq4nYZjTl4R7wis+PI+JPzeV0u6+vwkoNJKsuCN+RJzMNpRS8Fr2jjJ7loUVNP6bTBdnLTAwSDpjr+iefinjSt2xo5UuqW7h6f4el5FxZMF35o/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367020; c=relaxed/simple;
	bh=LZ/jNo4V87JC9cJgtCTfcOdBLrwF/Ec81vp5x+ArzsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaBN+BKfhbivnM4YudvN9QBBtVxV6IJxWfGNG4gKl9OoJRGt5moIKmcyfOF0PfWTm9Q6JzLP2TIvoaMUagFBUgBaVwKjCPAS7/dOHh5A4XfzC7/OZU9tjEzkAadDXpxwbvAVF8KFxD/5G3dEfYfkw2kkdpc1CgVSDCrO5DGUE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BX7wRGzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BX7wRGzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB18C4CEE7;
	Mon, 13 Oct 2025 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367020;
	bh=LZ/jNo4V87JC9cJgtCTfcOdBLrwF/Ec81vp5x+ArzsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BX7wRGzQUr1tHOTZ3gDj9kJYqonPjTbYJAHKAHbGVAJVczmcPoCFsRGOq4eRfR6QB
	 ZJl+7DGztP7gFHMe+BqG0uW2RfdFQY11uFdrQ66GqwUAxAEkvL1Ke2qS9l4LTExDuR
	 Hwnxv3BSPm0XgWP1G8F5BeJzRbewnxcitYtSmVSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/196] regulator: scmi: Use int type to store negative error codes
Date: Mon, 13 Oct 2025 16:43:58 +0200
Message-ID: <20251013144316.932919162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9d35d068fb138160709e04e3ee97fe29a6f8615b ]

Change the 'ret' variable from u32 to int to store negative error codes or
zero returned by of_property_read_u32().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Link: https://patch.msgid.link/20250829101411.625214-1-rongqianfeng@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/scmi-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/scmi-regulator.c b/drivers/regulator/scmi-regulator.c
index b9918f4fd2418..7252fa32cf054 100644
--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -257,7 +257,8 @@ static int process_scmi_regulator_of_node(struct scmi_device *sdev,
 					  struct device_node *np,
 					  struct scmi_regulator_info *rinfo)
 {
-	u32 dom, ret;
+	u32 dom;
+	int ret;
 
 	ret = of_property_read_u32(np, "reg", &dom);
 	if (ret)
-- 
2.51.0



