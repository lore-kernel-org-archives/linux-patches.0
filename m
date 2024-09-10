Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9101518595E;
	Tue, 10 Sep 2024 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965022; cv=none; b=KbaJSrxf3GvwLOu+gYkGmsUYU1puo5zAjE0GNmJuqHW+dz2gRN8opXwOSf5VBiHpVyUJU4ImOHMYk/QYA4npwiHRw+d6KumRNaK6qbbrovXFoYphF82u8uX0vIe34WSGAbBOwggBpqJUlXfpflxrOiQjSb0DBSw/HzZrEYzP+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965022; c=relaxed/simple;
	bh=jhlFT+NUkr1aBnvtAJ+oalwiEXRUN8NDvOEYfxEjU08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD6ENe9oMwNPi10wDwl3Ps5HU32OrH5QuJD3w2IOhJGWpz/rFNNZeHTL8hPmwnnR/w9cvNM/zBtR3o07XrZJbj9uBPonmuUidlnZnVFnWXIUH/PxI3hol99k8CtYgArNO8Hzu+kNgWkU1z/1uYtxrAc7IDJNUzBRXd6r6MaO3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ubGb5a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ubGb5a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F6C4CEC3;
	Tue, 10 Sep 2024 10:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965022;
	bh=jhlFT+NUkr1aBnvtAJ+oalwiEXRUN8NDvOEYfxEjU08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ubGb5a3tmBVIonEu9C0Ou/okVPFsllZTvUBGIuE1Be+u3hJUwtsuBPeZPYa6c8Ub
	 QyTxeA4+TafHACRZGAJi9KGcstozAMx7/qWx5J0sGPLFaYlyOq8OqRd1vGm2azAIlG
	 Pe0BxIsBF4i82E83uGzPQSdiC8Gi0hNAqwKrdo9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/186] media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse
Date: Tue, 10 Sep 2024 11:33:25 +0200
Message-ID: <20240910092559.055922409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9186881afc98..d074f426980d 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -431,8 +431,11 @@ static int camss_of_parse_endpoint_node(struct device *dev,
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



