Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2152A12BF32;
	Tue, 30 Apr 2024 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476564; cv=none; b=IKkxlINPabpnuWZ/Y09CCD3wN0omUxUDTj0LJ8qZ6TWyYsjZpRCFcLRyeI2pkYrr+cCElfvBcBjn9l2tPNQjAw9DRCoXnV05ix0X8vhiIkfKw7TKU9TDSxoRjN11sLZ9rM1gpPV+SX2FMrJWN5/csP4aVGhQwT4NI4R83R01SpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476564; c=relaxed/simple;
	bh=mUQ72RJeknWE5TpwGII29XFkDKsqWJR3J2/Ht9+8QSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4uaTTTkQBtAW9zG+2utIEw/TmPzfLxCho/KvGe67j926hHbEcyeeG5t1Rsts17fCMrCvo92ZgUH/aRwWn8bQ5ce47IdRwGtOMf8f3sauxmFFeXHngv6wNHvRF1CtzLXpYLjTBc7MDjPpoZxdoEZbXcGAwoojWKqi3l80PNikfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbJxSo3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbJxSo3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38104C2BBFC;
	Tue, 30 Apr 2024 11:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476563;
	bh=mUQ72RJeknWE5TpwGII29XFkDKsqWJR3J2/Ht9+8QSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbJxSo3rpHKsbWQScH4my9bMv2rV1okFCUwcO7K9DMleRs0WLEwYnFwfVjAycIVh2
	 FuQc0bbgoIXUpxu5yfyaG3NsS2vLDfHYGiI+KFfmWbClzKvWCIa8PmwAE/FqhOKyVw
	 yanIuJtFlj7IR7+i2tzX+7uWUQmmDfJs2+hxpkbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 071/110] smb3: fix lock ordering potential deadlock in cifs_sync_mid_result
Date: Tue, 30 Apr 2024 12:40:40 +0200
Message-ID: <20240430103049.662665517@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -931,12 +931,15 @@ cifs_sync_mid_result(struct mid_q_entry
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


