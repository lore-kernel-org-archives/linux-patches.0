Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0451C20A5EE;
	Thu, 12 Dec 2024 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024721; cv=none; b=eI3W6hqv4TiMStoWhmVJBmhkEpTPP81tvPBLzmxiDRiQ9SOhinzYEYiUvFLTE12y8VnqMZ9Xa8xydN6ZrgBaQKXdxTj0yN/f7vyPcVTQTGwS3oQHNJm3KJzos9zEwS3C2df0+1H72iuZJ3UY9+zu2KcMjD+NMTvIGdo0mXrbrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024721; c=relaxed/simple;
	bh=WaRhg7/yfJvEnQy91ClQtg8oeyOwNzKBYXxlHGtbpj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlcx2bbkkCyzoJ2AaxgTqNHXW3xPNE/TFUcbwM1ywYavBMis79jzift10SyZlGd8ZVBlYV+XfuI62dV6emDUrYxXdXZeXkw1jSqbrRt4j2CjYE3rt4pqxekheWpZKUWS22J3venkEDRtSktwEZ6fuFrYNjAJ0AgmkBvb0Pho2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGCeyy7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGCeyy7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BBBC4CECE;
	Thu, 12 Dec 2024 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024720;
	bh=WaRhg7/yfJvEnQy91ClQtg8oeyOwNzKBYXxlHGtbpj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGCeyy7L2/fLc4m0B+dw1g/i+1l2HA8NNe+u0E0pm7HxgRQV2Gf7CoHWoCuORaL5f
	 EBTas6gnuGqkssJALM4+8TTNbqhMvPYz64/vJ5RJPQnz5kF/fKIk8aRmzo6HAuO+YR
	 DbKh/tcUZuRsYgQXzSIiKyIcgmb58wuQh+SMthBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/459] samples/bpf: Fix a resource leak
Date: Thu, 12 Dec 2024 16:02:08 +0100
Message-ID: <20241212144309.174311737@linuxfoundation.org>
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



