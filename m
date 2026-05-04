Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE83C3DE458;
	Mon,  4 May 2026 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903102; cv=none; b=SKUGUBSeaRhDT16hP/Cj3Z5L4jzwL6igJ7ZithjFihuUcdTMIW5zgbgASwCyh90iNwNO1ygS0X4ABN8oFDdguGXu/z03qj3oXJZC/zkYSXVDM/NouUNlMhUF6DSyj+o4wFV9xSpAPIn1Lw7XRnq4olSzSwPNU/0023pJMGzkdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903102; c=relaxed/simple;
	bh=XFPSCFFagp8Wl4DU18PJXoza6srtr2hciSkfVu8EldE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3E/TfJonOxmrY2rLzJI44MYQAcJoquKpQKSKy+5jG5qfNwJIfVJ2SZUrUerlGMLDS+G9f8y/y5BS6RLwfQsL/lWXk7RQcErzEREwd0P8Iec9BjUPJPCb2Ci/soBISIDvO1eh2b8t1Vh9Crnpm7HOLrQW2xnQ40KzU4SG4DQAOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8H7LG82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8H7LG82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4289CC2BCC4;
	Mon,  4 May 2026 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903102;
	bh=XFPSCFFagp8Wl4DU18PJXoza6srtr2hciSkfVu8EldE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8H7LG82l8Y62ckH7pjnqKlOD/fgi0K0Hp/1icL/A8DLwrjRLq7wjPBqFdyxFNC/0
	 ALF/hirmuZXvxzzOTDcQV/7JF25lxN+Y8ozPm6D91Pilq+U6ZCMAO3rNZOdMTe/nYf
	 ILHY3AZddv7h1r+Kkj7s0NyQb22JffwbY9ei1XiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 062/307] lib/ts_kmp: fix integer overflow in pattern length calculation
Date: Mon,  4 May 2026 15:49:07 +0200
Message-ID: <20260504135145.153551205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

commit 8cdf30813ea8ce881cecc08664144416dbdb3e16 upstream.

The ts_kmp algorithm stores its prefix_tbl[] table and pattern in a single
allocation sized from the pattern length.  If the prefix_tbl[] size
calculation wraps, the resulting allocation can be too small and
subsequent pattern copies can overflow it.

Fix this by rejecting zero-length patterns and by using overflow helpers
before calculating the combined allocation size.


This fixes a potential heap overflow.  The pattern length calculation can
wrap during a size_t addition, leading to an undersized allocation.
Because the textsearch library is reachable from userspace via Netfilter's
xt_string module, this is a security risk that should be backported to LTS
kernels.

Link: https://lkml.kernel.org/r/20260308202028.2889285-2-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/ts_kmp.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/lib/ts_kmp.c
+++ b/lib/ts_kmp.c
@@ -94,8 +94,22 @@ static struct ts_config *kmp_init(const
 	struct ts_config *conf;
 	struct ts_kmp *kmp;
 	int i;
-	unsigned int prefix_tbl_len = len * sizeof(unsigned int);
-	size_t priv_size = sizeof(*kmp) + len + prefix_tbl_len;
+	unsigned int prefix_tbl_len;
+	size_t priv_size;
+
+	/* Zero-length patterns would make kmp_find() read beyond kmp->pattern. */
+	if (unlikely(!len))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * kmp->pattern is stored immediately after the prefix_tbl[] table.
+	 * Reject lengths that would wrap while sizing either region.
+	 */
+	if (unlikely(check_mul_overflow(len, sizeof(*kmp->prefix_tbl),
+					&prefix_tbl_len) ||
+		     check_add_overflow(sizeof(*kmp), (size_t)len, &priv_size) ||
+		     check_add_overflow(priv_size, prefix_tbl_len, &priv_size)))
+		return ERR_PTR(-EINVAL);
 
 	conf = alloc_ts_config(priv_size, gfp_mask);
 	if (IS_ERR(conf))


