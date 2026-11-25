Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624610;
	b=dypMHwLaEH09PlKlE+JCgSfYbo9uyWYYZuaGvV+7nIZ2NNZ1x7p7sfBBZgRv0WmuGcVN
	 6EY82N+DNi0ZHCPP739Mi2bx/qip6xHfolS5a2E1mR3VPG1ex7Ef1vSjBxd6PMM7vb1Kk
	 IfXXaz6d1W6tGcpScsJixGVWQUmLzikf/DJmJJRTAnWCLmsAT7X+QF0cQbZEK6F8bSxGq
	 Ss9na9f8MiL/p4K8wyRmXpkwYMgsMS41ymiHviyNjlq4JQzsmJ+Bjvlv7KjIUP7fTl1Tj
	 cm5VALGItlcyFDSnnw/bo4LpnoGsCLt1V8sXmApkU9BlFY2yw58L2NboiEXBAjI4wZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrkPjD+nCKi3xcSlf1k17PKBXO0KKCTmE9gjP/ILIw4=;
	b=gnOeS8EGs1aDpFLeW7iBZ6D+tBOg/HOzGBSg54dQ3noHZe0ycfYPT4pgVp7NfcMHpBL6
	 WRGtBeyZpdLEu1Ij4iAaI53QpXsdmF+tY5Y4cE51hERLv/tjh+YCeT6bRBSlCsKh8Q3/R
	 o9CoLlOMhz93sZ9NRqD9A/6w4FfCgeQW5NlWqyvYLlCryl2HxO76u1Pcg875alEP4021P
	 XQ09q1yIpesbu/TH4EgxOgpOFOeSXZtiBZL14pKHbVn5OYOLKwF3nJOQfgBOQBsS7BGsa
	 M2LI3/xqbAe2oeGaC4IXYhYiZxbRZXu/ifz/yfGmY3C77pKwpVTYgoDqR2/idpU7aag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="INaivt/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C07606A33F;
	Wed, 25 Nov 2026 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INaivt/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56301F000C6;
	Wed, 25 Nov 2026 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624610;
	bh=hrkPjD+nCKi3xcSlf1k17PKBXO0KKCTmE9gjP/ILIw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INaivt/iJeY2cMCENKtY4pLUKvNK0enR/Q4/jHPL/ZsqN7z5S/ZfjTEFl02zGkSbx
	 cwhWZyCCErYuSjV3n1UanfJbEm882+J077y0+SYQietBq+RjJIQ4c8bJGDnzGC1krj
	 1pLo1LR5iV8nLiDqcZXS+y3O9fDTj6rBL/gak17I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/816] fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()
Date: Wed, 25 Nov 2026 15:29:57 +0100
Message-ID: <20261125143854.972681821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 7a5783cfac71b3c12e7fb1c2894dd4538d57d513 ]

In default_llseek(), the range checks for SEEK_DATA and SEEK_HOLE compare
the signed loff_t offset directly against inode->i_size:

	if (offset >= inode->i_size) {
		retval = -ENXIO;
		goto out;
	}

When a negative offset is supplied to SEEK_HOLE (e.g. lseek(fd, -10,
SEEK_HOLE) on a sysctl file in /proc/sys), the signed comparison evaluates
to false and execution proceeds to:

	offset = inode->i_size;

This overwrites the negative offset with a non-negative value before the
final `if (offset >= 0 || unsigned_offsets(file))` check, causing
default_llseek() to update file->f_pos and return inode->i_size instead of
failing with -ENXIO. Similarly, for SEEK_DATA on a file with
FOP_UNSIGNED_OFFSET, a negative offset bypasses the range check and
succeeds via unsigned_offsets(file).

Read the inode size once via i_size_read(inode) after acquiring the inode
lock and compare (unsigned long long)offset >= eof for both SEEK_DATA and
SEEK_HOLE, matching must_set_pos().

Fixes: 982d816581ee ("fs: add SEEK_HOLE and SEEK_DATA flags")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Link: https://patch.msgid.link/20261101060049.81441-2-sidchintamaneni@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 87246e7c2ee83..1e7505662f8f2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -326,13 +326,15 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file_inode(file);
 	loff_t retval;
+	loff_t eof;
 
 	retval = inode_lock_killable(inode);
 	if (retval)
 		return retval;
+	eof = i_size_read(inode);
 	switch (whence) {
 		case SEEK_END:
-			offset += i_size_read(inode);
+			offset += eof;
 			break;
 		case SEEK_CUR:
 			if (offset == 0) {
@@ -347,7 +349,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * long as offset isn't at the end of the file then the
 			 * offset is data.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
@@ -358,11 +360,11 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 			 * as long as offset isn't i_size or larger, return
 			 * i_size.
 			 */
-			if (offset >= inode->i_size) {
+			if ((unsigned long long)offset >= eof) {
 				retval = -ENXIO;
 				goto out;
 			}
-			offset = inode->i_size;
+			offset = eof;
 			break;
 	}
 	retval = -EINVAL;
-- 
2.53.0



