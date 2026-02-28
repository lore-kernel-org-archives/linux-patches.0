Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9B536DA04;
	Sat, 28 Feb 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301437; cv=none; b=s3JB0BuJlip+g8djYnjO2kLYS3TaldTEuabu3CDh1i+bwl7J9aIbmYQAf3KmiuIBsftEhc4InauG2PMpPux7d5rMZA54hjry+SZjMyKOmZMpN+o/o2c8XpiAlHbORkhDZ4xCRKN4d2L/eiSt6BflpS6a80zJbAqhRrDdQN/IsuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301437; c=relaxed/simple;
	bh=hynepgpAQS62ggttobeYcs2o4UAKAYMz2B4KjnrM9KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyCJaXvi3bFFRglj3otC8HT13bebQEuEYsH4Q9hm1jUBiXhlNK4G1lXl0MGC6SdjwT+LKA/VgPh0vYvxp94i48fvbQvcNqqaAh24Rh7tSqubDlKlLgeS0rHoJ6LhNivLA7+KvNby0fVzExw7K7gUJm7M3xPVdB6sYJnODfQC2cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W87DTvHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W87DTvHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F2BC116D0;
	Sat, 28 Feb 2026 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301437;
	bh=hynepgpAQS62ggttobeYcs2o4UAKAYMz2B4KjnrM9KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W87DTvHXDCDmRExZzNcjNSrnpS26zuUjk41MJRO/udzyC63viDdelVdo1Fv3y73tu
	 WbFtU2/BX7mVWkWqKCUjSbaCB1gNo7/yqV1xiD0MICaugJiqXCiGpIsnRIeytO2mPR
	 SXr+mskO/wq/0EdgZC95tYL8IosqC28deN7EHPHA9oqUbETiK3Q2BB9pOBmxU/QA1E
	 ngmJNsJcd0rwuoqRpa4jZIb6kKM5JB3jCFMvt5ptXPSZKhsc0qlMcAABAK8fOg0MZ+
	 +49tUGCGxhhNqJ7nH+2jxnHZU63LHjGthSbnCdc4YYHJM6Yh09y7wOyv0FsHegEU+l
	 fCfTcn8jlglIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Alexander Graf <graf@amazon.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Betkov <bp@alien8.de>,
	guoweikang <guoweikang.kernel@gmail.com>,
	Henry Willard <henry.willard@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Bohac <jbohac@suse.cz>,
	Joel Granados <joel.granados@kernel.org>,
	Jonathan McDowell <noodles@fb.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Webb <paul.x.webb@oracle.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 625/752] of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
Date: Sat, 28 Feb 2026 12:45:36 -0500
Message-ID: <20260228174750.1542406-625-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 4d02233235ed0450de9c10fcdcf3484e3c9401ce ]

Refactor the OF/DT ima_get_kexec_buffer() to use a generic helper to
validate the address range.  No functional change intended.

Link: https://lkml.kernel.org/r/20251231061609.907170-3-harshit.m.mogalapalli@oracle.com
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@fb.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kexec.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 1ee2d31816aeb..c4cf3552c0183 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -128,7 +128,6 @@ int __init ima_get_kexec_buffer(void **addr, size_t *size)
 {
 	int ret, len;
 	unsigned long tmp_addr;
-	unsigned long start_pfn, end_pfn;
 	size_t tmp_size;
 	const void *prop;
 
@@ -144,17 +143,9 @@ int __init ima_get_kexec_buffer(void **addr, size_t *size)
 	if (!tmp_size)
 		return -ENOENT;
 
-	/*
-	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
-	 */
-	start_pfn = PHYS_PFN(tmp_addr);
-	end_pfn = PHYS_PFN(tmp_addr + tmp_size - 1);
-	if (!page_is_ram(start_pfn) || !page_is_ram(end_pfn)) {
-		pr_warn("IMA buffer at 0x%lx, size = 0x%zx beyond memory\n",
-			tmp_addr, tmp_size);
-		return -EINVAL;
-	}
+	ret = ima_validate_range(tmp_addr, tmp_size);
+	if (ret)
+		return ret;
 
 	*addr = __va(tmp_addr);
 	*size = tmp_size;
-- 
2.51.0

