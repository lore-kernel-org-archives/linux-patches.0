Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6E0403AFB;
	Tue, 21 Jul 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654861; cv=none; b=UtNfJMLfSTpWMYwuMnqR1VT/AauQRdiheRzsIC0L1dzqPglLuOqB0MFoWwddTxAR9AtXkwumvDsEo+S5JdFXO1j6w1crVUQx7jZOIM5XRqXQrsC2/QwJKrM05WgOBqJB3orpdW9nUy591CjAPL0NqCaqmIgpbnOt9XeXWW6HkDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654861; c=relaxed/simple;
	bh=42e+Lgz/FiGasqYy9TIrxoBvMj/ZUX7aOZrx3cmUxcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KAo1Pd3Y3scTyCppYXWdYkl5TUat5MXsXE2KOPnkr+oVHJ7FWb38czaCE1O27o62ZiD/wMW4o7svQmIqp/VeaQIuzDJ3kmeZLvejXUmBwGSc+AROdSFkMjPJ2aW52DS4zqDwo+zC8qxn4gctlxAPzpu34jedpphWOeWku3g+rGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbC5RN7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbC5RN7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9337A1F000E9;
	Tue, 21 Jul 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654860;
	bh=tUuk7kMNKb3ON3Jh8BLwv+vYmTt7ewoHErUxphk3KqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbC5RN7vwyBZ3b6Uj1aUz/JQp+1MKYUSC94tDDlXoFmdGTByFPFp3nKkhtRvq7D6t
	 74LHzbKtH9GDCoBtl6uy2h5yQMdgaSOqPfptt7ozH4fU8/ByUjLXCDgoipzdEtAyEB
	 E7JIh8RC/JMrvjYvyHjBwXMEB/RAYsQVwwQJ+FHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.1 1865/2077] accel/amdxdna: Fix use-after-free in amdxdna_gem_dmabuf_mmap()
Date: Tue, 21 Jul 2026 17:25:38 +0200
Message-ID: <20260721152636.722371589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 63bbf9ac5dde2ba85e7b39d0a0b7d540e6252ba4 upstream.

When vm_insert_pages() fails, the error path calls vma->vm_ops->close(vma)
which internally calls drm_gem_vm_close() → drm_gem_object_put(),
releasing the GEM object reference acquired at the start of the function.
However, the close_vma label then falls through to put_obj, which calls
drm_gem_object_put() a second time on the same object.

If the first put releases the last reference, the object is freed and the
second put accesses freed memory, causing a use-after-free.

Fix by returning directly from close_vma instead of falling through to
put_obj, since the close handler already performs all necessary cleanup
including the object put.

Cc: stable@vger.kernel.org
Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260625113239.49764-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -480,6 +480,7 @@ static int amdxdna_gem_dmabuf_mmap(struc
 
 close_vma:
 	vma->vm_ops->close(vma);
+	return ret;
 put_obj:
 	drm_gem_object_put(gobj);
 	return ret;


