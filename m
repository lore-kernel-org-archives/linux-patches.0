Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FE434104B;
	Sat, 30 May 2026 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160904; cv=none; b=e3EZIYn8Lr6AcSqwcYUJtTKo3LkRbiIzVMi2k8w2XjZbHPm0tXFP5XwEeibi6JUhc/QtmIDeFtuuZDyBIL/Q+cXrRQc/CAEa2hSqkhL2rsyghr6PbhM05RDF2N/JjkYVflKWX8kbsx/klQhezkwklRtjIuEoJaVv2cWDGyJF1ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160904; c=relaxed/simple;
	bh=elrnplen56lBf8XlMhbeI7lhkNgdf1bbhWOZfwDF2zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBvRD56jEbGSB5snlQvNMJjFQKfGW0P1Gz4oki4KQc+zXj7vO0VahCEn7RUnmOjxffDAHuSHt8+g/qw2XrB33qslejBeST7tzMfFgaUJccaRrkSBWaA2oXClJ6i273+plejY2zKQLT/yB1Hn8yVnc2PsWswXArazEHvtQqcFqPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM1q08xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM1q08xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5438A1F00893;
	Sat, 30 May 2026 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160902;
	bh=n7w0kJ8haQn5MLVJM3O8N5pJ+UxUqPdOroWIsH/P5kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MM1q08xoyABoDmGkMMpO9Sc9swvCHldQjPNQ/+qI3HR7JAhp3Lzv2hwXtdl5gQvEx
	 PlRR77h7nc1ByD1gD4Ztgwev2b5ijBGV/HG9fDr9CTiJ9gbMKTN+9tWo+I95HuAf1f
	 wTtmb4O9BRmLq3r7g0EMOLMMbJVEFdD5mD6XYrwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/969] debugfs: check for NULL pointer in debugfs_create_str()
Date: Sat, 30 May 2026 17:59:23 +0200
Message-ID: <20260530160312.391859831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 31de83980d3764d784f79ff1bc93c42b324f4013 ]

Passing a NULL pointer to debugfs_create_str() leads to a NULL pointer
dereference when the debugfs file is read. Following upstream
discussions, forbid the creation of debugfs string files with NULL
pointers. Add a WARN_ON() to expose offending callers and return early.

Fixes: 9af0440ec86e ("debugfs: Implement debugfs_create_str()")
Reported-by: yangshiguang <yangshiguang@xiaomi.com>
Closes: https://lore.kernel.org/lkml/2025122221-gag-malt-75ba@gregkh/
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260323085930.88894-2-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index b38304b444764..cda3ba59b10f6 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -942,7 +942,7 @@ static const struct file_operations fops_str_wo = {
  *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the debugfs filesystem.
  * @value: a pointer to the variable that the file should read to and write
- *         from.
+ *         from. This pointer and the string it points to must not be %NULL.
  *
  * This function creates a file in debugfs with the given name that
  * contains the value of the variable @value.  If the @mode variable is so
@@ -960,6 +960,9 @@ static const struct file_operations fops_str_wo = {
 void debugfs_create_str(const char *name, umode_t mode,
 			struct dentry *parent, char **value)
 {
+	if (WARN_ON(!value || !*value))
+		return;
+
 	debugfs_create_mode_unsafe(name, mode, parent, value, &fops_str,
 				   &fops_str_ro, &fops_str_wo);
 }
-- 
2.53.0



