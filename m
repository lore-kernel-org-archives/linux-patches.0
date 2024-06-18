Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2776C157A59;
	Tue, 18 Jun 2024 13:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715918; cv=none; b=gPc9h6s6cOKZmAPjC1+pD6UWamwV+74tmN4AQNW4jaARrhiuxzavo+SqibjeF3eG19A0E9uD/LZ7yriyiGr+bWSM2BA48bU3hX5BE66AQmmUVKxMpqvLCgeBysegoXYLY2KaEb6hr/0zBoxMUSCNtFbApLUpyK4WeN8c1Luznmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715918; c=relaxed/simple;
	bh=3VwCJ9RZhS/DHED7668bfBHlEhBEguB41NsW1wEMrZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSpxX+CUlSlUemCKwT2Fepw8uM6AIc8k0pI44nlSkCeHfYdpHjdz1ovth3R4n6fIFmbor/yh/nkZssJcG2SSpkwq5LSPtTXkkAxqQfvWsYos2GqiGSaNLX5TvsZFfQpEaokAMCzYjSMas9hKkr1E76cMTbfiLKlCXOG1yajGjhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuJgvHaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuJgvHaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2CC3277B;
	Tue, 18 Jun 2024 13:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715917;
	bh=3VwCJ9RZhS/DHED7668bfBHlEhBEguB41NsW1wEMrZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuJgvHaTmqxm3maforfr++QkcxPthCjh1axm2p7q2h6rx+934C+40LmGN4zM1TJs1
	 zSMKclCYatQ2Z74QKRzqueesaRyIE4NyKCGfP4Z7+Vlo1l7ggjk32hJcC0yDdL3ney
	 AENgW8hZ7iweCerr21/UingDH08q9no2m0OjYR1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruce Fields <bfields@fieldses.org>,
	Ondrej Valousek <ondrej.valousek.xm@renesas.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/770] nfsd: Add support for the birth time attribute
Date: Tue, 18 Jun 2024 14:35:23 +0200
Message-ID: <20240618123425.457181760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Valousek <ondrej.valousek.xm@renesas.com>

[ Upstream commit e377a3e698fb56cb63f6bddbebe7da76dc37e316 ]

For filesystems that supports "btime" timestamp (i.e. most modern
filesystems do) we share it via kernel nfsd. Btime support for NFS
client has already been added by Trond recently.

Suggested-by: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Ondrej Valousek <ondrej.valousek.xm@renesas.com>
[ cel: addressed some whitespace/checkpatch nits ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 10 ++++++++++
 fs/nfsd/nfsd.h    |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a7b9c3faf7a79..a9f6c7eeb756e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2854,6 +2854,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	err = vfs_getattr(&path, &stat, STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
 	if (err)
 		goto out_nfserr;
+	if (!(stat.result_mask & STATX_BTIME))
+		/* underlying FS does not offer btime so we can't share it */
+		bmval1 &= ~FATTR4_WORD1_TIME_CREATE;
 	if ((bmval0 & (FATTR4_WORD0_FILES_AVAIL | FATTR4_WORD0_FILES_FREE |
 			FATTR4_WORD0_FILES_TOTAL | FATTR4_WORD0_MAXNAME)) ||
 	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
@@ -3254,6 +3257,13 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = xdr_encode_hyper(p, (s64)stat.mtime.tv_sec);
 		*p++ = cpu_to_be32(stat.mtime.tv_nsec);
 	}
+	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
+		p = xdr_reserve_space(xdr, 12);
+		if (!p)
+			goto out_resource;
+		p = xdr_encode_hyper(p, (s64)stat.btime.tv_sec);
+		*p++ = cpu_to_be32(stat.btime.tv_nsec);
+	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		struct kstat parent_stat;
 		u64 ino = stat.ino;
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 3e5008b475ff0..4fc1fd639527a 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -364,7 +364,7 @@ void		nfsd_lockd_shutdown(void);
  | FATTR4_WORD1_OWNER	        | FATTR4_WORD1_OWNER_GROUP  | FATTR4_WORD1_RAWDEV           \
  | FATTR4_WORD1_SPACE_AVAIL     | FATTR4_WORD1_SPACE_FREE   | FATTR4_WORD1_SPACE_TOTAL      \
  | FATTR4_WORD1_SPACE_USED      | FATTR4_WORD1_TIME_ACCESS  | FATTR4_WORD1_TIME_ACCESS_SET  \
- | FATTR4_WORD1_TIME_DELTA   | FATTR4_WORD1_TIME_METADATA    \
+ | FATTR4_WORD1_TIME_DELTA      | FATTR4_WORD1_TIME_METADATA   | FATTR4_WORD1_TIME_CREATE      \
  | FATTR4_WORD1_TIME_MODIFY     | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID)
 
 #define NFSD4_SUPPORTED_ATTRS_WORD2 0
-- 
2.43.0



