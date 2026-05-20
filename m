Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FC13DA5B6;
	Wed, 20 May 2026 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301764; cv=none; b=GvvohVcn4Ep1jKA+nWsNG2fRlAzwUfdV9ziSVYykL5ufJBqG1KSMcbtLOaRM2a+1kju7I/lalIpCfPm4tlB59hBsQXHym6DcC4njUlFOgdyWy7hFx7Jh0GutxXG/HDq7qvdkio1xpTY2x7S7bL/SzGDwOivMo43o2G9Muya05HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301764; c=relaxed/simple;
	bh=87TjpU7BrJR3RcGepY+6iT/obqBIcR80LVkhLEu8Fvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr2B81WQl0ff513H8uWoOPekp1eH2QpSILytVn7S8NPQgXzdfU+cJreI2I++XWSPZsvPOdJ0W9kyI77SaacJy0vr2H6GCFQ3IOXS6pXMcOW7gZCACRv7Cffg+LA49zuvCFG+ayaBL+kWNm/zNXklRNMZdTwzUEBhLws5bOfh6r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSvjb0Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSvjb0Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00241F00898;
	Wed, 20 May 2026 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301763;
	bh=RbgNczw7uAgWd8VdAZX8Ch54snfUX7f+YwroxEXclW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSvjb0Hik3cqId12+IRcbKa7d1yPRZDrAcetRO7xUX6efdHCwT23fFTFkArUmsvfE
	 G35ZG/oKAlXhXG28m6i8ty5WNh3zrK0qD/XCScqZxTJE1JMdwhCpNaOGfuAQDsnJy+
	 Uo9sBNkXK+4ClLhOyTbHrSUvn5bOVWX8dKAhAJf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/508] debugfs: check for NULL pointer in debugfs_create_str()
Date: Wed, 20 May 2026 18:17:15 +0200
Message-ID: <20260520162058.850609864@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e40229c47fe58..3089d7146f366 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -987,7 +987,7 @@ static const struct file_operations fops_str_wo = {
  *          directory dentry if set.  If this parameter is %NULL, then the
  *          file will be created in the root of the debugfs filesystem.
  * @value: a pointer to the variable that the file should read to and write
- *         from.
+ *         from. This pointer and the string it points to must not be %NULL.
  *
  * This function creates a file in debugfs with the given name that
  * contains the value of the variable @value.  If the @mode variable is so
@@ -996,6 +996,9 @@ static const struct file_operations fops_str_wo = {
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



