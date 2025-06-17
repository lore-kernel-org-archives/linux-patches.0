Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3957A2E9738;
	Tue, 17 Jun 2025 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178158; cv=none; b=fXxZK/iFn3jwC+PQSiHh4OLE0OoNwyR9kNHjz9hORHWZM2wDYTVXMwVcsINQLGhn6QKXfP2MvnlMzFznAc1yl41S9Xec9M7rkqdTD4ZjucUU3r2u3qzLmMwJ1cUzh8TxMAeRTlafDJfe9Xi+AT6W7KWUCVPYCbLCyXNiW9GwfWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178158; c=relaxed/simple;
	bh=AJ8DUJ6JhmVbc4KTaBj0WWUb3j704MbhuOvSOiZnjVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTNBUuxo2aJhPUbeYwOmHnRcO6858/HYNUffES2CZc5jW2BDebzDyn8u536FCWGhws2h1CgMnZwgScitpLjEnudVCZg2rSi4/z2jMlCFaLJnri8eU3Mpx8qH05Cy2xF98t/DgI6KaQ+vXG0Nkf7Ekul94qLva4QWfKH4bR9jHAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAtfxaiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAtfxaiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D05C4CEE3;
	Tue, 17 Jun 2025 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178157;
	bh=AJ8DUJ6JhmVbc4KTaBj0WWUb3j704MbhuOvSOiZnjVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAtfxaiSkcTx+JaUfMEkbST8pS4rdjtfUuxm5YXhHoueeca/DGp8aqu9q/MCV6IXN
	 09q+KNR9ZUIdFYvDP1fOC0skg/vHhwLdDnzsXbijnvZxHnTmbnkGMIJqQq4/7Gmsw2
	 mPFAS+jyfFKLA41dHCfRgC0Ag77AYK3SorsGO7CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/512] scsi: iscsi: Fix incorrect error path labels for flashnode operations
Date: Tue, 17 Jun 2025 17:26:47 +0200
Message-ID: <20250617152437.437550171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 9b17621366d210ffee83262a8754086ebbde5e55 ]

Correct the error handling goto labels used when host lookup fails in
various flashnode-related event handlers:

 - iscsi_new_flashnode()
 - iscsi_del_flashnode()
 - iscsi_login_flashnode()
 - iscsi_logout_flashnode()
 - iscsi_logout_flashnode_sid()

scsi_host_put() is not required when shost is NULL, so jumping to the
correct label avoids unnecessary operations. These functions previously
jumped to the wrong goto label (put_host), which did not match the
intended cleanup logic.

Use the correct exit labels (exit_new_fnode, exit_del_fnode, etc.) to
ensure proper error handling.  Also remove the unused put_host label
under iscsi_new_flashnode() as it is no longer needed.

No functional changes beyond accurate error path correction.

Fixes: c6a4bb2ef596 ("[SCSI] scsi_transport_iscsi: Add flash node mgmt support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250530193012.3312911-1-alok.a.tiwari@oracle.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8274fe0ec7146..7a5bebf5b096c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3526,7 +3526,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_new_fnode;
 	}
 
 	index = transport->new_flashnode(shost, data, len);
@@ -3536,7 +3536,6 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	else
 		err = -EIO;
 
-put_host:
 	scsi_host_put(shost);
 
 exit_new_fnode:
@@ -3561,7 +3560,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_del_fnode;
 	}
 
 	idx = ev->u.del_flashnode.flashnode_idx;
@@ -3603,7 +3602,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_login_fnode;
 	}
 
 	idx = ev->u.login_flashnode.flashnode_idx;
@@ -3655,7 +3654,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_fnode;
 	}
 
 	idx = ev->u.logout_flashnode.flashnode_idx;
@@ -3705,7 +3704,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_sid;
 	}
 
 	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
-- 
2.39.5



