Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A021660B;
	Thu, 12 Dec 2024 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024565; cv=none; b=LaqloDKUZTmMIY6FR1CN7Zhbr6x3RRF3xDycDHvFzhJtmr4lVS7zzVRwznqA64uDiS1OCJqI5O1rm15boFmuXInOjLpXwtX17wMsZWoV2UPBd6NE76nxuUnzLNLnZY9r/tKiSFXXCOPNrkXo+sDdmWKdmpw9jkcLkyWFSBkEarM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024565; c=relaxed/simple;
	bh=cgOggIt8dmFMtb0BYarIgRkuR//zBvvoQK9hXgC2ujM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBQbNtsyq+KirV39kU2eCW6K9VEC0yadPu01qdrMPwgipcNQ/TKxNtLEF/83JAStr8TWXQD6K/Ua57ry4vH1r/MuVEl5/iiJNkiLlDCnc6LIEf6swpwnje4M3axMWgr5jgYD951GSbk48raZoBIP9FIMp4CUtsu6Y3YxFva3vus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irhom9gS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irhom9gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1092C4CED0;
	Thu, 12 Dec 2024 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024565;
	bh=cgOggIt8dmFMtb0BYarIgRkuR//zBvvoQK9hXgC2ujM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irhom9gS/VmQ/oA4uPtcIQftrskqnHiUzJL07jfhDdMIfUGA2bB9SslH1n7CDDDDP
	 XSdPnJXM48H2TTakSRbYjEWTAZNQCd9AB8j113noOACzAPOXS3yfhSspvsPxAgD2jB
	 c8gbI5JNGKwMX1ZZDp33Bhpomb6BG+qGt+JA902Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Forestier <florian@forestier.re>,
	Louis Leseur <louis.leseur@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/459] net/qed: allow old cards not supporting "num_images" to work
Date: Thu, 12 Dec 2024 16:01:16 +0100
Message-ID: <20241212144307.012994117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 2cd14ee95c1ff..a0c09a9172dc0 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3262,7 +3262,9 @@ int qed_mcp_bist_nvm_get_num_images(struct qed_hwfn *p_hwfn,
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



