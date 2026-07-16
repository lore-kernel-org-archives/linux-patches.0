Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C94D27732;
	Thu, 16 Jul 2026 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211528; cv=none; b=Jfcwo04xN/9yOGvJqRAJVE5FupE2xYJ1qfjVxrGhDUiGfmXdk26iX4+MWL71zQMKmEC3pr2XnhoMZaHupgduIslZsMpPCxDlVKUzebTGMc5tg1wFnyCjruuKj+4BdsFfqG5Z64O2FeJ43g43AMN+0rcCgjHIsUQ9e4RGmHvKRnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211528; c=relaxed/simple;
	bh=jCR3KnSPx84bcR8JqGpAbZvtno7L49tTI4d6xx2LxSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHNSc5BIIx5PbN/gM+W2QGei0mh2H5rGQpx5HZjackrgvMwCz0i1kFytEino+QfwNQeqWEPf6kiRaVN8OqMpgUYeTUU6a+yJS8PY+P2cADvmv8pYH7l16rMJqEudTHeD6C+iO+ylJKvf+m/UcQ1F0SbBVIzPtFyZihlHdrRj7Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBHohdKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBHohdKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20F01F000E9;
	Thu, 16 Jul 2026 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211527;
	bh=Dny8JwAqIccs8vd4HP7/FAglSqTV7Q42YBDP3lvm1fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBHohdKip93hm/HINybPznwz4BkR4mfVTt6B62NU0NtDBfhemd9xPzoLiIuqDawxT
	 iK8GkMZ6+KECSjg9H2lbVfpKgkfKUKVKtwVzE8nHkv4r+hicwRQSB0diyKmqnkPKVv
	 QBivoob6TP5ble/GaPTd1ENl6c85/BxaQ/QG4KxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 460/480] RDMA/core: Fix broadcast address falsely detected as local
Date: Thu, 16 Jul 2026 15:33:27 +0200
Message-ID: <20260716133054.775970825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -439,7 +439,7 @@ static int addr6_resolve(struct sockaddr
 static bool is_dst_local(const struct dst_entry *dst)
 {
 	if (dst->ops->family == AF_INET)
-		return !!(dst_rtable(dst)->rt_type & RTN_LOCAL);
+		return dst_rtable(dst)->rt_type == RTN_LOCAL;
 	else if (dst->ops->family == AF_INET6)
 		return !!(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL);
 	else


