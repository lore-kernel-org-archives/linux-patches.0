Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC079168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC7C433D2;
	Mon,  8 May 2023 10:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540586;
	bh=LMIRdMaa3fH7lGEg6C1PbLcnWMZuqYKIUZ5Rmn4b2hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxM+QEk1yGUhTvuRrzGNCrOLZSOaWGnFNnkou6FsmRIUtuRMSR2vq/Cn9xjaP80dr
	 ulkhIhflpuE9Zv33oh+xJH+Wn40f3nniiHuxFq5vkkV6zlnVR3jJumdrfPHISXoQ8S
	 OrIRxXYnWlIzcI65qYYd78jILSMXnjFZye4dY+hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/611] bpf: Dont EFAULT for getsockopt with optval=NULL
Date: Mon,  8 May 2023 11:43:50 +0200
Message-Id: <20230508094434.909838193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index bf2fdb33fb313..819f011f0a9cd 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1921,14 +1921,17 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	if (ret < 0)
 		goto out;
 
-	if (ctx.optlen > max_optlen || ctx.optlen < 0) {
+	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
 		ret = -EFAULT;
 		goto out;
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



