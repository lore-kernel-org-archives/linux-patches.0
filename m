Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F204973B9;
	Thu, 17 Sep 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660660; cv=none; b=kiPwhjQ1Gmm6QMwLLqXWOe9MrSC3hMNjDPVpKiC8aTx7SZ1iE/E4qpqso5lLoDg/zLb6gM2PRFuqva2lac6ZQo8NLNrJkbjD7MyZEx+u8khbfmhtxujrTzdOtlABjLyS0MSmSoZNoIMPcOQQn4eq5QNEzcSHvmhcJYortpDqo5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660660; c=relaxed/simple;
	bh=Z1ihOWX6aRbcg2NS6Tn4swGEWVzI7RF5Gf4eFuG+8BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbR2Hb0KgF+z47RqtJzcetrJj+vwQ5tquuloprPNbV+987JuWpp+rQrhNlYN0Lw1ci3NZx/R/YwGbsoDuIVEUhh596y2BYoAX7OWPmK61pBQkm0U73wBNfoHIDXdsqV1Aqaj5In0iVS5F4a5XwmVZ0POrV86W+GyVxNTOmmytVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCR0PVlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCR0PVlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A6F1F00893;
	Thu, 17 Sep 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660659;
	bh=xyTCjh/stc5i1OEaBPhxzPF5PDmN/QQQYzwnKmRzC00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCR0PVltWFXtMXYlp1YnHQIHt1rXD9p+KXIHVvVCRwPjKNyBJaWNxReniEIPv9huQ
	 XSb5bhbcir8njFODvEs42cYUpzlTrGSThz6CGK0QGyLUfSkccCG/jcGIljT+3L9t5C
	 6ReNxrSa4zRbYRs8bnVIPDsMmfQwv0fkrlVK4uUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 667/733] xfs: fix name string recording in slowpath pptr tracepoints
Date: Thu, 17 Sep 2026 16:16:15 +0100
Message-ID: <20260917151409.322664653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 		__entry->ino = I_INO(ip);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		memcpy(__get_str(name), name->name, name->len);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",


