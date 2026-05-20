Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21F3F5BF0;
	Wed, 20 May 2026 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297163; cv=none; b=FAZgf8hzldKzMQc0a6O1aDsXcWPDEanef3SCYvNaMfsDlmxTvb/Wtfovk5t18vcmnhw0w7ZuBib1W0v7mHhSDL3hveY56QKzIk9g5U5cbmvWW8DZTsqs6hIBlLZqRwbxTPnqHRLQs9BBo+/xoh1QNfZgHqPGWaoOjPHrY5OdBhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297163; c=relaxed/simple;
	bh=U/gB07a1CRPu5ljdVNXEA4Mspw5RMELf9Dce3nLb0Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4eyg4hHep4YP26InBY/Gky8Rxe3bjxvu+HuzIGMm1RNtYkTpjZExf/lvZEQlJLx8+uzB3x7KjXmltfAenJsM5LMZK2B/Lt4z1YonQY2VgfYeOt1w4zWIC3KTXMwwwWBm1bLNT3XW8xXkeOM4U8nZr+avgyru6z3Dyj/Hv+9aIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JROqxA+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JROqxA+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FBD1F000E9;
	Wed, 20 May 2026 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297162;
	bh=bcy6PmKCc+jqcgUOnRFg1uy9xccwpefezNPjYnV+wys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JROqxA+UaI79TcRmyNINUU37V6P1qIcQIQVL70XvADcJW7PZhfwbJN731n8K207/0
	 L/8/cdaIGbGXnba4M9h3G01KkB5wp/NE9bSt5fCZDfKK3T7HkZHNVpXbagc28uvm/w
	 F2MGRMTtpe0HSkT9AO/mpuP1qmTPdbguDj0rAc1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7c9eed171647e421013@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 7.0 1073/1146] drm: Replace old pointer to new idr
Date: Wed, 20 May 2026 18:22:03 +0200
Message-ID: <20260520162212.514166782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit dc366607c41c45fd0ae6f3db090f31dd611b644a upstream.

Commit 5e28b7b94408 introduced a logical error by failing to replace the
newly generated IDR pointer to old id's pointer at the correct location
within the "change handle" logic; this resulted in the issue reported by
syzbot [1].

Specifically, the new IDR object pointer is intended to replace the original
id's pointer during the normal execution flow.

Additionally, an unnecessary conditional check for the ret exit path has
been removed.

[1]
!RB_EMPTY_ROOT(&prime_fpriv->dmabufs)
WARNING: drivers/gpu/drm/drm_prime.c:224 at drm_prime_destroy_file_private+0x48/0x60 drivers/gpu/drm/drm_prime.c:224, CPU#0: syz.0.17/5833
Call Trace:
 drm_file_free.part.0+0x7e6/0xcc0 drivers/gpu/drm/drm_file.c:269
 drm_file_free drivers/gpu/drm/drm_file.c:237 [inline]
 drm_close_helper.isra.0+0x186/0x200 drivers/gpu/drm/drm_file.c:290
 drm_release+0x1ab/0x360 drivers/gpu/drm/drm_file.c:438

Fixes: 5e28b7b94408 ("drm: Set old handle to NULL before prime swap in change_handle")
Reported-by: syzbot+d7c9eed171647e421013@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7c9eed171647e421013
Cc: stable@vger.kernel.org
Tested-by: syzbot+d7c9eed171647e421013@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/tencent_C267296443AAA4567771176886DFF364A305@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1049,17 +1049,12 @@ int drm_gem_change_handle_ioctl(struct d
 
 	spin_unlock(&file_priv->table_lock);
 
-	if (ret < 0)
-		goto out_unlock;
-
 	if (obj->dma_buf) {
 		ret = drm_prime_add_buf_handle(&file_priv->prime, obj->dma_buf,
 					       handle);
 		if (ret < 0) {
 			spin_lock(&file_priv->table_lock);
 			idr_remove(&file_priv->object_idr, handle);
-			idrobj = idr_replace(&file_priv->object_idr, obj, handle);
-			WARN_ON(idrobj != NULL);
 			spin_unlock(&file_priv->table_lock);
 			goto out_unlock;
 		}
@@ -1071,7 +1066,9 @@ int drm_gem_change_handle_ioctl(struct d
 
 	spin_lock(&file_priv->table_lock);
 	idr_remove(&file_priv->object_idr, args->handle);
+	idrobj = idr_replace(&file_priv->object_idr, obj, handle);
 	spin_unlock(&file_priv->table_lock);
+	WARN_ON(idrobj != NULL);
 
 out_unlock:
 	mutex_unlock(&file_priv->prime.lock);


