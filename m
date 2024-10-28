Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069C318FC75;
	Mon, 28 Oct 2024 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097994; cv=none; b=MZedK+EK0WFumL7lipLWPEFks+USxp2D5yCpsyzaOQ6fCrcPRQ+iIQoHb+Tlzyqkkl0ttcj0kIh+ekWwVoJsPR4RFnHkVQ2jWijvEXmSGd9stie1thrqLDnjBpF6av9MipKXwKJckwtydvmxvAhiDkAOTbDV+JN2+u+DBL/iWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097994; c=relaxed/simple;
	bh=Gx8C1yNPKMDCTUVIMjYgV2rDDEtfn9tsjEWhrCCiBE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BgRY8MpD5rEmreoo2mGVs8SIUn4XXsY9KFyYq7RE9kuMa0dgb/cDGcvtmaqK1oSLIAoXC5YnStihdF3l0DFRxzHB/6qFTH8g7TxpElZwBg5WzSKf7pq9teaPYfKj8GXIIwrV9z9P2zEYSmH1up6AGzUzqy/w+xUwaQjLEUuU7MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExfMwItr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExfMwItr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9977AC4CECD;
	Mon, 28 Oct 2024 06:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097993;
	bh=Gx8C1yNPKMDCTUVIMjYgV2rDDEtfn9tsjEWhrCCiBE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExfMwItrKdzSfqg0FlXl+kvpZLFGkpBweq3k0qnX8w++0BB1u8dW1X8oPrR9LgIZS
	 y3cs1HYTS1ETdSxbyPRlFpn4bJGOo+JeGCNsPTNO/Pw0hTW5UhAyHSXg1nnCBNiRyG
	 FGXcE7WyS47nO28OtPz6w2FqENzSeoxDDU4n+vP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 031/261] firmware: arm_scmi: Fix the double free in scmi_debugfs_common_setup()
Date: Mon, 28 Oct 2024 07:22:53 +0100
Message-ID: <20241028062312.793340338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 39b13dce1a91cdfc3bec9238f9e89094551bd428 ]

Clang static checker(scan-build) throws below warning：
  |  drivers/firmware/arm_scmi/driver.c:line 2915, column 2
  |        Attempt to free released memory.

When devm_add_action_or_reset() fails, scmi_debugfs_common_cleanup()
will run twice which causes double free of 'dbg->name'.

Remove the redundant scmi_debugfs_common_cleanup() to fix this problem.

Fixes: c3d4aed763ce ("firmware: arm_scmi: Populate a common SCMI debugfs root")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20241011104001.1546476-1-suhui@nfschina.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 6b6957f4743fe..dc09f2d755f41 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2902,10 +2902,8 @@ static struct scmi_debug_info *scmi_debugfs_common_setup(struct scmi_info *info)
 	dbg->top_dentry = top_dentry;
 
 	if (devm_add_action_or_reset(info->dev,
-				     scmi_debugfs_common_cleanup, dbg)) {
-		scmi_debugfs_common_cleanup(dbg);
+				     scmi_debugfs_common_cleanup, dbg))
 		return NULL;
-	}
 
 	return dbg;
 }
-- 
2.43.0



