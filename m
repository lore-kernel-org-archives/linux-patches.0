Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DBA4E0B7E;
	Thu, 17 Sep 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671227; cv=none; b=Iva13FajeHggi9DXgWWGAoUYTN8nINzZ4r0xMgJbyGvqF3j3v8d2EbesYKus1MAzf/Y91sPP1Em/K1i7xBdN1bImzdQrcJWDmtzEFK8JxrrdAcctqa0ICTu3RM8mXXDhhrCyAYKJB2JeyQ0MSpL5PhDqMVNSwEi9SZd+2SN9f/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671227; c=relaxed/simple;
	bh=iwH3trDwgxy4ANHxA8Kzt/Wzznndvn7uyeZ4HcrGKlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5C+5STnWWSMafnSlU3vHvDrCqaZ5/DNLo081gFbsJb0rdmkhpNk4W60fIXvuWFB0snPrxTWcVNTf/c0M6u9yS05PzEuIoTlm8uWHTLPdS2cOjOAfQcTkmRg/GbfCHjdCAkMLzW/az9ReBmRJ2l27+SVEmsWoni3Pe59RJdwL08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bY2Qp/qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bY2Qp/qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2688B1F000FF;
	Thu, 17 Sep 2026 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671225;
	bh=V1LUmc+kKErIUbXVGgJYtktATvlrf/3aXDi8TWJrIJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY2Qp/qxNQiG7VaMM3SyqJwO5vbVg7TFY/mA/CgzwhBkIoa2QlLGb7EG9kLw04OA6
	 xRKwh9giapEPA+P+hPjW6kw8wMDKb8lct+u5gfFIAD/cJ57vsHpvPor00+XuJnOwgM
	 q/aABs5ft4FfCHL42cD5iPdRYmDjfJdbUioqvBoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0907/1102] xfs: fix name string recording in slowpath pptr tracepoints
Date: Thu, 17 Sep 2026 16:14:10 +0100
Message-ID: <20260917151603.378095030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -1627,7 +1627,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		memcpy(__get_str(name), name->name, name->len);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",


