Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4C7248191;
	Mon, 23 Jun 2025 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685237; cv=none; b=l8MTldLOv0XW9Kzwo58SIRT+EFG+FJ10DC4fwKJ+cHNr8MgUW09QojJxmNnSNx+m7bAUTLhoU4YQfWoO7DxlWslZGpOb299dSuXN2utj27nUm/d4mv1SU+3/ziR7twvIBV4FzXTDDEM/sWeMav9HFcQ7pBYm8OO98YVpy1GV3GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685237; c=relaxed/simple;
	bh=+Iv6yYr0yn+ILhI+sw9k5sVgZ9Z+mNYiOLCwJrBJAJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViTaRd9HSzecA0A/8avfVt2MFJdEiFELEixUourHKVTe+m3Gw3I/EV+1vQk3usbUn1G7muiPTyI0fC19i49tQFO6BfaOqUl9oWYRzajoOBrwHmrchBJwMtBis8cedzPKNrTgbFWNfx6pCD+AzHwySUT0GIBwzzhRBYX2awxaUhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOD0VT7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOD0VT7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A33C4CEEA;
	Mon, 23 Jun 2025 13:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685236;
	bh=+Iv6yYr0yn+ILhI+sw9k5sVgZ9Z+mNYiOLCwJrBJAJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOD0VT7RKXeflHr7t5XF+l/2pk1vgSkW/4GJ7XDvBeUHK7/ByXz6x6xdzFdnToVEg
	 DSKfnBCZoGO1zp1D+4kGZkz2wLklNIY8eoK4jQJ9ZS5WuV8jlPxLNIJa1gnIin8did
	 MyMYkmEQXMfXLlgnaTda/o/Ii8PqayOBlKCu2tU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/222] scsi: iscsi: Fix incorrect error path labels for flashnode operations
Date: Mon, 23 Jun 2025 15:06:52 +0200
Message-ID: <20250623130614.416838391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d75097f13efcc..0977e4a09db03 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3235,7 +3235,7 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.new_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_new_fnode;
 	}
 
 	index = transport->new_flashnode(shost, data, len);
@@ -3245,7 +3245,6 @@ static int iscsi_new_flashnode(struct iscsi_transport *transport,
 	else
 		err = -EIO;
 
-put_host:
 	scsi_host_put(shost);
 
 exit_new_fnode:
@@ -3270,7 +3269,7 @@ static int iscsi_del_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.del_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_del_fnode;
 	}
 
 	idx = ev->u.del_flashnode.flashnode_idx;
@@ -3312,7 +3311,7 @@ static int iscsi_login_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.login_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_login_fnode;
 	}
 
 	idx = ev->u.login_flashnode.flashnode_idx;
@@ -3364,7 +3363,7 @@ static int iscsi_logout_flashnode(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_fnode;
 	}
 
 	idx = ev->u.logout_flashnode.flashnode_idx;
@@ -3414,7 +3413,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 		pr_err("%s could not find host no %u\n",
 		       __func__, ev->u.logout_flashnode.host_no);
 		err = -ENODEV;
-		goto put_host;
+		goto exit_logout_sid;
 	}
 
 	session = iscsi_session_lookup(ev->u.logout_flashnode_sid.sid);
-- 
2.39.5



