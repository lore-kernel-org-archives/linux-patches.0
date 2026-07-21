Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EAD427A10;
	Tue, 21 Jul 2026 19:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661559; cv=none; b=ZOovpeA8p/TL0VaZHvu8Qn58mIkdJUlVk8l/2h8XB7ScQRPFUrKPsDfvtlpk8iKN6kXJGDU3mHbTsAcL4YtrI3kjTmqSqA5Fq2g5v5q4CPvbMM9l43wJtlF6civYp/Eq81/wqvs6VRGBbIWgThGGbohPcZ7jXL2hRGCTuBMRWVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661559; c=relaxed/simple;
	bh=7zjAbJn0wV0euVIvvjG8XgwcIe5ZWzGqf5amxenTsow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7h5FgFg+f3Tien1dXzqgd59Q+jRfoXSVqBI97S/K4+j4ni2zE6W5W3FZAjNZq4MzB9zVGYV2uyTL3vLo+Tp2pqjZZUWjWJylAQ55lBJDvLXq1ZVZ6Z1NB+vejjL/vSuBUj5MpikDsY3KWlYiZ2ZxqcBxVJgrztsLKdOCp5x6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pST71npo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pST71npo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E9D1F000E9;
	Tue, 21 Jul 2026 19:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661558;
	bh=tKg5vgQlWxBqbJA85Za5gpQFNDWzbvDwfqoaKhJBktI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pST71npofEvhu3z6V3uxIy01iUikEIaC//Ipx+J3FHe7sbNDJOTbiNXdm5RAsT8gV
	 xydr5e313svzvf2jEhSKcHL0uvJnxQNgrYn6MiMDzIMpZDHm2vl9HpvzmJs0yrXguU
	 gRhnttQHww7/zp1liahvTnVy7zQuxUHN3jp30fWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0112/1276] evm: terminate and bound the evm_xattrs read buffer
Date: Tue, 21 Jul 2026 17:09:15 +0200
Message-ID: <20260721152448.604872669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 11143a19f5b8dc8f414deab87571134f9f447313 ]

evm_read_xattrs() allocates size + 1 bytes, fills them from the list of
enabled xattrs, and then passes strlen(temp) to
simple_read_from_buffer(). When no configured xattrs are enabled, the
fill loop stores nothing and temp[0] remains uninitialized, so strlen()
reads beyond initialized memory.

Explicitly terminate the buffer after allocation, use snprintf() for
each formatted line, and pass the accumulated length, without risk of
truncation, to simple_read_from_buffer().

Fixes: fa516b66a1bf ("EVM: Allow runtime modification of the set of verified xattrs")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_secfs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
index 9b907c2fee60b6..07c6982e1faca8 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -128,8 +128,8 @@ static ssize_t evm_read_xattrs(struct file *filp, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	char *temp;
-	int offset = 0;
-	ssize_t rc, size = 0;
+	size_t offset = 0, size = 0;
+	ssize_t rc;
 	struct xattr_list *xattr;
 
 	if (*ppos != 0)
@@ -152,16 +152,22 @@ static ssize_t evm_read_xattrs(struct file *filp, char __user *buf,
 		return -ENOMEM;
 	}
 
+	temp[size] = '\0';
+
+	/*
+	 * No truncation possible: size is computed over the same enabled
+	 * xattrs under xattr_list_mutex, so offset never exceeds size.
+	 */
 	list_for_each_entry(xattr, &evm_config_xattrnames, list) {
 		if (!xattr->enabled)
 			continue;
 
-		sprintf(temp + offset, "%s\n", xattr->name);
-		offset += strlen(xattr->name) + 1;
+		offset += snprintf(temp + offset, size + 1 - offset, "%s\n",
+				   xattr->name);
 	}
 
 	mutex_unlock(&xattr_list_mutex);
-	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+	rc = simple_read_from_buffer(buf, count, ppos, temp, offset);
 
 	kfree(temp);
 
-- 
2.53.0



