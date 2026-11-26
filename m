Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704784;
	b=g4FA7AJsR1FmVMn3kklE29z2mnC9slA7tmbnKc2FNc0rS//+2Ii5EL7rw6ObtTJQEvth
	 x5gNU0a6pxKFR+4PsgQ5Wa6azs3XW5dpTE817+dAbQrJMoGX+qB530w1Ptqj8SRAqwKws
	 sVWNcinXm5Bge4g8I8SrAbO/iYPpb25PJEgs+0ON3OH8C+wIApBXaa8voaaQL4n9N/IUL
	 FtOQjO3bbzPg64zQD+r+k3rpnjimFCZEdTqzs87DM8noKDzC+ciFIko6Oq0N6UZ8Z3pDZ
	 GTO5isC/ThL7VytCdko5CaRFSebw7usVppGa++Ofqicwcj+kr/rBzJqFKvFVeEv4NfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49ndpgsZrtSWG4qUudxOHQ36p9QIs3jzOQzOVYpW19A=;
	b=msb/8TZuv7phpUen7Koz9H3TlOXginEC2VUsGvlg1DR+CYwojXFVyWxJPuCKcbKQlvpd
	 xv39K7fTmyuItD9hsll5dFhu/b2NX5iO5fpcmiO8Zmwo/xcfbUNMXTUh7W+MBFilf51Fw
	 6PINtdLHkDUlj0U0LBtsuXZYvg04DMgOvK8+HmiaJe/m2tvoGKO5LVFw6uQ/gEaf4miVd
	 A0b1vm8/8HrYzRj6OS1ufWiNxTa1XrM4nMLojWUNiV2XeYt+MCPpt9Frib6ClB6hhl/P/
	 BWDrvbhpuNFOZr+3gWkj1axU3+mm3plKXnPZEYP5HvFKk2sPorH7YBSQMWpy0G6gl5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1+4TLTu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD39606A327;
	Thu, 26 Nov 2026 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1+4TLTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595591F000C0;
	Thu, 26 Nov 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704783;
	bh=49ndpgsZrtSWG4qUudxOHQ36p9QIs3jzOQzOVYpW19A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1+4TLTu52aLNJmjjCIEbTKvnJl3MmoSeitYlfSEnvTI3iiiOWGGsXCdEI8iR+eTs
	 0leNunrB/AgxQIzADeaBT5IkklgVxeZqxX2V1FTjE8rLTONAr12A5q8woos8R+EUFA
	 dqlbMLA9eO05iKkVh4DD1fr47bU5ac5ZBpDYCRjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 198/265] dm log userspace: drop the device reference on error
Date: Thu, 26 Nov 2026 15:38:48 +0100
Message-ID: <20261126143619.054308701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 0550d3b14e008b033b02cfce668008ec6addffe4 upstream.

userspace_ctr() takes a reference on the log device with
dm_get_device().  When the integrated-flush workqueue allocation fails it
jumps to the shared error path, which frees the log context without
dropping that reference, so the device stays busy and cannot be removed.

userspace_dtr() drops the reference correctly; do the same here.

Fixes: 5066a4df1f42 ("dm log userspace: allow mark requests to piggyback on flush requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -293,9 +293,11 @@ static int userspace_ctr(struct dm_dirty
 		}
 		r = dm_get_device(ti, devices_rdata,
 				  dm_table_get_mode(ti->table), &lc->log_dev);
-		if (r)
+		if (r) {
 			DMERR("Failed to register %s with device-mapper",
 			      devices_rdata);
+			goto out;
+		}
 	}
 
 	if (lc->integrated_flush) {
@@ -313,6 +315,8 @@ static int userspace_ctr(struct dm_dirty
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);


