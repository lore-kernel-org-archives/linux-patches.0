Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F47538D81;
	Wed, 30 Sep 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790054; cv=none; b=rl7L9wrptS0J6/LsJmGsqoSSebV2m3vVnor0H4ZlV2qZbFTXKVWiHANv5gyQVuaLW6YPsIR8hlOBU5vSh8KJhWjiXgTFg52bDMb4zDqsagQdezIgK98+jKHew73oBtTA84KTMNk+xSZt3W4ww8djYaXVQlrCwR9wE40DNaJoLrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790054; c=relaxed/simple;
	bh=6ue63qNLuxye/N6QQsuKioPNitRMp1rHYTi00WqCFEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxjFon+CYAp9GCofJrKziXGvQFMF9lLQeodp/ZVr146IImHMyQ56awjHLeC62qaQBi6P2F6w5ZLuPATFiYY59TuWogeWLZfp0+CIDztohdUfXzBPBqctKhphAez5yVudRZLFLUHJOzzHQ1azbi3D7DMBkOCAv0zqPArRatdn/ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wazLCt+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wazLCt+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21D91F00898;
	Wed, 30 Sep 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790053;
	bh=KunNIYAzcdA9z9VMxGxpobGuW/9b2nMbT2HTNp50z3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wazLCt+owaV1Ur/F+Or33H+lQC2/Gcn1vAhLwI/yokdEBJoLLqZ+BQs0BIlkb0TBG
	 jqYoWBirW63rY6A3Bn4WidPq8cjgP3Ig4ZcXsjf0u089vVGX5gkoS2fxc2THpygh9e
	 E0loRT9Sji11MmY5I2kuVd/s1A1m2QA65dalOtPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 695/877] f2fs: fix to clear dirty flag on folio in error path
Date: Wed, 30 Sep 2026 17:26:46 +0200
Message-ID: <20260930152429.676035205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5b86eab84ac8e9289b5afc52ef88ab18ba5bacab ]

If node block is corrupted due to chksum mismatch or inconsistent
footer info, it needs to drop clear flag of node folio, in order
to persist inconsistent node data to storage.

Cc: stable@kernel.org
Fixes: b42b179bda9f ("f2fs: fix to do checksum even if inode page is uptodate")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1528,7 +1528,7 @@ page_hit:
 	f2fs_handle_error(sbi, ERROR_INCONSISTENT_FOOTER);
 	err = -EFSCORRUPTED;
 out_err:
-	folio_clear_uptodate(folio);
+	clear_node_folio_dirty(folio);
 out_put_err:
 	/* ENOENT comes from read_node_page which is not an error. */
 	if (err != -ENOENT)


