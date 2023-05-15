Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4D7107AA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E524C433EF;
	Mon, 15 May 2023 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173573;
	bh=wf/CQwrXobsqVKvFfWAkYSPY5nTGIq93eNoEZI8vWsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgLTK6SpLpvBmeCU7g9ISlxnjt8x18+hNXbsVZanLaJRJS9DFus605B3R1cI9oLMJ
	 Az/hZsuyrl26/uzsHf4fRE4o4jdDwkaGz9Zh6c7LQLUW0wg4q4KSRkLCatvSeVfNCz
	 3tgbu4dYiGDe3wqcIhzPRthNX0567aTku+mrWM7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/282] bpf: Dont EFAULT for getsockopt with optval=NULL
Date: Mon, 15 May 2023 18:28:08 +0200
Message-Id: <20230515161725.544573215@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 00e74ae0863827d944e36e56a4ce1e77e50edb91 ]

Some socket options do getsockopt with optval=NULL to estimate the size
of the final buffer (which is returned via optlen). This breaks BPF
getsockopt assumptions about permitted optval buffer size. Let's enforce
these assumptions only when non-NULL optval is provided.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Reported-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/ZD7Js4fj5YyI2oLd@google.com/T/#mb68daf700f87a9244a15d01d00c3f0e5b08f49f7
Link: https://lore.kernel.org/bpf/20230418225343.553806-2-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index c2f0aa818b7af..08c1246c758ea 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1131,7 +1131,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 	}
 
-	if (ctx.optlen > max_optlen || ctx.optlen < 0) {
+	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -1145,8 +1145,11 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	}
 
 	if (ctx.optlen != 0) {
-		if (copy_to_user(optval, ctx.optval, ctx.optlen) ||
-		    put_user(ctx.optlen, optlen)) {
+		if (optval && copy_to_user(optval, ctx.optval, ctx.optlen)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (put_user(ctx.optlen, optlen)) {
 			ret = -EFAULT;
 			goto out;
 		}
-- 
2.39.2



