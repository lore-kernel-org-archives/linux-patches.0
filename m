Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C0F1C68C;
	Sun,  1 Sep 2024 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208729; cv=none; b=HL4oxW4MPYCRgL9OtcphXOSV4ELlUEwD5VZ6XthKrZ+F5bBRO/gO9TjBIdUEMIBSyf2QrCPEtZYpKKvriGm0yxtPCBSRVoMmDAa+Y3ocEF2Kxla7VNAbl5EONueNPjthSpwkEIp+nDI7YQtHSUBZlSYehBoOAgBe54TxlTikWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208729; c=relaxed/simple;
	bh=0paFXTcSReWGIiVujGmeFJ82+7NPP+MPuTaH6OJIg2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMs7nQHjyzpVkUe8qcW6XXFF+8/K+DWBUFKbK1XHnbXR4mXIXnKCAN1QdDvgjE0VWllJ/YKOaEjyf68VXzpm7EhltPV5NnSDkMnGe3yRSbJfVBjlug/ImnkdZQGmeH+qbqhm981e9qlwG3+RzgNwwVtDBFhfAu0/mwpcBKxz5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB8r/6ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB8r/6ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B73C4CEC3;
	Sun,  1 Sep 2024 16:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208729;
	bh=0paFXTcSReWGIiVujGmeFJ82+7NPP+MPuTaH6OJIg2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vB8r/6ta+lw5ssDCkLH6v8nQtXTmHdeN71G/t8MH0yMGqekObEnR9xueUFOJIEgpu
	 AylPH8o64VdvRYeS9q1KPfWxGe4HvJQsApguIeONJslbB3THPNahLqy8lz1MMoN/dw
	 YdhFIP1+BjntG8BGnF88gJjCxFymJeGH6+8cs4ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH 5.4 006/134] dm resume: dont return EINVAL when signalled
Date: Sun,  1 Sep 2024 18:15:52 +0200
Message-ID: <20240901160810.000629264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khazhismel Kumykov <khazhy@google.com>

commit 7a636b4f03af9d541205f69e373672e7b2b60a8a upstream.

If the dm_resume method is called on a device that is not suspended, the
method will suspend the device briefly, before resuming it (so that the
table will be swapped).

However, there was a bug that the return value of dm_suspended_md was not
checked. dm_suspended_md may return an error when it is interrupted by a
signal. In this case, do_resume would call dm_swap_table, which would
return -EINVAL.

This commit fixes the logic, so that error returned by dm_suspend is
checked and the resume operation is undone.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1064,8 +1064,26 @@ static int do_resume(struct dm_ioctl *pa
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended_md(md))
-			dm_suspend(md, suspend_flags);
+		if (!dm_suspended_md(md)) {
+			r = dm_suspend(md, suspend_flags);
+			if (r) {
+				down_write(&_hash_lock);
+				hc = dm_get_mdptr(md);
+				if (hc && !hc->new_map) {
+					hc->new_map = new_map;
+					new_map = NULL;
+				} else {
+					r = -ENXIO;
+				}
+				up_write(&_hash_lock);
+				if (new_map) {
+					dm_sync_table(md);
+					dm_table_destroy(new_map);
+				}
+				dm_put(md);
+				return r;
+			}
+		}
 
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {


