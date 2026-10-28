Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211206;
	b=L9DoVy1n5MSEZEnz4AhMxwyumSulBZnbTEoIuhB7AiyusDWfPCzvARhiarNTumfo5wWj
	 kvty5r0JPUJcy2d1y0ptRY75MbaJ9y4A3jxYOpwa087AeGK3g+G7Faz7oOclvkC+OkZ/l
	 3ZTehDy8HtsNmyTVWYubYSEg5vR//fSkdG1YlUN1Hi35tQ4dFBk8WYLLu9si6MvRNTsyK
	 RyjvHq6ZPMf0Jza+rGnAhP1zmSlkmZbjeQ8EHKoaM947Gcriwb8gl/bu3RJcAdd84q/Wq
	 +TYxvdxZqGsxMofhWjzyhfGQQmdDaXFrsFusI2/3rrrVFhpMgJp5Ca8LkIXKeWMOSNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=J+JtMbE6Wwd7/DugUizcgp1pntOYvUZp/L6EhdrsflA=;
	b=AOzWmH+Lp+JY2j2ocWwm4ApeyT5X6SOqodIOWQTYreFPAkH5EOWarlQziQ40VXh3UF4C
	 A82waGTQY7dMhbUFWepUUIEuADqggum9eCJqrYthswkuIkTKw4s5Y0crxI4KgLcUosCpP
	 yIyj5TUM6jOn1uJKS6Vpog7j/a8Mc7J8Dw0QuGoDKZjEfp911HdB18W15NC0C2Ofoc5Vd
	 JHMziYhEfrYusVsuIAqiAz4dQlcMSIyX1gxehY6AamHWjrFVpTU6m/mc6ddw4SmEkgXXD
	 XRfmAt5TRYEqlxkBPp7nzkKtiaSnum0Q4t2hy0uzMsB/Ia5QCB6W/jyRY5SnIoBX+PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oetFsGQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747D606B45A;
	Wed, 28 Oct 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oetFsGQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D441F01828;
	Wed, 28 Oct 2026 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211205;
	bh=J+JtMbE6Wwd7/DugUizcgp1pntOYvUZp/L6EhdrsflA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oetFsGQHhe4mPkLLu3gWhKeuHubX6PTRHNNLb8uYRDyaVgVP2jKAkL57RB2Jz/xMn
	 0RvAhe68EhEwYOFlZRD6yo/IkxNoMz1DnfaCCTetqtuq9iCLETa03GfKK+apTgzM36
	 4MhPyB1gQCb3HBHLGV1Itx0k0Ms/kG6AlyrqZYk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Jinseob Kim <kimjinseob88@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/571] iio: buffer: serialize buffer teardown with mode claims
Date: Wed, 28 Oct 2026 17:57:23 +0100
Message-ID: <20261028170015.023530426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinseob Kim <kimjinseob88@gmail.com>

commit 84bb0fc46ccf6a545b8fdf57cda83770186ed8dd upstream.

Buffer-mode claims hold mlock to guarantee that the device remains in
buffer mode until the claim is released. Normal buffer updates take
info_exist_lock followed by mlock in iio_update_buffers().

However, iio_device_unregister() disables and deactivates all buffers
without taking mlock. This can invalidate buffer state, including
active_scan_mask, while a buffer-mode claim is held.

Take mlock in iio_disable_all_buffers() so that unregister honors the
mode-claim lifetime guarantee. The info_exist_lock -> mlock ordering
matches iio_update_buffers().

Fixes: 0a8565425afd ("iio: core: introduce iio_device_{claim|release}_buffer_mode() APIs")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

[ Backport by Jinseob Kim to 5.15.y: mlock is still in struct iio_dev,
  so use indio_dev->mlock instead of iio_dev_opaque->mlock. ]

Signed-off-by: Jinseob Kim <kimjinseob88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index c81dbd2f09727..30d20e3ef0515 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1187,6 +1187,8 @@ EXPORT_SYMBOL_GPL(iio_update_buffers);
 
 void iio_disable_all_buffers(struct iio_dev *indio_dev)
 {
+	guard(mutex)(&indio_dev->mlock);
+
 	iio_disable_buffers(indio_dev);
 	iio_buffer_deactivate_all(indio_dev);
 }
-- 
2.53.0



