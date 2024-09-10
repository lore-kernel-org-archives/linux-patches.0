Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AE18B49E;
	Tue, 10 Sep 2024 10:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963694; cv=none; b=izlQ3m4r99S9ZKViRPVXXHPG2sAOWfT1Zxjl5bXo4Wz/FPFkM9XG/ca8dmuGEsnXfUownLUzntt9NVdgj/V4CMouc2P0zUpdoFEpUrJcly+NuWDk0BrJ0ja8ktdBlnFCAt5PpXhw+rlhvgfUo09wUtrAvYtgG3Kl2dBnJRmCe0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963694; c=relaxed/simple;
	bh=S7prug3MfmKGY6hTzZ0OMPMZGMZcLvLixtoSsb3Aj0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAM+jn5+BASq5Mtd9ShvSLmpMDNWbZgdq/FNHzOmGFznG2Fl+YxC8hsXJmcBY3yGyrPCm8ZIfgdwtZ/d5Zp/5PFpeM2JjESCbzF3SuRTvQL44JpYtniP3NMqOyt8oGDv0L9xuCySs4xJ6kb2CRlBnGLfuVMFcDXCPmQ5FTm9KSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ5/1xK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ5/1xK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA60C4CEC3;
	Tue, 10 Sep 2024 10:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963694;
	bh=S7prug3MfmKGY6hTzZ0OMPMZGMZcLvLixtoSsb3Aj0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ5/1xK5XtO0EgslnOaMLXmewbEeq780boHtNyzj1d84P6qc7Gm9/4/MVkz3o0ppt
	 4khiTc1kFO3ugPmxyjrEiZoSVYJ+hQI0OGqQE0+l06VHaKJM3ZZVp4tM1CjadqywAe
	 yCbmL11xytdUqwbOnhQdmk7zQZLBJox3BcfgGKqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/214] media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse
Date: Tue, 10 Sep 2024 11:32:19 +0200
Message-ID: <20240910092603.571022147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e53f575b32f5..da5a8e18bb1e 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -835,8 +835,11 @@ static int camss_of_parse_endpoint_node(struct device *dev,
 	struct v4l2_fwnode_bus_mipi_csi2 *mipi_csi2;
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



