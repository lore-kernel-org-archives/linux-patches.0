Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBEA326D44;
	Tue, 21 Jul 2026 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655867; cv=none; b=s6v3lKfH/eIznI2wdeeHdRYKLQXr5jxlMMaCfUThheq9ycs1zQSyXmaTsX98ZYZ4Rx71Iey/j9pDgEK+NtubBvXOatp6xer8SMZjcZhRtNrSPH2s73KPa5C/Y1bL8G3V+Fc/YNr/5xJvW/nllJDgGo7SLTvTPyFZPkBMHvPPQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655867; c=relaxed/simple;
	bh=GhBPPHSB3he4MdJjnEUcecBjnjF6kMWjm2Zz5ruyh8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgwxfiiGTj7yAJi5p1zQxi3AlQc8GnyM2dZ/ed8ekk73pswHKhAfEzM/gsYqe8u8wUgy+8KglvQ9Su2Ti6bdOR6n5fOzu7I+P/l9y9mN9GhsTAdEbD35On7VZUFo1Pn3+ByOalznGbjeSMrzvudrTI6zU01yvzKbpcymtVtqu0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVZV0VxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVZV0VxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23A51F000E9;
	Tue, 21 Jul 2026 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655866;
	bh=wjywbBvDHupqHfK5RGOfRuCg2AcN7TZU5nfBLupbPz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVZV0VxYNVGiMy3dqC0U87MWAtr8WI2mZ8hHMl8b+DHu+rCH09a5PLnDTPwxOXSlK
	 Hc/0yHp5lGFAVbusePTvrtnTh0CPVKE0UUOD4u/EiCunfITgXU5CtCUp/DxxOzH82M
	 Llh2SX3bjjbU4M/Tw7XhR3IHmfpJfofrI6BXjpEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0144/1611] evm: terminate and bound the evm_xattrs read buffer
Date: Tue, 21 Jul 2026 17:04:20 +0200
Message-ID: <20260721152518.116296071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b0d2aad2785071..0611a753106827 100644
--- a/security/integrity/evm/evm_secfs.c
+++ b/security/integrity/evm/evm_secfs.c
@@ -127,8 +127,8 @@ static ssize_t evm_read_xattrs(struct file *filp, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
 	char *temp;
-	int offset = 0;
-	ssize_t rc, size = 0;
+	size_t offset = 0, size = 0;
+	ssize_t rc;
 	struct xattr_list *xattr;
 
 	if (*ppos != 0)
@@ -151,16 +151,22 @@ static ssize_t evm_read_xattrs(struct file *filp, char __user *buf,
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



