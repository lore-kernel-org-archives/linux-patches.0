Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF078481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D53C4339E;
	Fri, 10 Mar 2023 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457613;
	bh=42NXa3rkxB0hPj2cneXedkTKdbGvXlgJG/EirB3pMUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcmTTiZgZ+Jpu/bE57QC2ApYon3sfyqoHqqPZHdrpM70cn+j2TfPGBeT2Ze4H79n9
	 5w2W+NDpr9cbCLPkQmUpMESlafoumi8XiIxXK2UPPD5J8YfwhWaJ43Wa3xuMJW81md
	 SbttadUwwFEMuuF4+VlnS2XO8Ha6GnFngunAVb2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/200] kernel/fail_function: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:34 +0100
Message-Id: <20230310133722.230740045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2bb3669f576559db273efe49e0e69f82450efbca ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230202151633.2310897-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fail_function.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index a7ccd2930c5f4..d971a01893197 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -163,10 +163,7 @@ static void fei_debugfs_add_attr(struct fei_attr *attr)
 
 static void fei_debugfs_remove_attr(struct fei_attr *attr)
 {
-	struct dentry *dir;
-
-	dir = debugfs_lookup(attr->kp.symbol_name, fei_debugfs_dir);
-	debugfs_remove_recursive(dir);
+	debugfs_lookup_and_remove(attr->kp.symbol_name, fei_debugfs_dir);
 }
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs)
-- 
2.39.2



