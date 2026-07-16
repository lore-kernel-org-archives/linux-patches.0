Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6132E3D953E;
	Thu, 16 Jul 2026 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210325; cv=none; b=BPoahjAFMDlIDOImqwjFuceQV7s2sxsveLrAVqfzYngDN78lFXlQ5uP7INiPyza16FXckjHwl/P6le8WkhDzix6tom2EPe/YpC34XA4iyczhk08cJoLQJUUOHsa6PlYwcmZYlz6iEAfbO+mUnadPl3Hf+vxmoqK3DirmjgO/jWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210325; c=relaxed/simple;
	bh=+RVJpVBwfbHZmNEhYfxz2OQMcvi4DXi/TSngOql7wzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+0pOZBmnWgXh0zL0S2Mfw1oQrMh1/fBleTTBfCd+AP2XOU3uhR2w0IYECl+u4LgQr9yP9w6eE/VGHGLZFXhU/7qm3UM1WZUKMDV3R9vmkHcPuqG+hzqQeGeItfS294LocZcR060j2wL2zvzIPapQwA37FugbxxnsMWYzQUNjvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkb0Kk3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkb0Kk3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BBC1F00A3D;
	Thu, 16 Jul 2026 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210324;
	bh=4D8uxTgfCLeVCl4F/Wku43ZCOVc/VZEW3avbYvZQqDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkb0Kk3VKbQLuY/IGHyginEm89QpqiphGzw5adwA6+AIy/kLh2isPluUm6Eheg2TF
	 /fQOEaMjjcGfMuP/WEaXzTKr2poHLYXVIgsiaG2oC6t17J1bUCOQyNMMhV4D+66oWk
	 XfDj+nLhYRYXKgktk/IeHzQ+z5rHzdIr+rmmY/GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 497/518] RDMA/core: Fix broadcast address falsely detected as local
Date: Thu, 16 Jul 2026 15:32:45 +0200
Message-ID: <20260716133058.717551335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

commit 942cd47faa2047b46dfd85745603eba9006973e6 upstream.

When rdma_resolve_addr() is invoked with a broadcast destination on an
IPoIB interface, is_dst_local() inspects the resolved route and
incorrectly concludes that the address is local. As a result, the
resolution fails with -ENODEV.
The issue stems from using '&' to compare rt_type with RTN_LOCAL. The
RTN_* values form a sequential enum, not a bitmask (RTN_LOCAL=2,
RTN_BROADCAST=3). Thus, "rt_type & RTN_LOCAL" yields a non-zero result
for a broadcast route as well.

Replace '&' with '==' when comparing rt_type against RTN_LOCAL.

Link: https://patch.msgid.link/r/20260609-fix-rdma-resolve-addr-v1-1-449b8b4e6c09@nvidia.com
Cc: stable@vger.kernel.org
Fixes: c31e4038c97f ("RDMA/core: Use route entry flag to decide on loopback traffic")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -438,7 +438,7 @@ static int addr6_resolve(struct sockaddr
 static bool is_dst_local(const struct dst_entry *dst)
 {
 	if (dst->ops->family == AF_INET)
-		return !!(dst_rtable(dst)->rt_type & RTN_LOCAL);
+		return dst_rtable(dst)->rt_type == RTN_LOCAL;
 	else if (dst->ops->family == AF_INET6)
 		return !!(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL);
 	else


