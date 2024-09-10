Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DE946444;
	Tue, 10 Sep 2024 09:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961720; cv=none; b=Pk+KitBy5eVR07vZOXN4nqiCP/GmpejJCCq906E4TiPa13jCt45B1xyuAIG8cjit56UuSXWPuD6uqBGg30lSWgTwJ8uhzXrA7i8StlP5wbdeTDoVjEW6aP0DIkUiv/lVeyvTuy5zEnYSbgFczsPZca3tRN3rPZtFzoEcM7TOwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961720; c=relaxed/simple;
	bh=HZEB/3Avkqm70Qz29uoX/JcuJlEwGJI2jpw7HdVvtBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjnFwRMt7paDGrCAaUlYjk6Aq6McBGaIEhT+LKUPASlZGAtZ+jg54OKkW5zkkfJM6uMrS6N4Q7ynWB545EXJUhmsb6a+EgW65VSAGnLpp1EMbqz2af1pF41M0riO8g27bX7HkUVxeyfEhz6nPtK3UI9bNv30pvc2OXkqCWP8/nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sM0pf90u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sM0pf90u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEC4C4CEC3;
	Tue, 10 Sep 2024 09:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961720;
	bh=HZEB/3Avkqm70Qz29uoX/JcuJlEwGJI2jpw7HdVvtBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sM0pf90u9q706N0rhrvTXYKln+9qGhUPkwSS0LHpUsKinEyALMm/wT1xbX3fStWdW
	 IEKzNh1g1jSAwV9sACdRwakCosjCZk3V4gCZL5d2DohE1NpgKm657a+aQjmskmD37m
	 5iNd4oQuDQ9dxzYb3bgdFbuZvG7ZiGk05/JoDKdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 139/375] media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse
Date: Tue, 10 Sep 2024 11:28:56 +0200
Message-ID: <20240910092627.116306338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1923615f0eea..c90a28fa8891 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1406,8 +1406,11 @@ static int camss_of_parse_endpoint_node(struct device *dev,
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



