Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E749A44AB6E;
	Tue, 21 Jul 2026 21:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668780; cv=none; b=sVnJFrRnH/G8S2grU1CZa5duwo9LFW3XbAjAijeff/+Sp9K/PsxoDj9PXi3WlaFazcGKg3F+drNMp4BMw01LXTqOKTccUMn7b1/jXzRE5T6EcPZBTdRaBIzu35YQkMvBrh556kwwpjd20Gxp2dR4p6O9qE02VTfGZgkVhhHQvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668780; c=relaxed/simple;
	bh=iGqcc3pCmi1TvxlIH7u8iQ2JboD6pIbu0G8I+Fp6sx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InLsReCVZmYaRArocBPSuBWXP8E/0XaZtTvxKBmUR+9Z6myyleY9X+mJqedXpb+ptkVim3eyR0FOPiihHE4YZri36Yc63elA+lBxnLSinWMcBQjcq6LB7lMlND48VYW0CKszjnwjk/CZVXKB46xr6z4Tgt8FVIwiVQ2CUN75B94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEJl6w81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEJl6w81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A221F000E9;
	Tue, 21 Jul 2026 21:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668778;
	bh=BZlKtqU/sRiR5dGaVEV4IkfH/kdPXJfsksvu++EzH8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEJl6w81sbEbY252Uo54lgektLm4Q+OXj+I7VyuefQhGbVQXhCHh7Qtjc88pljaUr
	 U8XeRjHVN4mIT5rgM0a6x3DRoxXqDjTuM6jIU7dQDjMwt8W4uebsRrBKBbdfLUlmkB
	 oSK+gVmlL4OHYntmRjw9TZCfMCjkeTVbdXJblKcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0305/1067] evm: terminate and bound the evm_xattrs read buffer
Date: Tue, 21 Jul 2026 17:15:06 +0200
Message-ID: <20260721152431.418709583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a9db7dfca7efe..93a0d8d554a87e 100644
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



