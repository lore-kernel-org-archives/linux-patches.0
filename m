Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122934C6D
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F42C433D6;
	Mon, 14 Nov 2022 13:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430841;
	bh=A2uZ4Ip+tHv+FK3kUEA0ZuXtdZktkDaepej8/P8O8L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwSUzdC9+6Fzuv3IxIvcJP8ttJapm8sXLorJoAXBKFJichHjyfiT9DwY5s3Nt6M5p
	 BlSpTiIdUMm6u+XDTG2HJGh0A/MI+4ig3AlHEPElbHJLHwWU/CHlol9DJous4YVAi9
	 +TM3hww5FMJKtD4QAYHfSKHr5XnddELLWq2+c2L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 004/190] KVM: debugfs: Return retval of simple_attr_open() if it fails
Date: Mon, 14 Nov 2022 13:43:48 +0100
Message-Id: <20221114124459.001406228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit 180418e2eb33be5c8d0b703c843e0ebc045aef80 ]

Although simple_attr_open() fails only with -ENOMEM with current code
base, it would be nicer to return retval of simple_attr_open() directly
in kvm_debugfs_open().

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Message-Id: <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c5259828efd..b76c775f61f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5404,6 +5404,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   int (*get)(void *, u64 *), int (*set)(void *, u64),
 			   const char *fmt)
 {
+	int ret;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
 					  inode->i_private;
 
@@ -5415,15 +5416,13 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get,
-		    kvm_stats_debugfs_mode(stat_data->desc) & 0222
-		    ? set : NULL,
-		    fmt)) {
+	ret = simple_attr_open(inode, file, get,
+			       kvm_stats_debugfs_mode(stat_data->desc) & 0222
+			       ? set : NULL, fmt);
+	if (ret)
 		kvm_put_kvm(stat_data->kvm);
-		return -ENOMEM;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int kvm_debugfs_release(struct inode *inode, struct file *file)
-- 
2.35.1



