Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F135C1AC;
	Wed,  3 Dec 2025 16:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780168; cv=none; b=cEMvVZryDOpDft6jr3geyNaaylRvAO8hD+vfAsnrwf1/WsdKV90wayyli5YxrFGYiLFc9ch2qQwgWhgg+YcHKbHzaa2SundGXaDa1ISxeb7fWkCke1+eyJ7JjmYfy/AV2/y5HQ6GFf/Qncmp79epayTuP/s9+DsncxLppD5ni1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780168; c=relaxed/simple;
	bh=7nkiVVuXJ2DArrl6U8URNFuQ0BEhVZVIHTdaWMZNM14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsUfATY7YPHcCNJCb3/o0lo0dXE3ovLyQ6NCMAZGaYYCY+96SLtE/OIC4KelguIrvMA8tNYrtdwd7bPJM5Om3TnuisWVQwcQ0SFGkyT4tXxAE2n1A57uTE0VIeQTYFpKAZ21SJ9VRjveBpB4mDL+N8+bZ3eW7iIj3T5MVJUhiVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA2AdImp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA2AdImp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD9AC4CEF5;
	Wed,  3 Dec 2025 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780168;
	bh=7nkiVVuXJ2DArrl6U8URNFuQ0BEhVZVIHTdaWMZNM14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mA2AdImp7QnmwmndG1EWRDChKWV0aoto0xfhqFbPQ5RoTSJ17ZyH4OsAVSSAct7H0
	 7SIT0D2ZpouFZD6Wbaz7NSzANOjdIwNXqXOalea+f27IzIfW3dv1bVEcEoc5cu9TdM
	 8CNCRq4HLCoEYrFAe6y0yaPf5BmxsQwhYdKChCZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 459/568] s390/ctcm: Fix double-kfree
Date: Wed,  3 Dec 2025 16:27:41 +0100
Message-ID: <20251203152457.516391485@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8ac213a551418..55216d2fbea0b 100644
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



