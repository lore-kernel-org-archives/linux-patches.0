Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0F02D8364;
	Sat, 12 Sep 2026 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226112; cv=none; b=ZkqzGq3mZ/Z4gkD37JvIN7TbZQF9Ggu4QyYDIhTwWICZMgEwO8qyW1cgOTDFUgT3lNLkznLq0o7oIqEPg/pJek0r4dF6K2/oSh4qAq1yjmKjnE2lpRa713gURXpvfYw0ru471hmusPfBd3hNDKx6wq8PowNXLuCASrX7rlVS+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226112; c=relaxed/simple;
	bh=YOOMq2t89mHRm0ilyaeO+k0nNkypXI7iWoIgjqL7lPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K14OVf280dwXZ0aWfP1XEne+GWZ/zh2dmV+qPc8fF53k1YE2DwU5Y4yk1VQe5lpQ1FpGrVsKZQCnRsU2XZlnxkJh6Fuu/hZPdMrCXJ6/HEW19HSZxvg5e/M7dnA6UdTcLYh/+JLd55y6UOxbiVaDQUwM0ltjBip7DKr7CFmUIec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pgs2jas7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgs2jas7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413F21F000FF;
	Sat, 12 Sep 2026 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226110;
	bh=mfV88yBd1cLRjZve9SrAnZPnzxmjzT4/IsS9VdIxIls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pgs2jas7vK1svU4nJPYZCcYSG9dJYxCKGx4gdcUzQZ/IdKk7lP/u0wbKR99e3blFq
	 JPx95Jju6W8P5IrPxasFnHRM6hgUboXCVbhBn5y9zM1IbgZLYUDrIAeNhV8hJFaX14
	 02cfYQSQ5lQ7yWwxU02I5cyLkwaXBCJxnLZH4Ajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1336/1424] NFSv4.2: fix LAYOUTSTATS send buffer exhaustion
Date: Sat, 12 Sep 2026 09:02:48 +0200
Message-ID: <20260912065637.177670154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2a99bf46cdf8..4259917885c17 100644
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



