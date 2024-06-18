Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36B91A00DF;
	Tue, 18 Jun 2024 13:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716126; cv=none; b=RY4CxvBZYw+G9al5uO0A0GsIhyPHgVY3V2FUx9v2uZFsmu1gCBddCnPU2hWSds/IgvNBSGIJ3RO38LqXwpRrXdhY72omboL6/Dzd3xuTXmB2m72Y2Tqcqr3XhVbUPNeWLyprc4zIaxIvv552ABllegiGy48eh8V3AksqY8WNvs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716126; c=relaxed/simple;
	bh=1ec8Sq7MhS43LhPOmRNK/EeRjaKKycrDG2+Pt+CJrgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxLQ0GhnAyRwA5yUOyRpn5nBHf4xwbwv04Lt+SLgzxj2pxRrRzMABB2lxWvTkFlUmUSKrQottUY0iZw9/GxQkzKl7TYp301Pxc6QCI1myUPm0qA8UMzuRgPn0iHhN/cYAvqPFm2H/KcnFHsK80OdJrojcw+4rkvVz19WXgcB+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J92dj1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J92dj1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE2C32786;
	Tue, 18 Jun 2024 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716126;
	bh=1ec8Sq7MhS43LhPOmRNK/EeRjaKKycrDG2+Pt+CJrgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0J92dj1uo2rL+Y1omj5vw2m5crHImZ5r8RE4wzTh5xblHT4q3Kk7vZiKYMm5RGfEG
	 wOcdA2ziaRvMoeu+KnV1vcVrzHz7UW42T9qzQSWeR0u0BHTGr6XRteM9qduEmJwohD
	 WusQ/7r43h7ZMsGOGmRMhB4d2P85mA8/7StpwkHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 541/770] NFSD: Decode NFSv4 birth time attribute
Date: Tue, 18 Jun 2024 14:36:34 +0200
Message-ID: <20240618123428.192496268@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5b2f3e0777da2a5dd62824bbe2fdab1d12caaf8f ]

NFSD has advertised support for the NFSv4 time_create attribute
since commit e377a3e698fb ("nfsd: Add support for the birth time
attribute").

Igor Mammedov reports that Mac OS clients attempt to set the NFSv4
birth time attribute via OPEN(CREATE) and SETATTR if the server
indicates that it supports it, but since the above commit was
merged, those attempts now fail.

Table 5 in RFC 8881 lists the time_create attribute as one that can
be both set and retrieved, but the above commit did not add server
support for clients to provide a time_create attribute. IMO that's
a bug in our implementation of the NFSv4 protocol, which this commit
addresses.

Whether NFSD silently ignores the new birth time or actually sets it
is another matter. I haven't found another filesystem service in the
Linux kernel that enables users or clients to modify a file's birth
time attribute.

This commit reflects my (perhaps incorrect) understanding of whether
Linux users can set a file's birth time. NFSD will now recognize a
time_create attribute but it ignores its value. It clears the
time_create bit in the returned attribute bitmask to indicate that
the value was not used.

Reported-by: Igor Mammedov <imammedo@redhat.com>
Fixes: e377a3e698fb ("nfsd: Add support for the birth time attribute")
Tested-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 9 +++++++++
 fs/nfsd/nfsd.h    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 804c137fabec5..b98a24c2a753c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -470,6 +470,15 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 			return nfserr_bad_xdr;
 		}
 	}
+	if (bmval[1] & FATTR4_WORD1_TIME_CREATE) {
+		struct timespec64 ts;
+
+		/* No Linux filesystem supports setting this attribute. */
+		bmval[1] &= ~FATTR4_WORD1_TIME_CREATE;
+		status = nfsd4_decode_nfstime4(argp, &ts);
+		if (status)
+			return status;
+	}
 	if (bmval[1] & FATTR4_WORD1_TIME_MODIFY_SET) {
 		u32 set_it;
 
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 847b482155ae9..9a8b09afc1733 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -465,7 +465,8 @@ static inline bool nfsd_attrs_supported(u32 minorversion, const u32 *bmval)
 	(FATTR4_WORD0_SIZE | FATTR4_WORD0_ACL)
 #define NFSD_WRITEABLE_ATTRS_WORD1 \
 	(FATTR4_WORD1_MODE | FATTR4_WORD1_OWNER | FATTR4_WORD1_OWNER_GROUP \
-	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_MODIFY_SET)
+	| FATTR4_WORD1_TIME_ACCESS_SET | FATTR4_WORD1_TIME_CREATE \
+	| FATTR4_WORD1_TIME_MODIFY_SET)
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #define MAYBE_FATTR4_WORD2_SECURITY_LABEL \
 	FATTR4_WORD2_SECURITY_LABEL
-- 
2.43.0



