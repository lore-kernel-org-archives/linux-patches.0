Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426B3316184;
	Wed,  3 Dec 2025 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776590; cv=none; b=muSoU+hsKg0sDnxsxbHkPDPtc3l8e2tLkPFuPR28fZhqG2Qwov/co5TvsM3iCYAH/MzkBUeC8FVWBuoF6NrrI5xTaqyCFCEmflknZglvW+WFfWtcdJaPb7zI2ifQ5Hg/dImSlEOJHu+8B0ahagmOZnbrGJRsfr229pIzCeYbULE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776590; c=relaxed/simple;
	bh=r8czQAAq2tW03GMzoyhNzYG9PDgLTqUKNp/pV+3vmE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJNYE1egf6EpI3rm+IuVL6n+rZ5ICDpadYs90AL23JxsV2N9s+u0N5LdDKmQl6SlAMUwI/OleKD9JPjNn3ZTbGtAlpXrto+7p1xWKTyOiciFjRFbIMOxiVjymXYk3Ru1sUvD5mKrYhAj3OqtTVKAx3jC1v/Tx29Uxq+Ye5Tvpig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AA2UIcse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AA2UIcse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE8C4CEF5;
	Wed,  3 Dec 2025 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776590;
	bh=r8czQAAq2tW03GMzoyhNzYG9PDgLTqUKNp/pV+3vmE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA2UIcsew4t+su10cVk+yqQpwFDecl8cFwwN/akrCSzIQGoBoOCslUnilxwoSZZpQ
	 aU8tB8KIuPo7isZofp6EDTAGS0M4TFcd6mmC5UXdilGZrpDjQKFCkUrG1ja5+E8C0B
	 7791t4M/KJPwYdqemWZ6PJ/BpMAmGgkMLUoDS1rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/300] s390/ctcm: Fix double-kfree
Date: Wed,  3 Dec 2025 16:27:12 +0100
Message-ID: <20251203152409.073265690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>

[ Upstream commit da02a1824884d6c84c5e5b5ac373b0c9e3288ec2 ]

The function 'mpc_rcvd_sweep_req(mpcginfo)' is called conditionally
from function 'ctcmpc_unpack_skb'. It frees passed mpcginfo.
After that a call to function 'kfree' in function 'ctcmpc_unpack_skb'
frees it again.

Remove 'kfree' call in function 'mpc_rcvd_sweep_req(mpcginfo)'.

Bug detected by the clang static analyzer.

Fixes: 0c0b20587b9f25a2 ("s390/ctcm: fix potential memory leak")
Reviewed-by: Aswin Karuvally <aswin@linux.ibm.com>
Signed-off-by: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Signed-off-by: Aswin Karuvally <aswin@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251112182724.1109474-1-aswin@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ctcm_mpc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 20a6097e1b204..4e6f340d09261 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -712,7 +712,6 @@ static void mpc_rcvd_sweep_req(struct mpcg_info *mpcginfo)
 
 	grp->sweep_req_pend_num--;
 	ctcmpc_send_sweep_resp(ch);
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.51.0



