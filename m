Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFFC21CC5C;
	Mon, 17 Aug 2026 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978723; cv=none; b=jG8/OGFXD2rvXkZzzrdRi0Xh8YOeH5zz157NAe27Kk+KiZ6ofS/TVlvvP3zaEklRFU+NXiESrTGfwbs+ReGgD8+ElX68ihyZZ1x/VXmv95YvOK625o7QxkJl9edwQFc4sdDTvvXa/eYVCh4hH97L6alKhXIgO8JZNwfu4/q2mQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978723; c=relaxed/simple;
	bh=73E48skjH3vntjiuRsqusZEIOfP4UgtjlJ/7emKShlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fS48n18vuEhpM+zaKEpXzVgHCVMEi1x9PqzyOZbCn4tV7nSHH7mtISb3lITrkiem1SEtLISfBSgmtoITTOpV0lpchFtILTBr28GJpSBKgj7qBJSVVRObbx8WUytPPyzsNnEwEJf7V3YinUMbAAvWwL+CigRG3Hw1WjkUc7cvSCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZS57ncs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZS57ncs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412361F000E9;
	Mon, 17 Aug 2026 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978722;
	bh=+dgHNtFT8WlT9tsF4yRqHOoxUiZNUHteJkU2mJARG48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZS57ncssj9VRguEyPsVg7I75dGZLsnDTdUPMbVE1CPNsLic/VEnMujogFE1vNFJG
	 tvUf0zj3G9xurHJz0D9Hm3E6Kq/cciSemtXEEtYKqhNGa4pyOfkuI/34GR14iv7rGH
	 g44HkSjxAvAtMRjggN3GbTU/P9O8fzjxgLyFyiHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 136/156] smb: client: Fix use-after-free in cifs_try_adding_channels()
Date: Mon, 17 Aug 2026 15:34:30 +0200
Message-ID: <20260817132540.019564724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,9 +271,9 @@ int cifs_try_adding_channels(struct cifs
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
 					 &iface->sockaddr,
 					 rc);
-				kref_put(&iface->refcount, release_iface);
 				/* failure to add chan should increase weight */
 				iface->weight_fulfilled++;
+				kref_put(&iface->refcount, release_iface);
 				continue;
 			}
 


