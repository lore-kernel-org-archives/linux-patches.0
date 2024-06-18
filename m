Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6944213A245;
	Tue, 18 Jun 2024 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714811; cv=none; b=N3lR3zkBRUaBW8Erh5r3jOzb3OvFknU0FDd9i3lApmlD8kLhQ7hTN3tgxrQQ4MPswfDSrWyF//2jfdu4XuZOkUoFQhjZt13GhwwTwa1jrfimPrCdPV4lbJdmzTS9ZeBXneFTpALeCrTDBMuZ6VOSq30JLjpFon5ROsZItFRHr3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714811; c=relaxed/simple;
	bh=IMG82BOGQVJ/iPS+Ht/ibq3Q4bbbLNuwA6UFFPIvOcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgeQdj9sI7UsfC0gzZexCGfFAJb0W7EeZ+IfmA3ybT+a5BN+9uyjPeNeStemwawybgJVcbDboQPGQGZn4gHlCxUf3a4PMXkVWBw8kSqKtrt1ui30TZO3NV5JQiPauMSvZGYqdg0OjD3cy0Y0YB+NebSbWadYaVZqADp9mxjjZsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odKcqEbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odKcqEbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E486BC3277B;
	Tue, 18 Jun 2024 12:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714811;
	bh=IMG82BOGQVJ/iPS+Ht/ibq3Q4bbbLNuwA6UFFPIvOcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odKcqEbcXqec7wWZvLlbeYrMFhJOwtic60qNnCBsdzySgb2MvH+Evsn4JmAxtNmDQ
	 ncy0A5Bc4skKqvHObeBGv+pRbaqB8DBiahhlXNXuTVlJFqrqdpjq19pBWf1d6SRqsz
	 zBmyJnd98NnE0/WyhM8GFDdzrWxZyXlYbZU+Y980=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/770] nfsd: minor nfsd4_change_attribute cleanup
Date: Tue, 18 Jun 2024 14:29:09 +0200
Message-ID: <20240618123410.978184939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 4b03d99794eeed27650597a886247c6427ce1055 ]

Minor cleanup, no change in behavior.

Also pull out a common helper that'll be useful elsewhere.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.h          | 13 +++++--------
 include/linux/iversion.h | 13 +++++++++++++
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 39d764b129fa3..45bd776290d52 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -259,19 +259,16 @@ fh_clear_wcc(struct svc_fh *fhp)
 static inline u64 nfsd4_change_attribute(struct kstat *stat,
 					 struct inode *inode)
 {
-	u64 chattr;
-
 	if (IS_I_VERSION(inode)) {
+		u64 chattr;
+
 		chattr =  stat->ctime.tv_sec;
 		chattr <<= 30;
 		chattr += stat->ctime.tv_nsec;
 		chattr += inode_query_iversion(inode);
-	} else {
-		chattr = stat->ctime.tv_sec;
-		chattr <<= 32;
-		chattr += stat->ctime.tv_nsec;
-	}
-	return chattr;
+		return chattr;
+	} else
+		return time_to_chattr(&stat->ctime);
 }
 
 extern void fill_pre_wcc(struct svc_fh *fhp);
diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index 2917ef990d435..3bfebde5a1a6d 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -328,6 +328,19 @@ inode_query_iversion(struct inode *inode)
 	return cur >> I_VERSION_QUERIED_SHIFT;
 }
 
+/*
+ * For filesystems without any sort of change attribute, the best we can
+ * do is fake one up from the ctime:
+ */
+static inline u64 time_to_chattr(struct timespec64 *t)
+{
+	u64 chattr = t->tv_sec;
+
+	chattr <<= 32;
+	chattr += t->tv_nsec;
+	return chattr;
+}
+
 /**
  * inode_eq_iversion_raw - check whether the raw i_version counter has changed
  * @inode: inode to check
-- 
2.43.0



