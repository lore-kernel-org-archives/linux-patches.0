Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E402926FD93;
	Wed, 25 Feb 2026 01:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983658; cv=none; b=F/g5YZqmoAFBO+Ld0WXicELC/xjRQMv9F9y8OjqMej2zWoWb7tndvF7cXgqk02Jt0Bl8ymrCLTLwEJVyN+nYWTmLk3HG1u0io0IKZz4npwH5Mua9HYRB29GPzFgycA2PlrzJJnhINZhMO1nLdjzka6f40SLqJ0bU+2FpOska4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983658; c=relaxed/simple;
	bh=6WWeMpRkkpSwuP7xcgr/9zjmETzqTh8CZiFGlN02Pqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ0czhWUtgYUoHF9Ji0ZsYUNwMjqt5/OZojgocxK9aifAsiPhgUyVvQkv8mrJhxl3/LY77OaWZq5M42kz3A2QbIISFAHIzXILPzBf+7KR9KWqnotgrIDZKcMMg4yUelyOffEUa4TBiu2x/J8QhWwd/fxkanV3yVhuHM0NoyuUrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwQekAYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwQekAYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6331C116D0;
	Wed, 25 Feb 2026 01:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983657;
	bh=6WWeMpRkkpSwuP7xcgr/9zjmETzqTh8CZiFGlN02Pqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwQekAYAT6fxF+T1a0hvfupfoXSXmyqIl7hpwDVCUHJ74ErwuJGyO1/NLsBM6bYWD
	 /zyylXRaSAwLLOZaXqXVAzEtOqWtWItgeb5laWe82HqUI6ZkK3DGr+JVKFBJ9r0r7+
	 3u3sLlEmFGhDOc+Agk1LtMqTXpL3qDwvpesjqHt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 700/781] apparmor: fix rlimit for posix cpu timers
Date: Tue, 24 Feb 2026 17:23:29 -0800
Message-ID: <20260225012416.925853756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 6ca56813f4a589f536adceb42882855d91fb1125 ]

Posix cpu timers requires an additional step beyond setting the rlimit.
Refactor the code so its clear when what code is setting the
limit and conditionally update the posix cpu timers when appropriate.

Fixes: baa73d9e478ff ("posix-timers: Make them configurable")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/resource.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
index 8e80db3ae21c0..64212b39ba4bb 100644
--- a/security/apparmor/resource.c
+++ b/security/apparmor/resource.c
@@ -196,6 +196,11 @@ void __aa_transition_rlimits(struct aa_label *old_l, struct aa_label *new_l)
 					     rules->rlimits.limits[j].rlim_max);
 			/* soft limit should not exceed hard limit */
 			rlim->rlim_cur = min(rlim->rlim_cur, rlim->rlim_max);
+			if (j == RLIMIT_CPU &&
+			    rlim->rlim_cur != RLIM_INFINITY &&
+			    IS_ENABLED(CONFIG_POSIX_TIMERS))
+				(void) update_rlimit_cpu(current->group_leader,
+							 rlim->rlim_cur);
 		}
 	}
 }
-- 
2.51.0



