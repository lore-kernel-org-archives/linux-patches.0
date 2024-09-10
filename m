Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38A31946A1;
	Tue, 10 Sep 2024 10:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962887; cv=none; b=NodC/5QXEgmF8etmTDIFxPi3IhGhjGMHRbtso0G3TBGxvElOLbh6ROoiUewj2gCtBQq70MiV8YkhmVy+VDZPO5DGD3IpPttJ8dTFpJw2BhmxmWlZpTfhTjiUYu1TF2q4lKpllN1DTFqZIvLMvs7Z1tplc+aOz0otFyEzQ+DDClI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962887; c=relaxed/simple;
	bh=IHu9mXJpPWDHROVhzRwB+eFyFIRGmSgjwAxvYI/68Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3Aexh6Y9Q8xSLhVOzjHne3YX/I0H1/CO5ccvFW9oiWjoSFZl8UNOwHkCG/UgzwZYpisbqf0m3f6oEkib9SSxkJTauyFp9v8H6g0N4Y6uV+h8yoDltnwu5pnHn0GqXPrCSETXu3Goee98Z2A0yN98TMnC6xDzKMhutOOC2QKjgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6/imGSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6/imGSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787A6C4CEC3;
	Tue, 10 Sep 2024 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962886;
	bh=IHu9mXJpPWDHROVhzRwB+eFyFIRGmSgjwAxvYI/68Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6/imGSOJOkQWWtj3d3EdujadD5IU4V4/KkJbe2IW/GcXHynI1XaZv0dSBRo9srog
	 bX4uWg4ZYWGl2gZ30W83MENx8pG0Qxnw/Y+QDWUHP/Zx2F1WOfiIWHxHFAf2Dt/tFv
	 0MiuUQ4Es2UghEPYuu8C10NkTNy8lyH9ZqucFjd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/192] media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse
Date: Tue, 10 Sep 2024 11:31:28 +0200
Message-ID: <20240910092600.629042607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 4caf6d93d9f2c11d6441c64e1c549c445fa322ed ]

Add check for the return value of v4l2_fwnode_endpoint_parse() and
return the error if it fails in order to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index a30461de3e84..d173ac80e01c 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1038,8 +1038,11 @@ static int camss_of_parse_endpoint_node(struct device *dev,
 	struct v4l2_mbus_config_mipi_csi2 *mipi_csi2;
 	struct v4l2_fwnode_endpoint vep = { { 0 } };
 	unsigned int i;
+	int ret;
 
-	v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &vep);
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &vep);
+	if (ret)
+		return ret;
 
 	csd->interface.csiphy_id = vep.base.port;
 
-- 
2.43.0



