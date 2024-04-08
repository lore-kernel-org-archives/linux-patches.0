Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6101176413;
	Mon,  8 Apr 2024 13:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582915; cv=none; b=HM493hzOAIjEKrh3PRBE8ylIC9S2SsRR2jw8Oxuf7NP5stmLDbCWwXJyuGkVrJr60oqP1QMGApjtHzVap6YTJxaOPaC0KW6v/0I9lJi7a6pFyiVvI2sWJLNIzDevqG8xaT0HjjnpBFsEpWsqLkRXVDbB2kEnTi60VTpaB6+xf4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582915; c=relaxed/simple;
	bh=nrQ+yQYOPK5xGtv9Zj4pW6o+3zSV7mrFw6CihPEZOb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJU43/p5Dha20zweRIhkTGikjyd0nFwsVG/oQIfl0gVoHPG1TRe1GaMdErBCfTfSo1jWWmS6OFstYyp7RuWXJyjvPiRcILeq0AGWYx+qoGTR2/cwUWVMbGAHXnnnhqO+F42bwHlzDnDNa242cP6ttVdbcPBgj4z7mimB7QnW1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ac27UoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ac27UoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED7AC433C7;
	Mon,  8 Apr 2024 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582915;
	bh=nrQ+yQYOPK5xGtv9Zj4pW6o+3zSV7mrFw6CihPEZOb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ac27UoUbc865+dmklqGGdy3yHvO9yuTuQdvGUUw1knQ4BAInrXymg/H7g61uB38K
	 PBk0T1xaIu080jU9lGztJWk9OL1jgougGmtIF6e/c02nMPP/tqL7uE3/ekPsnPzZok
	 U/FxMNAOjP6SZmwN+TvNTgpxeIdX3Bu3ut+q2ayY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 187/690] fanotify: Wrap object_fh inline space in a creator macro
Date: Mon,  8 Apr 2024 14:50:53 +0200
Message-ID: <20240408125406.326589680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 2c5069433a3adc01ff9c5673567961bb7f138074 ]

fanotify_error_event would duplicate this sequence of declarations that
already exist elsewhere with a slight different size.  Create a helper
macro to avoid code duplication.

Link: https://lore.kernel.org/r/20211025192746.66445-23-krisman@collabora.com
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fanotify/fanotify.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 2b032b79d5b06..3510d06654ed0 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -171,12 +171,18 @@ static inline void fanotify_init_event(struct fanotify_event *event,
 	event->pid = NULL;
 }
 
+#define FANOTIFY_INLINE_FH(name, size)					\
+struct {								\
+	struct fanotify_fh (name);					\
+	/* Space for object_fh.buf[] - access with fanotify_fh_buf() */	\
+	unsigned char _inline_fh_buf[(size)];				\
+}
+
 struct fanotify_fid_event {
 	struct fanotify_event fae;
 	__kernel_fsid_t fsid;
-	struct fanotify_fh object_fh;
-	/* Reserve space in object_fh.buf[] - access with fanotify_fh_buf() */
-	unsigned char _inline_fh_buf[FANOTIFY_INLINE_FH_LEN];
+
+	FANOTIFY_INLINE_FH(object_fh, FANOTIFY_INLINE_FH_LEN);
 };
 
 static inline struct fanotify_fid_event *
-- 
2.43.0



