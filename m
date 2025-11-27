Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE31274652;
	Thu, 27 Nov 2025 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255762; cv=none; b=Uchb0Lh3dgiSlppUqTCzVaUIT4CMJHLPxYMaIUPI9siB5q35o1XJquBM8NYsWO9YT1BRX6x2dCiRYubAXrXABLkRTfnpXLSxxxsioTczldXIa7ak8ZFJgyPuW+Goy6+Moazumq0VY4tJXLDTiYVtF3+Q2pRgeMj1q882i4kfd3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255762; c=relaxed/simple;
	bh=iFg5h5kHJaBJ04YCueAB2/oH2n1GvUhUAjLJw7Ha11c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGe/OmQNdmM2Uav3dMXObptT9HNKCHAJSeL1LgkfpmCeddE/lL6FnpwRPz0wB+n1lIZ9q7RQVwlGs7PPrgoxoTLqZLRHRPcb6UzAmHvP05INf6npb3Px3R/3+TgGxIz9j2GzbMSJQG+wUTQn7UXRKjD6OiTgXP66aChjtsVopIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zltemDYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zltemDYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F6CC4CEF8;
	Thu, 27 Nov 2025 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255762;
	bh=iFg5h5kHJaBJ04YCueAB2/oH2n1GvUhUAjLJw7Ha11c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zltemDYXiwyZm+j1vIMMgxtNj60SQFhnNjF7VXjOaUrNAuIWNKm/tvkwycd8PcUBs
	 4RXdtUiuXnE/ka2kWjKAsVtRb+UAeLhoKW46o6ZeP9AxKroMLkHU363B+QBGNFbz6k
	 tg2/J5vGt8rs/VM3Ti4R4Bq4yU7aTXau+g9cIOXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 106/175] s390/ctcm: Fix double-kfree
Date: Thu, 27 Nov 2025 15:45:59 +0100
Message-ID: <20251127144046.829770439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0aeafa772fb1e..407b7c5166585 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -701,7 +701,6 @@ static void mpc_rcvd_sweep_req(struct mpcg_info *mpcginfo)
 
 	grp->sweep_req_pend_num--;
 	ctcmpc_send_sweep_resp(ch);
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.51.0



