Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E8B18024;
	Tue, 26 Aug 2025 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212580; cv=none; b=SB44j8CiE57M8NdvqtkeGy66LhQ5GQ/+Vyw3bYmbngj7OwUxS6BvHqLtLedA7NhWeiVzmH+nD8ldILhr3wT+zCm/Jy/thN0DKVUShsUIfo3jHyU1y7weoMzOhPfRB+HFTFvYdj1tEYmDxoPZutPySFKOcTyy5jpIpjVlvFr7l9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212580; c=relaxed/simple;
	bh=1trdmzinmdL7tNJeVXIyiyfEm/N0moAjGzrOeTvJJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlERsbQQIj8YgpsT9RbthovNLUp28Oth3IMlfaz+ID24UzRKX/CTjVWOheeDu0Jp/DINssiJcGUkNwWKLsHkYJB43xs+mFAn57sgMWR/tAmhGbo/HgQabivwhNkzK1TiSn8xlqiVL+mQY+UJpitTaoFBRJL7LObvP0SVFbsD2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPMFl8p6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPMFl8p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B80C4CEF4;
	Tue, 26 Aug 2025 12:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212580;
	bh=1trdmzinmdL7tNJeVXIyiyfEm/N0moAjGzrOeTvJJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPMFl8p6ns22z6Yg8V7Sid39HNLc8Zy0Dp+rAmQZWQ6TXcu3iOGRVTVSnx+W4/+q2
	 pflXSW0EIkCnNVS16ztOFhVxLifx1CX18FnDlrV0fvqrM6NZsNZUeI6TUKVNWk/flU
	 UwLi82TY4y3Zh6VtVtMm8umwFlvSmvz0FsRUUDJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 007/587] smb: client: remove redundant lstrp update in negotiate protocol
Date: Tue, 26 Aug 2025 13:02:36 +0200
Message-ID: <20250826110953.135556865@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

commit e19d8dd694d261ac26adb2a26121a37c107c81ad upstream.

Commit 34331d7beed7 ("smb: client: fix first command failure during
re-negotiation") addressed a race condition by updating lstrp before
entering negotiate state. However, this approach may have some unintended
side effects.

The lstrp field is documented as "when we got last response from this
server", and updating it before actually receiving a server response
could potentially affect other mechanisms that rely on this timestamp.
For example, the SMB echo detection logic also uses lstrp as a reference
point. In scenarios with frequent user operations during reconnect states,
the repeated calls to cifs_negotiate_protocol() might continuously
update lstrp, which could interfere with the echo detection timing.

Additionally, commit 266b5d02e14f ("smb: client: fix race condition in
negotiate timeout by using more precise timing") introduced a dedicated
neg_start field specifically for tracking negotiate start time. This
provides a more precise solution for the original race condition while
preserving the intended semantics of lstrp.

Since the race condition is now properly handled by the neg_start
mechanism, the lstrp update in cifs_negotiate_protocol() is no longer
necessary and can be safely removed.

Fixes: 266b5d02e14f ("smb: client: fix race condition in negotiate timeout by using more precise timing")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3998,7 +3998,6 @@ retry:
 		return 0;
 	}
 
-	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);


