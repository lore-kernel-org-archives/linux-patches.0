Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3561850A73;
	Tue, 23 Jan 2024 00:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970069; cv=none; b=RR8i5G6csaL+muDmbL7HbkB8S9Gax66Kfol+RIdKK8iVebP6oO0gzafpd9jTKXaHRv3500l5VGUEvEzo778ijLpeUaCvuaAyPGOKRNgyT/sEADmQsQDkGfCUCXwnzW39tDGA2z5kIQvYN5D8e/Rcm/7cbigTK2bXKk+4lvQHM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970069; c=relaxed/simple;
	bh=S8g9Lc0UUxIxps6ELkh7Wll19Hma3BB+LaJ2CfKmA4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQa9KR/+6qTNBx/cvpHMTr5Ri22aztA/r2e0JgVpXjE28UVlh0zjH2dViXyboCzgQmwax3N2nJKJEnE38ztB0J8lwb4sGZrIacQeuBA5n8RK1+DwxzVClBcsquCgnnveck78YjRRbczf6UnfDLfiwL6HS6yw0ORMfdYcMmQQdyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8O6sq97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8O6sq97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AC5C433C7;
	Tue, 23 Jan 2024 00:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970069;
	bh=S8g9Lc0UUxIxps6ELkh7Wll19Hma3BB+LaJ2CfKmA4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8O6sq97cIeL6NoV30mUOcFYEgtzY/sndfm3OmQX/TTrZ1Dl+hUh+13fcUyT7973m
	 ZuYIpjWywWMFckxaQWcI2aWjFuO9F7a5OG8HV/q7Ii+aPgTgM3FcaA6ASkWKmLEtIU
	 fYIXvNZq9LkmJy8c8spcXnBoT/g6HpIF81QJKzzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 577/641] apparmor: Fix memory leak in unpack_profile()
Date: Mon, 22 Jan 2024 15:58:01 -0800
Message-ID: <20240122235836.230098831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index dbf7d96257ad..5e578ef0ddff 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1025,8 +1025,10 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
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
2.43.0



