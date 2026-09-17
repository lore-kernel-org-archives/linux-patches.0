Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018E4E4C56;
	Thu, 17 Sep 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666862; cv=none; b=CMzBNClId/P3bYJ679h8SD9GkDt55sgG/syLIRoETSDmCx15rU5MYV6i+Di2EJsedNGm9h6wlE4cMpptdMQuOZiJ97hmncHuf0veOa3rCFtXpKDzgtOzFKieciJooLKOznG776MOaQSZUyNlHMqBA/wTPDK5PR/KNOW+QDeNdi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666862; c=relaxed/simple;
	bh=atFPdDXPfPNirVexfO/w5A2RbyycGsN3y3fXew8xnzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWomPIugg4QIsHRavRt/KfBI4N/r38gfG8TtBpir88IfObKs247Xnwu+pmSmMvKoBH+X/f3u0jPnlB08bMX2QbF8ZC0k+dXiDXkBwDrcLI9b/9+Di621QfHrXjGB/DoKgkvJOwfrVnbom6TUggQpBKh5PQaEx63CnycyvFvZnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1znwnC7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1znwnC7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A351F000FF;
	Thu, 17 Sep 2026 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666861;
	bh=dc6UwMxbaVDGWCEpZFuSkPQTrsW5Fd9FOgw6GiD+fMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1znwnC7zZcBoMxeuJtUUDAK69rU46K2K3RBXrtGkjblv2dD6EmCCZ2Rp6qtCXJy7d
	 A6jzofPj6OkRuOMHxUTp74mTCy8viRwGUPzQeLF39a1bUjMgO+o0G4Jy9nyE3FocnL
	 cCKf591xMvwNx0UPprjmlt4H6c4BcXLMBGkrO3MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1111/1250] xfs: fix name string recording in slowpath pptr tracepoints
Date: Thu, 17 Sep 2026 16:15:06 +0100
Message-ID: <20260917151622.326303538@linuxfoundation.org>
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

commit 72d0a3e4405c1353869bfbbc67c7b8a29df7afd0 upstream.

LOLLM observes that we memcpy from the xfs_name object, not the name
string pointed to by the xfs_name.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: b961c8bf1fc3d0 ("xfs: deferred scrub of dirents")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1640,7 +1640,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		memcpy(__get_str(name), name->name, name->len);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",


