Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6E427B359;
	Wed,  4 Feb 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216695; cv=none; b=HbYbxSfK9jFlyCAlWmOAAMiyZwySyOtGU+v+lXHEYtKJyWki5Z0yKKKOF1FauA6ySyZ4DvGsaHEziajO1pxFgZNOR1/VC1qg++NyADdcWzHoKEv0hlQJJCKmu9LMy+146X7YxjFWcjKtwLUw7AoUbjdVV9VmIw8rAIPpGRP7vag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216695; c=relaxed/simple;
	bh=J9IFNBQwlLbEpQf1fzgxmBYq/+IyZAGrFneWcn3rsqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3T90NUzs1Iua0h2O58M9jVJ83bxM8JXL2X3mlfbvXRJQBJ8HcGzYzMYW91A9M5+omwFCjAUMHJ31OHm9g/OaF/kckmhhLFpDNt5o/wNnQxulXVGpaIwX4sELkTRyKgbwbEkJKZxm3i0Zw4s+1NzGlNtMtp1pIuytsJ4MsnKyAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPZX+9qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPZX+9qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E5BC4CEF7;
	Wed,  4 Feb 2026 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216695;
	bh=J9IFNBQwlLbEpQf1fzgxmBYq/+IyZAGrFneWcn3rsqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPZX+9qTvcl0d2/ORjWV7kgFlKHb/DucStdiwm99LQgoIyxKDnW1U+iUInOqxPvba
	 IJGMo5+AQTVYT7YOZEfvtgTBvC26/Wudhuxcunqeu57/RvAGhafOrrTC/kUQ4YRqqx
	 OmWZD+WPzCfnottLTOSflEZlZ+842JRdFFempsgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/161] scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()
Date: Wed,  4 Feb 2026 15:40:03 +0100
Message-ID: <20260204143856.784191129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1202,6 +1202,7 @@ static int scsiback_remove(struct xenbus
 	gnttab_page_cache_shrink(&info->free_pages, 0);
 
 	dev_set_drvdata(&dev->dev, NULL);
+	kfree(info);
 
 	return 0;
 }


