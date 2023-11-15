Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689FA3309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR3DAXY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F411C433CA;
	Wed, 15 Nov 2023 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077677;
	bh=N7zcSVg1LGoeg2oAkiFP3KN2zpB/EWToiUVRaPIB5I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YR3DAXY6oWRO/Xyb43fQXFPmvOP9/0+T2j4+HkNaluxXHbbitbol2RW5wRSARFXZY
	 6s+ki7hUbLMQqqFU4HvMxf3J2NWN6Kbu5qhT7jMNWRdfglbdD+HJd1oBQILEx6Gt/j
	 mdLVKbStVNEdWD6UU/1Ybr2Zdb0PVMbd97BBlmgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/603] debugfs: Fix __rcu type comparison warning
Date: Wed, 15 Nov 2023 14:16:27 -0500
Message-ID: <20231115191643.382799831@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit 7360a48bd0f5e62b2d00c387d5d3f2821eb290ce ]

Sparse reports the following:

fs/debugfs/file.c:942:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
fs/debugfs/file.c:942:9: sparse:    char [noderef] __rcu *
fs/debugfs/file.c:942:9: sparse:    char *

rcu_assign_pointer() expects that it's assigning to pointers annotated
with __rcu. We can't annotate the generic struct file::private_data, so
cast it instead.

Fixes: 86b5488121db ("debugfs: Add write support to debugfs_create_str()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309091933.BRWlSnCq-lkp@intel.com/
Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Link: https://lore.kernel.org/r/20230922134512.5126-1-quic_mdtipton@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 87b3753aa4b1e..c45e8c2d62e11 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -939,7 +939,7 @@ static ssize_t debugfs_write_file_str(struct file *file, const char __user *user
 	new[pos + count] = '\0';
 	strim(new);
 
-	rcu_assign_pointer(*(char **)file->private_data, new);
+	rcu_assign_pointer(*(char __rcu **)file->private_data, new);
 	synchronize_rcu();
 	kfree(old);
 
-- 
2.42.0



