Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A9C35F602;
	Sat, 12 Sep 2026 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204824; cv=none; b=ULfVvhRyiRhwCn9NZ0Ls/GOVDWHjXEkdz2WdJH4i44LnVk5oqh2d8+Shw3usgRx46JD0MfcM3tdWlajCnMSoeFDS8RVDTyvhF08SkESK2YEGBJPGqQufApCPSHa9+B76PevWbWE+JpJk30fdd/0OOcEgG5PoklSgKdjhoIglwTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204824; c=relaxed/simple;
	bh=ODRpphoMeQ3P+XwQL5Q/JDpHPtVXfJNKjnFfetNP4Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j76hg6DbjO0xR9O90AZtiVCGLuGic27eY+Ei+fBTgJqETv4JrNLT3pMz/jP0tbwhe34YpF6TACf95li+Vok/n1YsL2th52a/HuaIacxpF0ooAUr4Q8LdHv+/G2JwxpJgM+LZ74Yj5ZQbl9UdjOSZvPb/L/G5dDg1ycSv+quGKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLsLFyHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLsLFyHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0634F1F000FF;
	Sat, 12 Sep 2026 09:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204823;
	bh=heuxQveaFP7NWZFMA8uKKOBQDHnlxc5clYBUnoVyZyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLsLFyHilDLSTD8mYv6jsnqYXS/w651aprBSNOeDtw2k77aXq1ZphwUFRPgd1Jd0c
	 fiLJQiMyPw1VuFkM0YsNyCE0zPtWjSVSPUxdY5dKpoMilEy7RTk2lKoAkNx1Sic1BB
	 1JDMR2IqHliEjkIfgxf2CVUsR0k2FfAVAwqVPOBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1690/1815] NFSv4.2: fix LAYOUTSTATS send buffer exhaustion
Date: Sat, 12 Sep 2026 08:57:20 +0200
Message-ID: <20260912065728.655944369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 11c5b31cfc7da..e8144048cd0ec 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -354,7 +354,7 @@ struct nfs4_layoutreturn {
 	struct nfs4_xdr_opaque_data ld_private;
 };
 
-#define PNFS_LAYOUTSTATS_MAXSIZE 256
+#define PNFS_LAYOUTSTATS_MAXSIZE 384
 
 struct nfs42_layoutstat_args;
 struct nfs42_layoutstat_devinfo;
-- 
2.53.0



