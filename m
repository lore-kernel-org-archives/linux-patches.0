Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F512C817;
	Tue, 30 Apr 2024 10:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474431; cv=none; b=k6DkHwGiRqmQN6zX7qeKUtbHYYmYTT7mBbbcfkI5ezws8qulNF31AKcx/SGrxh0ePunJSdb88tkDCRwOdJPmmiFLDGYq4I7XSW2S9TFRZDvl97kcnOprVrAizydev1z/KLGBTh3rDbIgAyKgUpY3f1ZNXMCVgkNA0yk0gnybStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474431; c=relaxed/simple;
	bh=cEJ/ICwgk5113syVatDaBbmMp7Lf+4+6zCiuRMxuxz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDOSQUCeFZ2iPnq7ovEjPiJR3CewfXa8GYGFW21UMagCBK3vdYEQbbP0+622KhW2vEzJ9OPx9R7G65rjnsyLcPQzFFDrWRKYTYd7Ow+pChLgisHYFSwUfCDnDfXDPc8Z3EiGR6wjMoO5sahYBwgVapjlcdND6JyocydfmcnNNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzzGYFW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzzGYFW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8155EC2BBFC;
	Tue, 30 Apr 2024 10:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474430;
	bh=cEJ/ICwgk5113syVatDaBbmMp7Lf+4+6zCiuRMxuxz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzzGYFW+kNmBdqJ098cIo7aXBzwVd8x+Z5V9Lz8hlH3RXeS9ESJPkKVzuHM5yHLrw
	 PMj3Oy2+8bSXovus9kML9M+4kKvoZZk01StY5alkjkHne7VWKL+nbGrzPxmb2WhvgI
	 XLPG+yPOkyQr6GA+zfPUx+lYMPPz+ItMPyJ7D5fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 155/228] smb3: fix lock ordering potential deadlock in cifs_sync_mid_result
Date: Tue, 30 Apr 2024 12:38:53 +0200
Message-ID: <20240430103108.279110509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


