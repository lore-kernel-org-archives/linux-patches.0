Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BFB22370C;
	Thu, 12 Dec 2024 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025739; cv=none; b=VaGDxUExd41twaQPfDb6Y7X+04dnLAK09WambzYDCXmyV2BdFb24Urgzfa/qALMf862QPSXYAjkwRPwsaFFySX5YmwwDz4azA/DMbN41MHPTBR3s4tDXa2KpPXrgidcxfUKrKIb7Q3GkjL3fJtD4jNRjLSMtLJ8hkEWYrxs/xak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025739; c=relaxed/simple;
	bh=z8uCcV3cipBz719El42Ge/u8ywaxH5EOQie0vCeOIOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd05JIN08DB/XGGE2AFZR4EqJ+Qr7Vdqze2gYgJLbSMfn01bP94fc3IkvYHOpSAUjev/MmtpGtdhg99iy2u+/AVmG+tTcyCEvNLZAEuRuZq0bHDZ9x6FCRFXdb/+1KiN1p6Px7DW8uWGu7M6DqqMvmYbncy5PiOIKz3ledZgUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUmIL9Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUmIL9Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B98BC4CECE;
	Thu, 12 Dec 2024 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025739;
	bh=z8uCcV3cipBz719El42Ge/u8ywaxH5EOQie0vCeOIOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUmIL9PhC2lmcw0uX+v3EtW+6NjCxpUiaaVd9zv0MU9OWB8Sr8Fwkti0dT5rW3onr
	 q1d6ujgpTq5UWTOGkY5Yd4YC4eafIOHHx82aPb/eOdPTKHakPFWbpbT8blstFfnULu
	 iY7ntzAcUJ/nGfXQCxgUUd9JfMQLbdP1Ckl8t6G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 270/321] samples/bpf: Fix a resource leak
Date: Thu, 12 Dec 2024 16:03:08 +0100
Message-ID: <20241212144240.647265468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



