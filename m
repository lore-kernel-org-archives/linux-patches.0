Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625981;
	b=zIU6lE5BTuQFuSPbZNUeLLrFs+019DPC67uhr7uPmaB8EWrgDY7q++cibxzyefwGtgBD
	 bp1qIaDH4nH2k6uVuxA+qWkyAFYQsrAJa264r2lO7mglSmlL7cKUuNCIo306Nnrhr5h4R
	 +i6MHG/fGac4s0iWebS2wJsmNJTPaNUkTGSIq8X8ovN035A3cMaAtK5+sGld9tiN3DJsP
	 9+pVeciyzUjQpwRK+r2793udedcbvGwSKRk8ictTa+XqVmS97wgSayO0BOtEFZeg9WYCx
	 XvK+ppQCLaN2ze/ftHTYr0+24iv8+JMEObQPrNr6bMloQj+mnQDMmK/luO14rHr/XIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSC5nswjpSstnTnjfA0u8emZWVUT3jMv2x02BvUJrcU=;
	b=xeRlnpUA5tlFkWUhlRdkfU8KZdk2Q3Iuk7LEnPQ0cP68STHxhGhgB9u1OB7/VDf+Hsmu
	 EwWBNGQKcDsxg2bIyp/D4N9Tco79ioGh3p8Q6YdeIg8bbP6VQWoa8NBt5if0WNHde5nHk
	 AdM725iMASnqPtYHFv08uofnkxW0wzIPkgeXHypR9uZE0jPRwBDozgWh0jRaKxeS/pJC8
	 UnTh5FwHa66Umq4Pp3Elx0MObmI9vZeAEmZFXr5vG23ilhEt4oguSDyEWmQTZOFE/hffR
	 W3PRhdKvuW5BgiZJBPMIOTJL0WvkZIMZOxbH6CdW51EsaLVXeTtvuuXI2PhW2wOpGYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1d8ecqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034A7606A31E;
	Wed, 25 Nov 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1d8ecqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70D51F000CF;
	Wed, 25 Nov 2026 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625980;
	bh=pSC5nswjpSstnTnjfA0u8emZWVUT3jMv2x02BvUJrcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1d8ecqIzHY45mV64ZOyVcc1NO52Us0WYFXDQiUgWspT7HfbVmIk9ftnpyQqQy0xj
	 6vonQK1Z8vV08tVwqgxA6Hvo3amWGQ8AJNy0D5rPSBe055FMAWomkhxJbC5QGuKU8o
	 4rTyqgKMlu+XKPnWs3BkXkdH8O5FPzdnq4tJ4rSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 691/816] dm log userspace: drop the device reference on error
Date: Wed, 25 Nov 2026 15:37:19 +0100
Message-ID: <20261125143905.180207880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,9 +294,11 @@ static int userspace_ctr(struct dm_dirty
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
@@ -314,6 +316,8 @@ static int userspace_ctr(struct dm_dirty
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);


