Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D0A3451C1;
	Wed,  3 Dec 2025 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778279; cv=none; b=EdsUzhU3cCvXEHuyOZ+DX7TliyoIh+WLwHdmFW7B8dzw7nOhNh+hNK+8yr9E2sZOWKExKeEonLv5ptpyhgo9BQZKcVfeOm4fA7/l14o4/B6+I68wjfzuOG9JRBdLNWKJgFPNUeeNiaIyL/iLj1norna1j04CMu5v2ceh8I4MIIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778279; c=relaxed/simple;
	bh=aU1rOZJDMMYKJa/nDgNHrjYnqy6jbizy06YuQbeIzck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDl19Q6w8TAaqX7d5V6jeN2j7NT491KRP4QOLFgSKig8j0f0eyg/lNOZv31HrH9etWn76gAe6tiK+8gNLCbuEB7Ir5PPrEgSeMPvVaHwqOgb+oTcOVZFISqymIXE+IRbaFq62hSCLIUakxQ3PpU0wGvTEomLl3qglSWi7z4t/ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKYtx1/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKYtx1/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9259BC4CEF5;
	Wed,  3 Dec 2025 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778279;
	bh=aU1rOZJDMMYKJa/nDgNHrjYnqy6jbizy06YuQbeIzck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKYtx1/DimpigI0eiWnNH/wx+6kjE53rDNdpDPA6xoj10m0FdDMaPhnrmZYhURQgj
	 E8DUPVQwSygecoovgrHfHAXoJYouDKOgff+IHudON1XJ6kQBrDB4ylvxUscyjYC0Gy
	 6EBP8MZbD34iFjDTl5fxVUQyoujOcxSnnex4TV+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/392] s390/ctcm: Fix double-kfree
Date: Wed,  3 Dec 2025 16:27:27 +0100
Message-ID: <20251203152425.097283590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be03cb123ef48..cde36a3b6c03c 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -698,7 +698,6 @@ static void mpc_rcvd_sweep_req(struct mpcg_info *mpcginfo)
 
 	grp->sweep_req_pend_num--;
 	ctcmpc_send_sweep_resp(ch);
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.51.0



