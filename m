Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88733A4F47;
	Sat, 12 Sep 2026 19:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240460; cv=none; b=NlP0sv2F2M33NMet+xOqRZq8oCTSB27b+MT8Lx+6YyKzR+lNbRdfLBUTTU/3nC9rVscmAuB0EybzGSTD1n7+PdbDSNoDKE1It0dUPizQ7wpVX8RAE2jWNMOK1oiPSXS/L538pcRlHc/5H+eBDX9wq8bjjZy4cAqtL+VyMHT+ifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240460; c=relaxed/simple;
	bh=BpMLVaX9pSGDXJM6WVFd/PbchjPrmwn5uvgmq6b3VyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K46RpkxdCRiNHEKzJgZlglp2cYxWe9Gh2VhuZyWvX+RyNtsyNoDWZNsXE7hPDaO1avG9r6/ArG7e8OZ1JK/1i0UbXgHUbT0xmy+k3+Uld48PqwMmnsR3sni4LzRgmbWhLK4zEVOloDxhhmJkJqpPLg85cNQmLmu36uI/0Vdq0o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvFkwGfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvFkwGfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1F11F000FF;
	Sat, 12 Sep 2026 19:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240459;
	bh=iMSWNjURzhPOjsBZbJUX70vksFN4CFSsEpMdsHoiLXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvFkwGfb6i+fggpzpHffgv8JZdfna6niYMZdLzO54jnLYqx192Vp/nMyLZJOeAqM8
	 1X1gIKxFrMX9XtD4e7U7pHMUx9n+qzFBgGzYEL4YWDQfuxgR8LUCRzc4RUZ6uZeMql
	 kzaegzu4QobYoofqB/iDVv8qJb6eJ0xCYSYXl2Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 874/935] NFSv4.2: fix LAYOUTSTATS send buffer exhaustion
Date: Sat, 12 Sep 2026 09:05:04 +0200
Message-ID: <20260912065546.862816032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c75ef2137e749f2673f0617cfdaae53b2bb7195a ]

encode_layoutstats_maxsz budgets XDR_QUADLEN(PNFS_LAYOUTSTATS_MAXSIZE),
i.e. 256 bytes, for the layoutupdate4 body written by the layout driver.
The flexfiles record can exceed that.

ff_layout_encode_ff_layoutupdate() emits, per data server, a netaddr4,
an nfs_fh4, two ff_io_latency4, an nfstime4 and a bool.  A data server
whose filehandle is NFS_MAXFHSIZE bytes long already accounts for 132 of
those bytes, and the two ff_io_latency4 at 64 bytes each, the nfstime4
and the bool add a further 144, so the body passes 256 bytes before the
netaddr4 is encoded at all.  encode_layoutstats() additionally writes
the deviceid4 and the layoutupdate4 lou_type word, neither of which the
macro accounts for.

The filehandle and the address are both chosen by the server, through
LAYOUTGET and GETDEVICEINFO, so it can drive the encoder past the
end of the send buffer.  xdr_reserve_space() returns NULL once that
happens, and the two ff_layout_encode_io_latency() calls run with
dss_info->mirror->lock held, so a NULL return there leaves the lock
permanently held.

Raise PNFS_LAYOUTSTATS_MAXSIZE to 384 so that the record fits inside the
reservation.

Fixes: 27c430644369 ("pnfs/flexfiles: encode LAYOUTSTATS flexfiles specific data")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nfs_xdr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 7321a5a95087f..50edd33b35197 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -348,7 +348,7 @@ struct nfs4_layoutreturn {
 	struct nfs4_xdr_opaque_data ld_private;
 };
 
-#define PNFS_LAYOUTSTATS_MAXSIZE 256
+#define PNFS_LAYOUTSTATS_MAXSIZE 384
 
 struct nfs42_layoutstat_args;
 struct nfs42_layoutstat_devinfo;
-- 
2.53.0



