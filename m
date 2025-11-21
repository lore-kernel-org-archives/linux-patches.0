Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043302765FF;
	Fri, 21 Nov 2025 13:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731624; cv=none; b=hOAWkUpmAN1VYktD2iPrwFi2qQhy9Icgdhoq3MzdmtulGh6uRMxAxIwJJT6CYjSxp+wFxbv11eXZ0GAc0sQbxvRYy/dNqgqXCSdfoBkHS0mQv5/G9xrn2nuzTkQUY8ueBaB74YO6xY4eu/Lf6LBrC3GBlUINzwTzea+L01Ru1g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731624; c=relaxed/simple;
	bh=IujCfdGpL4+kUIjAvmtL5Yhs6nh4KLMf9/V/+qgxURE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdYvI7M1wnw0G0+BDhSyBw8xbl89VzttAh0lJBnWPgoQZ7+bO6MJCAQ3ZO8jj12C3jYnVdlLjIoqbWqdkRi9lToYBhkZBmJFORy4QTGNQ0+4vAEIwY+K7JR+qzjXV6T/KwCY3wUtPg6Ln36Fle8/TXOaer1gq/vA83G7XILGA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6sHRniM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6sHRniM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A94C4CEF1;
	Fri, 21 Nov 2025 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731623;
	bh=IujCfdGpL4+kUIjAvmtL5Yhs6nh4KLMf9/V/+qgxURE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6sHRniMDKG3bwKJqDrb3uu6CmrzQvIFvdjd89MExAsW5AsRpdfGzbe3ARIYLcdcN
	 IH5ODUoIjHMfBrPpQ6sIiXP2s6npdB8ID5fXGobQHnj9KAKIVzJ+boXOWzhGxjB/9L
	 VweNlzgTOiEPj+mN7WjljnjYenC8WQTesqU+FbfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <jimmyxyz010315@gmail.com>,
	Jaehun Gou <p22gone@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/185] exfat: fix improper check of dentry.stream.valid_size
Date: Fri, 21 Nov 2025 14:10:52 +0100
Message-ID: <20251121130144.782488607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e9624eb61cbc9..f0fda34694044 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -635,10 +635,14 @@ static int exfat_find(struct inode *dir, struct qstr *qname,
 
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



