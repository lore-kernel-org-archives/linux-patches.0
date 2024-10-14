Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0744E1537AA;
	Mon, 14 Oct 2024 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919832; cv=none; b=urIEoZf2zq9J0MuOpDfBJaBF/bjj8x4JevgjDpwb53WJVyNilaxCux6PL2bSSp2qtl1mFUi2wi4Te6ADkRMlpB25hIPpVUfMClpetQNdGFRL4syfsY2qzwC3Fetor22CrdVmpE37IfDH2Th02vdOR8xLzVuNj9lq44VcDG0UiPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919832; c=relaxed/simple;
	bh=XM64NmLjjqqtYIwojBr4zYIiFGEnMvKTED3HHySYEVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaxqxkU0J3s6oTH5se3alMGoW1celqhK/Z45f7v8eJLM7z1Z/2VrQnxnhFQrhxwuh5tnKViiLX3c+M0vlEFTd8eRauSUnpb86ejQWoTlZJkZ1Ip9yp/PwczOIXLdWhCbiOsI6gP3kulxgH+Lwrlr+WtZV1t1NYcmEk26g3fA0do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLJT4NhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLJT4NhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6F4C4CEC3;
	Mon, 14 Oct 2024 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919831;
	bh=XM64NmLjjqqtYIwojBr4zYIiFGEnMvKTED3HHySYEVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLJT4NhG/k3gFQ7JHyspn5fW4sd2iDSvK+vAPVGrXeL47N+vmBouuI8qN8Qi6uQ2N
	 UzPIi6Ele4nMwtBSpnVOdvGDXioR+NJvnaNmV6MLt+5PSgOwUh6Lr+7MgsKnrnHXCf
	 hkJtB+RyoFZMOfeGEA/GZ1kElgJxd06ENAXcZ98w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 719/798] driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
Date: Mon, 14 Oct 2024 16:21:13 +0200
Message-ID: <20241014141246.317022694@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c0fd973c108cdc22a384854bc4b3e288a9717bb2 ]

Return -EIO instead of 0 for below erroneous bus attribute operations:
 - read a bus attribute without show().
 - write a bus attribute without store().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20240724-bus_fix-v2-1-5adbafc698fb@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7ca47e5b3c1f4..339a9edcde5f5 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -104,7 +104,8 @@ static ssize_t bus_attr_show(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for reading a bus attribute without show() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->show)
 		ret = bus_attr->show(subsys_priv->bus, buf);
@@ -116,7 +117,8 @@ static ssize_t bus_attr_store(struct kobject *kobj, struct attribute *attr,
 {
 	struct bus_attribute *bus_attr = to_bus_attr(attr);
 	struct subsys_private *subsys_priv = to_subsys_private(kobj);
-	ssize_t ret = 0;
+	/* return -EIO for writing a bus attribute without store() */
+	ssize_t ret = -EIO;
 
 	if (bus_attr->store)
 		ret = bus_attr->store(subsys_priv->bus, buf, count);
-- 
2.43.0



