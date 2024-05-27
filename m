Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A6515A84C;
	Mon, 27 May 2024 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837319; cv=none; b=KufkjEgLdfyUQNdQJljIQGgzrMLCKcCRLvev5IDBlB+Kg5TCcpvDesKazkxolSG+dm9q1oMd/JqiicL7izrWkfI1GkzX6XxKRrtz5km7C5wm9nblyKF9fIk2LvLf5dOqkvnShRswUeiwiLDEJZiZoly58EjF15WnIj1BGRx7Ae0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837319; c=relaxed/simple;
	bh=XYdQPw18Cu1P6qcK2c5Bge3z+O96EqiqFuwrajHyYww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3iWzMSoM/8jynfVO/UebCTUb4OIctxxHICciHgK3pNS/Y3fQvzvVr7clLx21hJuDo77v3cUv79bXbbA7rZ33f7E5iBkcPPtRe+YM6rHPnj83imtx/nzyzKpkxSKeG5taUOusv8zbfvtJiXDx1/UDmr6Wnhwl7hTmQ8Xe1aHhgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNvRdpbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNvRdpbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384C9C2BBFC;
	Mon, 27 May 2024 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837319;
	bh=XYdQPw18Cu1P6qcK2c5Bge3z+O96EqiqFuwrajHyYww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNvRdpbrm5aCpXMfRSALQ5n5IE8Uz+OCXvAO/WEPatgqOfCWMQ8fCaM6IaBAs6zwJ
	 kSKOIK9y2Gx8e66oi/h453KnKAntwTTKlrL+sg28SG95VMkiAXFZSMve7hKXT/jNdE
	 zRhwSVDkd21ZdacDiZzhk7efDv5cfFcR4rmVvziI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 394/427] dax/bus.c: dont use down_write_killable for non-user processes
Date: Mon, 27 May 2024 20:57:21 +0200
Message-ID: <20240527185634.916992331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit e39dbcfba714c4c2e924e96fc8fdde1080a5a737 ]

Change an instance of down_write_killable() to a simple down_write() where
there is no user process that might want to interrupt the operation.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-3-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e2c7354ce3281..0011a6e6a8f2a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1540,12 +1540,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dev_dax *dev_dax;
-	int rc;
-
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return ERR_PTR(rc);
 
+	down_write(&dax_region_rwsem);
 	dev_dax = __devm_create_dev_dax(data);
 	up_write(&dax_region_rwsem);
 
-- 
2.43.0



