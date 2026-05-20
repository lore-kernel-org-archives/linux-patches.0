Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566163F9F2D;
	Wed, 20 May 2026 18:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301645; cv=none; b=pYyjQwQDFTjhPJ1pt2Am6yqOLhzYFrM0Ub3pHXjq0NHAm7Db0bkjFWGw1XW3A+jqrIz9x8Gpmw65+XfWlvlmikUitscxeIDSwMGru8zfi69LfKki4c0b62BHWB+QtNczKWN8DjRzIR06IPNYZCAZTNjA4bhbrnPSwNEkgV5le5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301645; c=relaxed/simple;
	bh=Jd6cXod9yosCx+na25BEJCY2zde++TL/+AGZk/13Hv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMXnj5rEyhvYX4O2/JC5uvXM1ZoI4VSmAZWrcNv4d1mrLpUeNTZGtwJWVGWIESIaoZt4aVxBhE+0OXViWFoFFc2Rfp8L2fFaNk+TtgUmDbkE4Tju7RLoRDUZ3MxE6GTwWmplVdiWMB3pU4KxrJgutyOFniQMeDeYhpk3GyOypdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcnK7x7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcnK7x7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C31F000E9;
	Wed, 20 May 2026 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301644;
	bh=H1SYpVohqvVdrAZprpfhQ2lo5joFyJa8Posd9+nkoNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcnK7x7QBK2rHqWbecKEjZudcLxvEGVpMDymQcFlzXI+8/BctDi/hPZsnCTRKZDeC
	 lzfgRQh1bDDI+JXngCrciZ6tLU/cXlommT0mQqXyBWMvTWZAPltd/D7QMgCIj3Hy7N
	 ts7J4BfTcMPa2FjN2E9sZ7BWh5QS7QWZ5TuFFHr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 633/666] powerpc/warp: Fix error handling in pika_dtm_thread
Date: Wed, 20 May 2026 18:24:04 +0200
Message-ID: <20260520162124.996829211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 108d7f951271cbd36ca36efc5e5d106966f5180c upstream.

pika_dtm_thread() acquires client through of_find_i2c_device_by_node()
but fails to release it in error handling path. This could result in a
reference count leak, preventing proper cleanup and potentially
leading to resource exhaustion. Add put_device() to release the
reference in the error handling path.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 3984114f0562 ("powerpc/warp: Platform fix for i2c change")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20251116024411.21968-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/44x/warp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -293,6 +293,8 @@ static int pika_dtm_thread(void __iomem
 		schedule_timeout(HZ);
 	}
 
+	put_device(&client->dev);
+
 	return 0;
 }
 


