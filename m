Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774377;
	b=TgTymhNUTV5ZacpPBwWeqkaLTuUmM4IHqu3aX8GVx+0POHmqs0gL5sVTVXDDrMyCIDzT
	 7Qp4vYA5Ud3sQ6IJjqSaUp2AWtJ0i7GXGrlvP9isFotyTNmJsaXYno49XTirhTLlO+jwu
	 6xQKb5I5uKc30xf0L8/dzkQru1ECYqpXzOh4hLU6Iz8n3OqZ2/dyF3tVVfp+ysyqLK0bU
	 34HrcKtRZs04snGY0VKYHWSw6rVYTzDhWVGH+DQIMd1Tq9P0y7HzF7yVs77Bg2XeSKC2D
	 sz/s6Z/GI93mCgpNF0kQw8v1Zw79P4e48AVb4FXCtZJvpM/xRl1TTM45L2DQAZFTq6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S06avqWCcl1Yc/oOSdJFE6w/oQlRF8WFy1UVKn1uIUo=;
	b=RLVH2/kfzoyiZfX7lSdY6ib8+pZxeO9cxqYeItuu+mSqqCyx2z/zpj/IP+zWfBn/j87T
	 6y2j/CJL4Th9CtQWdDOzmC7wTarSYY0eGCiPMjilK1wQm07tc7AHvmclvyT8gMaXYGw9l
	 dQ63sPGIkwD23+I0YgAPfeatoEPcrMMq7V1Vfm2vqwV5Xntyt4NldJxbMIKvPQx8XZq0M
	 wQKgZ5hVwxAKQnbIQg0SgHlsvWC684egWePztPwshtY3kKsDOXkYpE1wo7Ay4EaQ4/wf9
	 DRDuvCx2nfNRxrrZeT/Gugv/wJkr7wj5L+u9BVot3kwBHJzR2DMwqcfygCIYUTHU9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3X4Jzl7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0595606A31A;
	Fri, 23 Oct 2026 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3X4Jzl7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74E71F01825;
	Fri, 23 Oct 2026 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774377;
	bh=S06avqWCcl1Yc/oOSdJFE6w/oQlRF8WFy1UVKn1uIUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3X4Jzl7sF2bgxWhMK6TkhfIhsXdgi+Xk4F1vSagntduaNgf/6GGk6534dWC+34mD
	 kNhgv3gJTfxPZbbXpsHBDGd/YeLOfb9IH7m+XCPEWPqEjygKPF/SlBM2mV9AQIlDeh
	 WA2Y9l6YTVvqFUInTldi/2Q5zKm8HfFs8hnjY76E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 021/242] tools/power turbostat: Fix add_counter issue if > 24 counters.
Date: Fri, 23 Oct 2026 18:37:43 +0200
Message-ID: <20261023163714.284070438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 154b96dab83fd953b9b82c8bcfa041cd6a9d74d3 ]

We allocate space for added counters ahead of time,
and we arbitrarily chose 24 added counters of each type.
If a future code flow hits this limit and continues,
and then removes counters, we do a phantom increment
and lose track of the number of added counters.

Increment the count only if there is no error.

Fixes: 388e9c8134be ("tools/power turbostat: Make extensible via the --add parameter")
Assisted-by: Claude: Claude Sonnet 4.6
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 40f5f9a9e950d..543482d1e93cb 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -10675,10 +10675,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_thread_counters++ >= MAX_ADDED_THREAD_COUNTERS) {
+		if (sys.added_thread_counters >= MAX_ADDED_THREAD_COUNTERS) {
 			warnx("ignoring thread counter %s", name);
 			return -1;
 		}
+		sys.added_thread_counters++;
 		break;
 	case SCOPE_CORE:
 		msrp = find_msrp_by_name(sys.cp, name);
@@ -10687,10 +10688,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_core_counters++ >= MAX_ADDED_CORE_COUNTERS) {
+		if (sys.added_core_counters >= MAX_ADDED_CORE_COUNTERS) {
 			warnx("ignoring core counter %s", name);
 			return -1;
 		}
+		sys.added_core_counters++;
 		break;
 	case SCOPE_PACKAGE:
 		msrp = find_msrp_by_name(sys.pp, name);
@@ -10699,10 +10701,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
 				fprintf(stderr, "%s: %s FOUND\n", __func__, name);
 			break;
 		}
-		if (sys.added_package_counters++ >= MAX_ADDED_PACKAGE_COUNTERS) {
+		if (sys.added_package_counters >= MAX_ADDED_PACKAGE_COUNTERS) {
 			warnx("ignoring package counter %s", name);
 			return -1;
 		}
+		sys.added_package_counters++;
 		break;
 	default:
 		warnx("ignoring counter %s with unknown scope", name);
-- 
2.53.0



