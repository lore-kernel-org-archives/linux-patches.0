Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F13A346E46;
	Tue, 31 Mar 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975681; cv=none; b=RW0QmGZ+LHgcoiD/jH9JHvmKh85tg4+zDRV1gganGCNrfLWxkiQ1nc67VC8NHLOoiHYfh8yQ62RE3M17XMa6HeUHXGa3uBYPoh1IKwmJi3buAZ2ZCQyYC/sgtQC3Dt0f+H15Zj/+ienMmKCUd4v0bXfz24zkKR/0f20B5epAznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975681; c=relaxed/simple;
	bh=JuxUsmA0ZpqiCczqIxuZlB47RGkVzcITzQejxuvvTL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOPZJ6cPo6o8Cgzr/igsOFhLNLoOzocOQ+tY8EVV/j0u3gApvIeyd4RqEP+wOX88kNlrPWQ+PXZa5xzLHsMhUtOHZNui98uupOGOnP+XxJzTleFd888SrOUEL2q7veeA1u86fj3OWCl8wbgCMKP80Q6VcLOuOQOHw2pWytyrqYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjSC7jg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjSC7jg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A1C19423;
	Tue, 31 Mar 2026 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975681;
	bh=JuxUsmA0ZpqiCczqIxuZlB47RGkVzcITzQejxuvvTL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjSC7jg0jLuH11znE3UzUg/Xsd46IHM3INlUuOsTuzq0dUIf6LFwHgtJDHe4vWKmy
	 jbAYHfVPr5Bwv7dQBhvJ9RF53j/fXxh+WA/3ofb76u7jt+NvE1u3DWv28mmHCT9pEs
	 kJCHVddTAEXfKdnuRpcRqc+m9Mavz4JBMJ6R7+nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Yin <peteryin.openbmc@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/244] i3c: master: dw-i3c: Fix missing of_node for virtual I2C adapter
Date: Tue, 31 Mar 2026 18:19:56 +0200
Message-ID: <20260331161743.397836405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Yin <peteryin.openbmc@gmail.com>

[ Upstream commit f26ecaa0f0abfe5db173416214098a00d3b7db79 ]

The DesignWare I3C master driver creates a virtual I2C adapter to
provide backward compatibility with I2C devices. However, the current
implementation does not associate this virtual adapter with any
Device Tree node.

Propagate the of_node from the I3C master platform device to the
virtual I2C adapter's device structure. This ensures that standard
I2C aliases are correctly resolved and bus numbering remains consistent.

Signed-off-by: Peter Yin <peteryin.openbmc@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260302075645.1492766-1-peteryin.openbmc@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index e0853a6bde0a4..3453431e49a24 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1606,6 +1606,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	master->free_pos = GENMASK(master->maxdevs - 1, 0);
 
 	INIT_WORK(&master->hj_work, dw_i3c_hj_work);
+
+	device_set_of_node_from_dev(&master->base.i2c.dev, &pdev->dev);
 	ret = i3c_master_register(&master->base, &pdev->dev,
 				  &dw_mipi_i3c_ops, false);
 	if (ret)
-- 
2.51.0



