Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8C2C2357;
	Tue, 11 Nov 2025 01:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824065; cv=none; b=oXuCvPSrefHOVMkaOcbFz3dQwJtOr1PVfmFEPNwbYQkPPIDVL43OIhLiEij+bIAy7mdnCcz/ll9K/Z5suGDUePTQ5tNtQxsj0GbmGyHEkkvmnkTm4uKkAAA6vlmjYeZMc46+Wdkc2jsNNy6dSX7gpGnOqUQJ4V8TWgLFvwbLLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824065; c=relaxed/simple;
	bh=mE1088DEnP18tpWsHccwzIhEmbZw77N/Zr8OwHSS3qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKklc/3Ncqhn4a2gt8z90Rl7Xwd8vZ7j7/BkX+226hObLWyDVhaWGA8Gwgp2BoCkPCJtLUZrPOX0ZwQtvwGLYfXel0cik+CnDogGCzofG5trEQIx4mcFFEbhV45LbvICq293Kh0m/e/13AFDiZwhTkt+NL+gNAQHZ0dq+9TGFSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsQjW2CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsQjW2CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C1EC4CEFB;
	Tue, 11 Nov 2025 01:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824064;
	bh=mE1088DEnP18tpWsHccwzIhEmbZw77N/Zr8OwHSS3qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsQjW2CYMRu5SbdmgKUu2Huk/YD2R3Hqu1T3VcJ+iQShgtMoUpyj/VHyazt0qGL3t
	 yRM6KTPIJIJA1+NcUJmP+s2MAdahlkCrV0xbSZYbsgCGECF0FfWleUF5ki980QzmF2
	 2jIuVl8KetiQBb5zutk2U6V37wMT0pLVBTQlarlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/565] allow finish_no_open(file, ERR_PTR(-E...))
Date: Tue, 11 Nov 2025 09:43:56 +0900
Message-ID: <20251111004535.420630880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fe91e078b60d1beabf5cef4a37c848457a6d2dfb ]

... allowing any ->lookup() return value to be passed to it.

Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 5da4df2f9b18a..de1ea1b2f6ef5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1052,18 +1052,20 @@ EXPORT_SYMBOL(finish_open);
  * finish_no_open - finish ->atomic_open() without opening the file
  *
  * @file: file pointer
- * @dentry: dentry or NULL (as returned from ->lookup())
+ * @dentry: dentry, ERR_PTR(-E...) or NULL (as returned from ->lookup())
  *
- * This can be used to set the result of a successful lookup in ->atomic_open().
+ * This can be used to set the result of a lookup in ->atomic_open().
  *
  * NB: unlike finish_open() this function does consume the dentry reference and
  * the caller need not dput() it.
  *
- * Returns "0" which must be the return value of ->atomic_open() after having
- * called this function.
+ * Returns 0 or -E..., which must be the return value of ->atomic_open() after
+ * having called this function.
  */
 int finish_no_open(struct file *file, struct dentry *dentry)
 {
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
 	file->f_path.dentry = dentry;
 	return 0;
 }
-- 
2.51.0



