Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207457;
	b=ET8xqg6IytGxMmg+plUOKP0yWeULzxPK+H+CsNvrJbC8zpUoNJToYtd+o4Hilh3ZQHOY
	 4psPlbdmEhsy6IsgHzmhc1BWH9FTKeyKi4WHLl863ZtXeeh5X9JGJbkpEw6iPk5R+SmLj
	 R87R7U0UL09u/LxnLtfFwctUvzYkJjOvuTLbqDdr6ID1PG8+rlt/A1FLkPwWPP98d3Ep4
	 JaM6sJ1cbk7nFAPSmupxS8rGYdEo4l78QljE2Bgy3qBJ8+REm1VckeYdJi5LkovKOwouG
	 xJ8ci/LMK72heJ+rRzJx+Wn7G0q8nLc7IwMPEFP5JJMt0JKRyzLdXL2FglB4Rlg8OSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YqC9vMKno2xZmdvnxuaqPtyRPfkG+3N/L3NY8UJTYA=;
	b=wUeut3cFBEqRqBemX005XwrNzXym+pJ9KDBimRf6r9o3mFVz3rLODrJcIQ4pmMHKk8E2
	 CmipSRktGqhzWdI/3tOvTq4iLX6DtXHElP61kX1BIJ2ckTzv1Zs+S7C+1VL95aT7V0dwT
	 5eg6UjjIlQe7Q9M9IjDr5+rbOvAEmIRpGbqSb59yCb5iArJ/c7fZjLqKmmMe4U/a2CVSF
	 R/GIvO5FZnRb1qmYJ/TWEE1oza1FW/PiTme99IaawP1xh90/8dT6iySmypvRnvql9NmYy
	 gosIDKa7bU+6EG8QFiMhPgFQgNNo50KxxrHykhN2tH4baats7DaE6GISWJTDwDwrxvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMDVBMiF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13D8606A31A;
	Wed, 28 Oct 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMDVBMiF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1911F01825;
	Wed, 28 Oct 2026 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207456;
	bh=9YqC9vMKno2xZmdvnxuaqPtyRPfkG+3N/L3NY8UJTYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMDVBMiFdAskvHtC2Xvivm5EbJsCfS4Pl1lWTDYj0ggBeRdwx+bw+dzHZ5XsXoBf5
	 yH5O/IWWbuA1/D+TyRi4h8gRyAUC/xkGtOx8sK3drR++xnsii33KbCuGmPxldvpGMD
	 SU9F/zFl664q8v0zJKhB7BA6lrHSMk1MY8tFFYj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/247] tools/power turbostat: Fix add_counter issue if > 24 counters.
Date: Wed, 28 Oct 2026 17:57:06 +0100
Message-ID: <20261028165947.914346632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b6180baa188d..4947c38fc4f3c 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9330,10 +9330,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
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
@@ -9342,10 +9343,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
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
@@ -9354,10 +9356,11 @@ int add_counter(unsigned int msr_num, char *path, char *name,
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



