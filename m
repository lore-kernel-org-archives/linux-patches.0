Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184A9E573
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EFBC433D2;
	Mon, 15 May 2023 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168834;
	bh=CcNRIHoQon4UbB5J5qZeKiIBNv/kTAdr7r1q7AaNHDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YT0k6a06o6HwLYyAJKvm7S4Vk+PdiPHveJjdpSbUgej2lMh2ftXh0N+zzug7Lp/Vj
	 mZd3bTq4ZbJiDywN+xE5kI7ofJ903tAOIGyPmvnuQ72a9udJLoAs1E39pIbROZAPSY
	 r2tmV98IB7orSdwpuKi+dWo91RQdAr5nt+ks55og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Borislav Petkov <bp@suse.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	arozansk@redhat.com,
	linux-edac <linux-edac@vger.kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4.19 028/191] EDAC, skx: Move debugfs node under EDACs hierarchy
Date: Mon, 15 May 2023 18:24:25 +0200
Message-Id: <20230515161708.196893993@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 85b9c8bfee67ed151c44861c71adc816fc1b46a9 ]

The debugfs node is /sys/kernel/debug/skx_edac_test. Rename it and move
under EDAC debugfs root directory. Remove the unused 'skx_fake_addr' and
remove the 'skx_test' on error.

Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: arozansk@redhat.com
CC: linux-edac <linux-edac@vger.kernel.org>
Link: http://lkml.kernel.org/r/1542353684-13496-1-git-send-email-qiuxu.zhuo@intel.com
Stable-dep-of: 71b1e3ba3fed ("EDAC/skx: Fix overflows on the DRAM row address mapping arrays")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_edac.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
index dd209e0dd9abb..b97803580d70f 100644
--- a/drivers/edac/skx_edac.c
+++ b/drivers/edac/skx_edac.c
@@ -896,12 +896,11 @@ static bool skx_decode(struct decoded_addr *res)
 
 #ifdef CONFIG_EDAC_DEBUG
 /*
- * Debug feature. Make /sys/kernel/debug/skx_edac_test/addr.
- * Write an address to this file to exercise the address decode
- * logic in this driver.
+ * Debug feature.
+ * Exercise the address decode logic by writing an address to
+ * /sys/kernel/debug/edac/skx_test/addr.
  */
 static struct dentry *skx_test;
-static u64 skx_fake_addr;
 
 static int debugfs_u64_set(void *data, u64 val)
 {
@@ -912,19 +911,19 @@ static int debugfs_u64_set(void *data, u64 val)
 
 	return 0;
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(fops_u64_wo, NULL, debugfs_u64_set, "%llu\n");
 
-static struct dentry *mydebugfs_create(const char *name, umode_t mode,
-				       struct dentry *parent, u64 *value)
-{
-	return debugfs_create_file(name, mode, parent, value, &fops_u64_wo);
-}
-
 static void setup_skx_debug(void)
 {
-	skx_test = debugfs_create_dir("skx_edac_test", NULL);
-	mydebugfs_create("addr", S_IWUSR, skx_test, &skx_fake_addr);
+	skx_test = edac_debugfs_create_dir("skx_test");
+	if (!skx_test)
+		return;
+
+	if (!edac_debugfs_create_file("addr", 0200, skx_test,
+				      NULL, &fops_u64_wo)) {
+		debugfs_remove(skx_test);
+		skx_test = NULL;
+	}
 }
 
 static void teardown_skx_debug(void)
-- 
2.39.2



