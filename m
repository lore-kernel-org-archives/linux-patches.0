Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B846AA89;
	Tue, 21 Jul 2026 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648457; cv=none; b=LYTibSHBXOG5e4DVKtoUDszZN6mcpIsoUw94kFC1MdSvHfnSP1d/uPxdKV36GnybmV+LUzpVvUmG81B0rNJgzKQkPPFNxfUQckzLgbihX9wEyD+Jo7n97uVRg2c1u8iW+XV57fz3VQtzBpTHEwAThqh7BbZpJ9neWbBv65LY/0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648457; c=relaxed/simple;
	bh=r4yzFFqdZr9fnSxV7QVhkbE2CJ8D+WRXdZTeRaKTRno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW1CNrx1S/nJvSvIujfK5zvbT4G392AnkkYnvUjOoHMkzNfuleFk1BVjIplSc4yDOdpQwJolgrpmn5PujIuCpmdNRpYHSUNnMHIKxJV3EJ7JUfqlBSSJicl/pvlluFgmRZAohBs46x3kroHSw9JGaTN5R1P5Kc2sO0Aosawtn/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPICZVh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPICZVh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7D21F00A3A;
	Tue, 21 Jul 2026 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648455;
	bh=RShWGaLgPZDOEridtIkyv/kR6fnj+dKQVRWydjY5kA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPICZVh9Z77njbxXK5U34qXKU2bjPcK/iZ2/eLHPI/egICVwhKOAJEu3lcBBy0Zj9
	 dnB7p0gjoJEKNgvZkGGC8i5aQ2F2PWYji/dPy/Ex4WCxqZJ4zbJ+K7Ber+cBKFScXo
	 TgYsAKixLMXOY8O/dmHvSO4XMExjeD6rDVyf816w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0205/2077] evm: terminate and bound the evm_xattrs read buffer
Date: Tue, 21 Jul 2026 16:57:58 +0200
Message-ID: <20260721152557.516327383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index acd840461902f8..4baf5e23bc97e9 100644
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



