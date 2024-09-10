Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AA818C914;
	Tue, 10 Sep 2024 10:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964253; cv=none; b=DpWSZQ+Gsd84euPGvbk/RMUt9SdazM32M8iN3kONmAHxBMF6wnQze+uKPlohTgUw4Zoczz2L9cnD4fEdlSzyGk4SdAC9fbzkkL/Xt/MNDRq/CgYVw5gifk/u22AkgCosDVXs/2a2NG0KdK/6dtMiuBN7vR4PB4vBTkgNwTKBXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964253; c=relaxed/simple;
	bh=OxwVpxtA8FIpcDZ+KSHlLIxAOtHC//fc+UqnmNHM5pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hR5FAoelxdC37hV0nuao/O37/Bp37k/V/IPj07UhG9oNhb44t7FQCi3DeUIhvTOp2QJOz5RsQ0+5pnzIVkNpYen5dnXlCGJN9WZZGlyRihFmae3ZcBZk6l2RXMPnIIn8uD4payc78wIMxta4+GM1I80ox9U67g+VqsiFQkA5Wvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a16eWuoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a16eWuoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74396C4CEC3;
	Tue, 10 Sep 2024 10:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964252;
	bh=OxwVpxtA8FIpcDZ+KSHlLIxAOtHC//fc+UqnmNHM5pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a16eWuoXwkUWJdirj7ud/okuJpAN7ApQu9IdLsseCk3C7XJBmGaoEYSCNq9iU7V8f
	 iE2l1YqIahuqTOwbV+Xa7wnTu4T9nH1xjE0EeMcVQycFEfUp+WdCktFsBBIZ1Lcsga
	 2rmii0XyyINa6cjPTcFYeJ/DGbg2+y5XavahcAaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/269] media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse
Date: Tue, 10 Sep 2024 11:31:19 +0200
Message-ID: <20240910092611.492018748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index c6df862c79e3..8fa6750b5b42 100644
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



