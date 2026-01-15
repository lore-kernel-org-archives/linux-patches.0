Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83F386334;
	Thu, 15 Jan 2026 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498653; cv=none; b=tusphTr6mMSIMih4YcE2mjBCAzoBhCRsvs+eQSaNMTj8AJ+PljMMmLPUay7IERAcc/VL0BOBgzsTMuKgDfDg0f7Xif5r68oCU/Rjdqdn3c/P+RMlwPvi6Mq0XSdnIS/pW52K+F2YMdZjnow7yFT6RH2w4PqLd88D6f7U4uJ91Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498653; c=relaxed/simple;
	bh=6CUWRfzAyZF5Wk5ogvAj0xSXTwU/YA4GX+Di7nooQsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nr4H8SfCT+ZWCYpPKCHELfFe7ps8UqozaLfHMSqkKigjG/r13u73XfbtXUPYcjTGcHdeqJ+uqBQb3fG8SaoNbRda4X2x/qPs1L+LD8qyeA2zD0URtpj4wTIMjqIstAklHRx15uPpnxOOivP3TjK/H/OUP5XgLI9RgkvEKy20XkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/QjcA6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/QjcA6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A02BC116D0;
	Thu, 15 Jan 2026 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498653;
	bh=6CUWRfzAyZF5Wk5ogvAj0xSXTwU/YA4GX+Di7nooQsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/QjcA6kAwbEs73ULtPUJ1GevLiIRdrL4/GgRuLSnFDqHNIyItiYcUGJHA0v4UiNU
	 XPdd7oqIrW2zz+oCt0m9lMQgi8eXVyMy8GG+QA+kCxnUDsIw68mqdqPT1b6dc8Jo4+
	 8sA96A+ypBV3VYkm5ih2UX5ORoA4xaOoP8aNGzSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 508/554] libceph: replace overzealous BUG_ON in osdmap_apply_incremental()
Date: Thu, 15 Jan 2026 17:49:34 +0100
Message-ID: <20260115164304.704731032@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit e00c3f71b5cf75681dbd74ee3f982a99cb690c2b upstream.

If the osdmap is (maliciously) corrupted such that the incremental
osdmap epoch is different from what is expected, there is no need to
BUG.  Instead, just declare the incremental osdmap to be invalid.

Cc: stable@vger.kernel.org
Reported-by: ziming zhang <ezrakiez@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1959,11 +1959,13 @@ struct ceph_osdmap *osdmap_apply_increme
 			 sizeof(u64) + sizeof(u32), e_inval);
 	ceph_decode_copy(p, &fsid, sizeof(fsid));
 	epoch = ceph_decode_32(p);
-	BUG_ON(epoch != map->epoch+1);
 	ceph_decode_copy(p, &modified, sizeof(modified));
 	new_pool_max = ceph_decode_64(p);
 	new_flags = ceph_decode_32(p);
 
+	if (epoch != map->epoch + 1)
+		goto e_inval;
+
 	/* full map? */
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {


