Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C2012D77C;
	Tue, 30 Apr 2024 11:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475544; cv=none; b=aoBaTkRO9SDlX9zo9pOkhmZIM9UtxkT0wZ0gpuVeL5eus5lPAKxZrHqitKWPKnsibK8m4Dw63TS5NqOowm9bfD0kqy60sN/8kOpc4Zg88cwmhGkQRwusRq6y7+Z0Rb6L/m3gJ+0DYfy9NN63XGA4NIIrQmvkmnNyv9oiq5CqVnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475544; c=relaxed/simple;
	bh=94bMu1sX+niZQJAsaXUeDOBwOlH4EnaJ+iGxzehE2lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4yuIRMm/4XsqsupkY4fef1hir0CF0ZPBxwPl3hIDaV1tkrwsB+7T6jQQgV6w2fwOwlK/wEPdEuCI4OYrb/w1i9e4XcSPlfkORRAvhWPQOGDSVOeDuinVIwq8cgGmWNkR8k/Wp86VeCJurO6A4cvYLbo4h5oha0vQoPm8+BUnlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYlYUGpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYlYUGpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0102BC2BBFC;
	Tue, 30 Apr 2024 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475544;
	bh=94bMu1sX+niZQJAsaXUeDOBwOlH4EnaJ+iGxzehE2lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYlYUGpRuEgoadfPzw/mRnlPdRx/ZvQplAmqTDB0GU1Vr6fgimPCqfyRsy+Hwpc7Y
	 W6R1qqVnqL4eFh3VmA0mj+UEhTFz2hvOpI4b4/fdQHUHcGHDkMtkaIKFXzguRIPfUa
	 zLGR5VHOS+sLi2CjLpVFWOGxmji7gi4MBKkZwOCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 129/186] smb3: fix lock ordering potential deadlock in cifs_sync_mid_result
Date: Tue, 30 Apr 2024 12:39:41 +0200
Message-ID: <20240430103101.776534503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 8861fd5180476f45f9e8853db154600469a0284f upstream.

Coverity spotted that the cifs_sync_mid_result function could deadlock

"Thread deadlock (ORDER_REVERSAL) lock_order: Calling spin_lock acquires
lock TCP_Server_Info.srv_lock while holding lock TCP_Server_Info.mid_lock"

Addresses-Coverity: 1590401 ("Thread deadlock (ORDER_REVERSAL)")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -909,12 +909,15 @@ cifs_sync_mid_result(struct mid_q_entry
 			list_del_init(&mid->qhead);
 			mid->mid_flags |= MID_DELETED;
 		}
+		spin_unlock(&server->mid_lock);
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
 			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
+		goto sync_mid_done;
 	}
 	spin_unlock(&server->mid_lock);
 
+sync_mid_done:
 	release_mid(mid);
 	return rc;
 }


