Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6F62080FC;
	Thu, 12 Dec 2024 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015753; cv=none; b=pThfHEt1K1Xkso77eGMP5Xzn+Su4jkRAZ5kGC+CIqckHjGg/9rWddj8HvQmoLESbTSfpgyafO5+7X+oBOyI70RTuORdPrM4XD4KqaE9iKDRkfiI0QP+RhBXfyyh7I3wpaPy+JijygTVCtWJRLBH8ffHfckFGrB9WLQBUBg11TnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015753; c=relaxed/simple;
	bh=YnAavv+OBNbfJWZQZCMEKrc2mVnZ83bxBXoUI503dHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDhIz1tLSg9kwE0W8ThFcyisXXMlkPyVKMpHY6PGkQurZa9gDQElp3sAjwUYf/uJJq9UefXsqjMBDQhnzl/Er8jkWJwUCJYZ+ac4ssIRjUHD/pT/SIAepkZ3ZilV39SKZoI4wa+O9iW8IsSPHN7y0lU5p4kjgORcQ6JdnuMROB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPk1V+66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPk1V+66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40B9C4CED4;
	Thu, 12 Dec 2024 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015753;
	bh=YnAavv+OBNbfJWZQZCMEKrc2mVnZ83bxBXoUI503dHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPk1V+66rVB4MR4MUOg0N/YCHhv/XgpMhy1fcsmRtUh031DRdvgcqmE7F5FdiXFF/
	 mvhR3Kk1DD0gOGJQzkB+Jen1QK6FLX5u9/T1G/F39Mh7bLGYF5aICEgm27z5wgQ/uX
	 xymZ2NNLUBEmBxOTFAq92v/boAE/ANQRhMgUxKIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Forestier <florian@forestier.re>,
	Louis Leseur <louis.leseur@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/466] net/qed: allow old cards not supporting "num_images" to work
Date: Thu, 12 Dec 2024 15:53:24 +0100
Message-ID: <20241212144308.072739670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Leseur <louis.leseur@gmail.com>

[ Upstream commit 7a0ea70da56ee8c2716d0b79e9959d3c47efab62 ]

Commit 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
added support for populating flash image attributes, notably
"num_images". However, some cards were not able to return this
information. In such cases, the driver would return EINVAL, causing the
driver to exit.

Add check to return EOPNOTSUPP instead of EINVAL when the card is not
able to return these information. The caller function already handles
EOPNOTSUPP without error.

Fixes: 43645ce03e00 ("qed: Populate nvm image attribute shadow.")
Co-developed-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Florian Forestier <florian@forestier.re>
Signed-off-by: Louis Leseur <louis.leseur@gmail.com>
Link: https://patch.msgid.link/20241128083633.26431-1-louis.leseur@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 16e6bd4661433..6218d9c268554 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3314,7 +3314,9 @@ int qed_mcp_bist_nvm_get_num_images(struct qed_hwfn *p_hwfn,
 	if (rc)
 		return rc;
 
-	if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
+	if (((rsp & FW_MSG_CODE_MASK) == FW_MSG_CODE_UNSUPPORTED))
+		rc = -EOPNOTSUPP;
+	else if (((rsp & FW_MSG_CODE_MASK) != FW_MSG_CODE_OK))
 		rc = -EINVAL;
 
 	return rc;
-- 
2.43.0



