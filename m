Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B9289811;
	Thu, 27 Nov 2025 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255424; cv=none; b=Ec/3pxwhAG4LUbo/tUQt4CH6Ffg0IWDRUhmABAqUO+HEYLoNpfoPQUchCGjq1FqaW/8ddmhzOOkyIEf9DnZghNMgHqmiOsyydK90DMgDNmlvZDBtcSMba15js+rVMY1k/dJtYHyySmDP58Mmp3Py8ALylNHcFgc1jXOhLkpzmxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255424; c=relaxed/simple;
	bh=uCR0SMBhHzO/YDpHYXisB/iSJOR06R3Wyjwzfb9ioaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LORJIqwtkCiiARywA+N4jwGNEDbfzFPHbjspD1q54tH5IJ882sfhBu0ipmBbS99TG9RN5kWAg1UV0puqOzC0xRYw/ouR+IMCEaraRTwYDuqTNWFVyZKLFW6eH1nlFkORhLJYqtOBFKA3JXB0hGQLoFg5teUgUYgDf2oPE6mPYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roT5BUIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roT5BUIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2122C4CEF8;
	Thu, 27 Nov 2025 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255424;
	bh=uCR0SMBhHzO/YDpHYXisB/iSJOR06R3Wyjwzfb9ioaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roT5BUIkL6U0tTNAjgvTBLv71CXiMrCFs4DFKWgtz8QVG8fx9h/peI4HJvrtszxCL
	 AHtFNZfDG06YIMzv3xZiosuG6XOkwqnLw4XI80cMeMJhDk1Md7OHQf/Na4aKPOquPy
	 ydjifi2P/TOBiTLzLxZugBCRUES9oyrWCNtG95/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/112] s390/ctcm: Fix double-kfree
Date: Thu, 27 Nov 2025 15:46:10 +0100
Message-ID: <20251127144035.330334127@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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
index 9e580ef69bdaa..48ea517ff567a 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -700,7 +700,6 @@ static void mpc_rcvd_sweep_req(struct mpcg_info *mpcginfo)
 
 	grp->sweep_req_pend_num--;
 	ctcmpc_send_sweep_resp(ch);
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.51.0



