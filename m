Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FBE43636A;
	Mon, 17 Aug 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978277; cv=none; b=mCDCoPoXwkQpnnI8aBuuvAeMAKNH2tz0D8DJaGPdZWYWKWJPNvvjwf91ScZD1Orqu2x7V5daz4x991wV9VN57qnOhjLGFuKt1iQfZrQt6z7xOQzMpfSBjFLhzK/SDPFBuuEY3+APZ2jVindWHWZwrDV+j0eWxyldvUt5LQVFOJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978277; c=relaxed/simple;
	bh=CW0j0b/qGG+rRMGS6WqJxC1FiYSzNN7wFi98UMrBDH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar4RQuq7fi1JKg8a0E1tmtMYvoMcHTERKdfcQeeIyRkdHjWEpraXMafo+DVfYV/c2LE4ZUSWw0nkoqdVr32/5bEd+a/gzJIzfCjIcXq6KdNiQyryZMIhuADhtTbowhDlYKsUw3JYgSdHPHPFNMSh6ZylyWcClxYau0ZMZ6vJVpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVNnX2xB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVNnX2xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8B71F000E9;
	Mon, 17 Aug 2026 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978275;
	bh=G3zjGII30ePlln7ff6UI+MMXVoZtKpwarXYPpzQmrJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVNnX2xB/T13LNdgPQa45k8PVc/jsQiXsGQtMlhNkBEZwtCpT+552wNvEFFjAa/5g
	 zJQRFQ2+VosadlamwBRWM5dZDd/CX9xojGh+s3cVAAn91T8vP1YtQSaETeOd67xuvc
	 387G2VLmJqoZQGSNfmA65FZ9w/powp7W3JwAIjUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 160/181] smb: client: Fix use-after-free in cifs_try_adding_channels()
Date: Mon, 17 Aug 2026 15:34:14 +0200
Message-ID: <20260817132541.978477404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -259,9 +259,9 @@ int cifs_try_adding_channels(struct cifs
 				cifs_dbg(VFS, "failed to open extra channel on iface:%pIS rc=%d\n",
 					 &iface->sockaddr,
 					 rc);
-				kref_put(&iface->refcount, release_iface);
 				/* failure to add chan should increase weight */
 				iface->weight_fulfilled++;
+				kref_put(&iface->refcount, release_iface);
 				continue;
 			}
 


