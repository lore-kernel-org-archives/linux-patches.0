Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DE0222D7B;
	Thu, 12 Dec 2024 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023361; cv=none; b=b9SJ1nm3BvSn83mBiWwrzNNN3O6rBpl9MMYTHCb2T88AeYhDeHKitdOBCuqFf3tXpsOUEFGNuROazg4/ASItm7MCtaHlqBQ5iucwIwub+TGK2yODNq5uYqBtHQjYfs8IKmuK7FKDOX1Rg7sNfCaMC1C2GbZP/n6musNG7o0W6YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023361; c=relaxed/simple;
	bh=bRzXEkuXEKxzAijG/LnGsUus7BMwcFG8auODbBu5pcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0Wxdhqli+WAjxGFHpuhXMeZ49p1R2wXjgwNIl71waui1gHcPkDU2R2weBO+AavMPPYsz7bTnWuaWTq6bsqMNWgxCDcWrTNLe2WDxEKd1bSM3eVzcHUTMaZ/fgvw+dzcE740THAB4g14GWHbTJ5MUHlY3JwJ1ZiAmtcscVP7xlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZD+7eA+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD+7eA+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5179DC4CECE;
	Thu, 12 Dec 2024 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023361;
	bh=bRzXEkuXEKxzAijG/LnGsUus7BMwcFG8auODbBu5pcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD+7eA+t3w96NsrxXqATwUnpgUUhK/a3alYNH4MNkxLccqM81GFskINNsCbhUpyTl
	 yy9VkcDrJn2oc1DPpY9+pJUCxyNHUU6kPCISnJGbFr04O6og7Q6IMwG3weCzZFccMT
	 J8iLCZalqH59cYUX1cUAW3by7JGmMr+oDvA4KGN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 482/565] samples/bpf: Fix a resource leak
Date: Thu, 12 Dec 2024 16:01:17 +0100
Message-ID: <20241212144330.815053194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

[ Upstream commit f3ef53174b23246fe9bc2bbc2542f3a3856fa1e2 ]

The opened file should be closed in show_sockopts(), otherwise resource
leak will occur that this problem was discovered by reading code

Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241010014126.2573-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/test_cgrp2_sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/test_cgrp2_sock.c b/samples/bpf/test_cgrp2_sock.c
index b0811da5a00f3..3f56519a1ccd7 100644
--- a/samples/bpf/test_cgrp2_sock.c
+++ b/samples/bpf/test_cgrp2_sock.c
@@ -174,8 +174,10 @@ static int show_sockopts(int family)
 		return 1;
 	}
 
-	if (get_bind_to_device(sd, name, sizeof(name)) < 0)
+	if (get_bind_to_device(sd, name, sizeof(name)) < 0) {
+		close(sd);
 		return 1;
+	}
 
 	mark = get_somark(sd);
 	prio = get_priority(sd);
-- 
2.43.0



