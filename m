Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A80E19DFAB;
	Wed,  4 Feb 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217227; cv=none; b=JTqrEs8X1Pc6Ls/t3CAkabQ2CNDqNC9Lhp9dNS1yhpUn2Odj7kffJ1ykDB95LbL09OchDvHy1HEYKUEW9x6vv0HwaXUmCWYaTqmlzb8NIFcJT7xmYayhpgFBprZ4TQ8VJlz+6esD33KW0OWQaLDiGt0cR4SZmnnId3lFRA99FJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217227; c=relaxed/simple;
	bh=lNJh2nKEy5SZ+7ymkkRtN3bePn1LTJWIrIqdRulPlOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKDJJ+BeRKgbCcbj+K0o7vYb9LQkSQDwGjYuAmTHgH9hUsvfL1QuT8dp0skP8tyzTrkHZULoZYiCm/JUP2/mlItG+EP/sKQLF0ZeJrUJVOvL3vrVz0j1K4vILoJ2boTT3PyqkOfxBlUVjmjYk7CubgBfkoxjCl/9+MCtJN9E2W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1C9YgOgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1C9YgOgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C92C4CEF7;
	Wed,  4 Feb 2026 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217227;
	bh=lNJh2nKEy5SZ+7ymkkRtN3bePn1LTJWIrIqdRulPlOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C9YgOgm8eXqNxoLqcRfaYBw4Wl8be4jkRyZfiYl9GKryG8L+eD22q6zgot86PIxS
	 JwcGlnP/EfaZRSsup3S9IqF4FL2ix2PeKu77ntS8/t0tJOt1p24WkoeeiVnXdOp6ne
	 Y1+wYeAAlYVIOTWWI6+vCc40oP3xwXZDSSOTl4PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/206] scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()
Date: Wed,  4 Feb 2026 15:39:51 +0100
Message-ID: <20260204143903.966435448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 901a5f309daba412e2a30364d7ec1492fa11c32c ]

Memory allocated for struct vscsiblk_info in scsiback_probe() is not
freed in scsiback_remove() leading to potential memory leaks on remove,
as well as in the scsiback_probe() error paths. Fix that by freeing it
in scsiback_remove().

Cc: stable@vger.kernel.org
Fixes: d9d660f6e562 ("xen-scsiback: Add Xen PV SCSI backend driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20251223063012.119035-1-nihaal@cse.iitm.ac.in
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ adapted void scsiback_remove() to int return type with return 0 statement ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-scsiback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1197,6 +1197,7 @@ static int scsiback_remove(struct xenbus
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 
 	return 0;
 }


