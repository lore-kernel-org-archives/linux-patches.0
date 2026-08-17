Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB114399C4;
	Mon, 17 Aug 2026 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974544; cv=none; b=A8viIGfJDdng847V2FykqVXHaDE+MzuZ+piKeqLiBfRAgVWs6Y5lWr6/C+T++cXGvSk6CYetPVVx9Og6N+eJ06vOIy6xPXJUBNVhOBUloOJnowRuRhdyI2qvHlFs9CX4Eko6e8Wxj1+AUaPYAN/Fxq5rU1tYQu0EnLXkaQnsFgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974544; c=relaxed/simple;
	bh=jITwxRl+gUWZLdmb4cLNO0sZS6POgtTXxWo1rmmMEok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfS12DXO4JfvODNLKImrNqJzjIuWnZdcunfdgfQR0w9HQDV1P0JClIDsxa8IfjTdKNqT1ao7fm21ZA4jHvXCgoxDzsxL0WmvKVMma9k1wuSg/bCoZkIRs44fi3wbtIDe8uNo9+AmpeKqoAEMOqyY9vtO9gZUX5ROFJxaezuHB9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMiq9go/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMiq9go/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A4F1F00A3F;
	Mon, 17 Aug 2026 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974540;
	bh=N9sGIop8drwGznJ1pqdBB+2AFVTnq5GfP61ztVsqm6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMiq9go/G/g1v7EBjen1cn94+IpcoLMoIx6JaBiWXPVGPbxoX4+bBGtXc/UhSx5z6
	 jOS8K0DoI6yf20CPTi8g9mTa1gRIAgQ4tGtx/uaCtYpJUOZH/rmGv2T3UD6TGpt/x7
	 8epEEKPq5WDGGfgrl2K4FihYwdd0DvvzQJr0+3ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 240/271] smb: client: Fix use-after-free in cifs_try_adding_channels()
Date: Mon, 17 Aug 2026 15:32:45 +0200
Message-ID: <20260817132546.634051989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 4986410316b1ae0e63c6ce418e4eb196723626e7 upstream.

cifs_try_adding_channels() takes a temporary reference to an interface
before dropping iface_lock. If cifs_ses_add_channel() fails, it drops
that reference and then increments iface->weight_fulfilled.

A concurrent interface list refresh can remove the list reference while
channel creation is in progress. In that case, the failure-path
kref_put() releases the last reference and frees iface. Updating
weight_fulfilled afterward then accesses freed memory.

Increment weight_fulfilled before dropping the temporary reference,
keeping iface alive for the final access.

Fixes: 6aac002bcfd5 ("cifs: failure to add channel on iface should bump up weight")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -233,9 +233,9 @@ int cifs_try_adding_channels(struct cifs
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
 					 &iface->sockaddr,
 					 rc);
-				kref_put(&iface->refcount, release_iface);
 				/* failure to add chan should increase weight */
 				iface->weight_fulfilled++;
+				kref_put(&iface->refcount, release_iface);
 				continue;
 			}
 


