Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED523183B;
	Fri, 21 Nov 2025 13:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730953; cv=none; b=ilyxnLaagpgeqxewffFAcY4fI/ncKUpExKxZ2OQZovSJLCkipX4jA84wGYHQX1DMAHyAxxZCXSeqZGXk4VuK/1LJbaFz3COrhp59/6fCd73ZBJ9U1N040DKQbHETNecFplzrlmfEcvb2yXVQ/ug+ohHMKwZzG1TDX+TywRt12TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730953; c=relaxed/simple;
	bh=CJg93SGIaExKqOY30e8/Lva8bMCZOuC3hR/Ko5yIBtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6Om8bP2ryBIFfUSqg9+DtsdUSCa6b181b8F0oObi9aUnZWD6+My9B5ctCQzaS237Jq1hqjSg4Fnj9Lj5SJ+cHxhnqCJjqo4npbJ7/3TdnRtaWdWSpEg9vlIg2pBotbHI0bBzEr413N2Ue5i4Wpat5YdzQXMIoIPi4neO+bEHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjbP8Fap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjbP8Fap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108D5C4CEF1;
	Fri, 21 Nov 2025 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730953;
	bh=CJg93SGIaExKqOY30e8/Lva8bMCZOuC3hR/Ko5yIBtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjbP8FapnZPVE3OYYCoqawZirz99mjTjoE+6lUXwzGwjRxEkeCrsgXlZzsRLGViGF
	 qhMF2Ii1VNjHP0zFb/cEl6pifhzpyW9HifAtQdXlxgA+OCOISAFClSPYszwFovZ2MH
	 V3WSKCojq3pHpZGTWpsL9Jbf7I5rAYF6s3191MQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <jimmyxyz010315@gmail.com>,
	Jaehun Gou <p22gone@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 038/247] exfat: fix improper check of dentry.stream.valid_size
Date: Fri, 21 Nov 2025 14:09:45 +0100
Message-ID: <20251121130155.971633588@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehun Gou <p22gone@gmail.com>

[ Upstream commit 82ebecdc74ff555daf70b811d854b1f32a296bea ]

We found an infinite loop bug in the exFAT file system that can lead to a
Denial-of-Service (DoS) condition. When a dentry in an exFAT filesystem is
malformed, the following system calls — SYS_openat, SYS_ftruncate, and
SYS_pwrite64 — can cause the kernel to hang.

Root cause analysis shows that the size validation code in exfat_find()
does not check whether dentry.stream.valid_size is negative. As a result,
the system calls mentioned above can succeed and eventually trigger the DoS
issue.

This patch adds a check for negative dentry.stream.valid_size to prevent
this vulnerability.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <jimmyxyz010315@gmail.com>
Signed-off-by: Jihoon Kwon <jimmyxyz010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index f5f1c4e8a29fd..d8964d7368142 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -642,10 +642,14 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 
 	info->type = exfat_get_entry_type(ep);
 	info->attr = le16_to_cpu(ep->dentry.file.attr);
-	info->size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
+	if (info->valid_size < 0) {
+		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
+		return -EIO;
+	}
+
 	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
 		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
 		return -EIO;
-- 
2.51.0



