Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39542230BDF;
	Tue, 26 Aug 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214488; cv=none; b=PchyCWCx8DPH85opAcMPLhmjED1UL4cjbORlZ19WYqMZ/ts13YLYhcd7Sgnzt/d1/0RN+8Z20jTnwm/X7U75PUk44vCrA0BaSs3APPqgFmtilvfk8zY1FxfP4polEtYN2Zga1CgxcHzH6iVhYoOod4fUwoqfDORyg3o2RkJgrSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214488; c=relaxed/simple;
	bh=+ynJnMWlzU7zNDpl1ql88Ks5USQAkwqrhM1OgUNO9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNYkGbXrOJzwFaMV4l+3rCjrPvmcuLuO4P9TyBodbrlXl7aUkBSM/M5umvrk3mKyKsV9u/3ZnJs5Y09nN0taBwgzUI4BIM7VnSrEigFoEn1Mo8g8acvNf4ooqx2vCg0FgKDCGLjACn8r9GHEelvRL6LFBC8MV4QW3oLg3FbZSSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBm1en+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBm1en+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D41C4CEF1;
	Tue, 26 Aug 2025 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214487;
	bh=+ynJnMWlzU7zNDpl1ql88Ks5USQAkwqrhM1OgUNO9Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBm1en+D2vYyN5Wks711tZBBFJcnx/zqrPOBqxGARtOfKql2gELyYwV3rHAob5ChE
	 ZNOjchgSTKzVXM6tjq4+UMNWxntDojhJbQL2wpqG+grmL5rjrnwCDuBN7yltv55nxd
	 KYgMYPEqXYX4AOXzWOvvhiU29riJvqYYxB2mmClA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/482] gve: Return error for unknown admin queue command
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110934.692519342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b11344f63fdd9e8c5121148a6965b41079071dd2 ]

In gve_adminq_issue_cmd(), return -EINVAL instead of 0 when an unknown
admin queue command opcode is encountered.

This prevents the function from silently succeeding on invalid input
and prevents undefined behavior by ensuring the function fails gracefully
when an unrecognized opcode is provided.

These changes improve error handling.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250616054504.1644770-2-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f7621ab672b9..32a9943432ac 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -409,6 +409,7 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.39.5



