Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEA624677D;
	Wed, 25 Feb 2026 01:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983835; cv=none; b=DrBaYAIrQ/tHeyc1p5hPJlO7UL9E+4WLMcO0TyUbw6JzmTtSwB7bJQKMF9RIizU54jvY9yBwuQZ3oYI0E1znnFTrCx/eq0/EQ6w8STSGPg/d9TRi3ekjSUwEDfAShhXGqRn05rTSbbkhMdWoVsg3PmTbfJM1RsRS3u4pKBR4VBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983835; c=relaxed/simple;
	bh=UPbEM0wOoadFE6QJouIjw86MUiYhvgMcliXTHVY/RIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKUPYc7Lq39lPNzbC3MNUTNdky608TJragW6lshWDWw8jq1r+/AmttJKQJungx4/GErLbRNKbzxva+/hSG79blHCTyQlYsji/HBare/+KsUPfNC+dGQFH/NHeIwXrg3q9URdjac3k/j8cGY3+ovnry5OYZZEybs31UlvgYiV7fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJf/AObx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJf/AObx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34949C116D0;
	Wed, 25 Feb 2026 01:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983835;
	bh=UPbEM0wOoadFE6QJouIjw86MUiYhvgMcliXTHVY/RIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJf/AObxvoldGaapDCImY0IsZN5QbpalU2F1eikaYPOvCU6B+xHibjwEFMSt8VQAL
	 u8TwKS9c7wEkosd6HJb079f0I00Al+Ru09Wy6T4eWA6WGVzLX6VFNDGQqEqf+u+8dy
	 44BXm1y62jbgpAAcj7PXZjmngN+NYta1Zw1O6yo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrea Righi <arighi@nvidia.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/641] sched/deadline: Clear the defer params
Date: Tue, 24 Feb 2026 17:17:21 -0800
Message-ID: <20260225012351.916701328@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 3cb3b27693bf30defb16aa096158a3b24583b8d2 ]

The defer params were not cleared in __dl_clear_params. Clear them.

Without this is some of my test cases are flaking and the DL timer is
not starting correctly AFAICS.

Fixes: a110a81c52a9 ("sched/deadline: Deferrable dl server")
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260126100050.3854740-2-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c7a8717e837dd..72499cf2a1db5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3591,6 +3591,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
 	dl_se->dl_server		= 0;
+	dl_se->dl_defer			= 0;
+	dl_se->dl_defer_running		= 0;
+	dl_se->dl_defer_armed		= 0;
 
 #ifdef CONFIG_RT_MUTEXES
 	dl_se->pi_se			= dl_se;
-- 
2.51.0



