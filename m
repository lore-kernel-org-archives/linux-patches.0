Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED773EEAE5;
	Wed, 30 Sep 2026 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796682; cv=none; b=Hndz+btRu4wyDjJbmplFqxAIignRRc5v00d1dVgcwVHwHm4vv/RAlrW9WfIr9yF9bYMGpI3qRHw0NFlo0uCSxJF562ndpcLIFmtCX9NMin1316GmbdI3WV9RTye+gS5kdEpiLDoClabRrfJUpKcS17B5jw2y0y8jQDKrX0Hn8bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796682; c=relaxed/simple;
	bh=M0777EDXNn8aJqIlGgjICpw4Mp4XISw9iKJQ2S5gg5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKjPjbncPRQvFR558/xwhIpN1UQ1vnoVsTzQexTFcRbo1SnTkOAAhJ7bCAUvQXZiJRLAkpo7UO7h6SNcFAOBiIZZzj7tz4L6gvYKKggxK3rcS6iRpCh0BTp6ip6GG+Hiaz7PuXhAu7ZD8F6Ci/gvsqvrMjR6wOXStY64m0N461s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooDgtYEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooDgtYEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE121F000FF;
	Wed, 30 Sep 2026 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796681;
	bh=iJgCm2c54rTQxAiu4Y7p3jUSAtIF+1r7Hq1Fxxgdo4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooDgtYEajxNO3+Ob8BRs2Ssmkv5XeLnA169EIskKyT71NZhXITqHBjuINSblix/ke
	 l+zDwauMNE4sFE64zzc66Hq+H1l/tLjq0DEhHjIM3AzcvjZSarpjamUT3zJxTaEAWn
	 HST57cFYuDtnG5UkQmkEIV8jVp/BCVEKSQcQ5B6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0954/1193] apparmor: Fix memory leak in unpack_profile()
Date: Wed, 30 Sep 2026 17:27:18 +0200
Message-ID: <20260930152455.437578619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 8ead196be219adade3bd0d4115cc9b8506643121 ]

The aa_put_pdb(rules->file) should be called when rules->file is
reassigned, otherwise there may be a memory leak.

This was found via kmemleak:

unreferenced object 0xffff986c17056600 (size 192):
  comm "apparmor_parser", pid 875, jiffies 4294893488
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 89 14 04 6c 98 ff ff  ............l...
    00 00 8c 11 6c 98 ff ff bc 0c 00 00 00 00 00 00  ....l...........
  backtrace (crc e28c80c4):
    [<ffffffffba25087f>] kmemleak_alloc+0x4f/0x90
    [<ffffffffb95ecd42>] kmalloc_trace+0x2d2/0x340
    [<ffffffffb98a7b3d>] aa_alloc_pdb+0x4d/0x90
    [<ffffffffb98ab3b8>] unpack_pdb+0x48/0x660
    [<ffffffffb98ac073>] unpack_profile+0x693/0x1090
    [<ffffffffb98acf5a>] aa_unpack+0x10a/0x6e0
    [<ffffffffb98a93e3>] aa_replace_profiles+0xa3/0x1210
    [<ffffffffb989a183>] policy_update+0x163/0x2a0
    [<ffffffffb989a381>] profile_replace+0xb1/0x130
    [<ffffffffb966cb64>] vfs_write+0xd4/0x3d0
    [<ffffffffb966d05b>] ksys_write+0x6b/0xf0
    [<ffffffffb966d10e>] __x64_sys_write+0x1e/0x30
    [<ffffffffba242316>] do_syscall_64+0x76/0x120
    [<ffffffffba4000e5>] entry_SYSCALL_64_after_hwframe+0x6c/0x74

So add aa_put_pdb(rules->file) to fix it when rules->file is reassigned.

Fixes: 98b824ff8984 ("apparmor: refcount the pdb")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index bdc784fafbf74..589b43c34703e 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1053,8 +1053,10 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 		}
 	} else if (rules->policy->dfa &&
 		   rules->policy->start[AA_CLASS_FILE]) {
+		aa_put_pdb(rules->file);
 		rules->file = aa_get_pdb(rules->policy);
 	} else {
+		aa_put_pdb(rules->file);
 		rules->file = aa_get_pdb(nullpdb);
 	}
 	error = -EPROTO;
-- 
2.53.0



