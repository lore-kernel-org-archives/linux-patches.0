Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC64F3EA8;
	Thu, 17 Sep 2026 17:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666677; cv=none; b=MdmYP/VK0whTZvy/LP3ePDJyeopVJ6fRkS885GlAzmDH9AJnu4hvT32FO667GVcDYLygpMl1Yz0V5BQnmHYhKSFTZCY9hTWiEiwyGUWwu+oe/Fo8ZtkbsV/UpNor7fQDkGhIqJlgiUzyhQfCpT9rC/HsZT5vAhFkOt9zutjiveU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666677; c=relaxed/simple;
	bh=OBwqJuHeOo/wqNIq4KMT3gC9YB2UXvYiMenutHrh/bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFVo2AJq1u5BHN8yHH6qaYXAecQq26RzNLsTysWJ21X1jmvU8wIe0kZlnV4jcL0fgJfcH0HFtVi7fvd+Xb/VtcLQOFk3qmNl84WXrxviOJRp4h/WhEXuaXMVcoqd/9HwQqDH+YPv7yFMqHBfbAjCtTLrSQ1OSh+ofYS92bfh30k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHxxUHVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHxxUHVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7059D1F000FF;
	Thu, 17 Sep 2026 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666675;
	bh=n9enzVzB04lTrkRD+tqp70cyF22m/oWmB3HTJbgvBfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHxxUHVLSRU8BNQ8W8nmvszYMNWSOyCeinC2rLAZcwkqVQUwbFE2+SMdfuX7NW/aR
	 5XJWPz10CG6WQCHEEJlhKiVz8FYR0vac8xQ9KKyoFywqp9LrSM0VLZrg/WwftCCl3A
	 TpOlqQlz8eKaS2QczELa6HBPsz7fKKQapWSFzu5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1117/1250] xfs: dont modify file attributes or poke fsnotify for dry runs
Date: Thu, 17 Sep 2026 16:15:12 +0100
Message-ID: <20260917151622.504535356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 365fe37e10ea75840165f13322aa8481ea11dfef upstream.

I noticed that we shouldn't be removing file privileges when doing a dry
run of an exchange-range operation.  LOLLM also points out that a dry
run shouldn't poke fsnotify because we don't actually change the files.
Fix both by gating them on !DRY_RUN.

Cc: stable@vger.kernel.org # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_exchrange.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -504,6 +504,9 @@ xfs_exchange_range_finish(
 {
 	int			error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	error = file_remove_privs(fxr->file1);
 	if (error)
 		return error;
@@ -783,9 +786,12 @@ xfs_exchange_range(
 	if (ret)
 		return ret;
 
-	fsnotify_modify(fxr->file1);
-	if (fxr->file2 != fxr->file1)
-		fsnotify_modify(fxr->file2);
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		fsnotify_modify(fxr->file1);
+		if (fxr->file2 != fxr->file1)
+			fsnotify_modify(fxr->file2);
+	}
+
 	return 0;
 }
 


