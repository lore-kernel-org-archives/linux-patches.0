Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023097BAEE;
	Mon,  8 Apr 2024 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584110; cv=none; b=AGOEl4tblQbpotT4947E3WLmXEIW3IpVBgvKeyPCKO58BR7PUrLPJXduk3BarjQvOiR/38oHfT0M+IHUmuugmi/75OK3p6Jy22B2vatWKr6IVkzpynkppriYvjm+oabogb5A18cnNfp6FCh6odNRc1b7WUEp38YG3LA0e9lDMcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584110; c=relaxed/simple;
	bh=2KQwLutt+oKU4479H+IPEDkqbFK8L3JKJPklv+DPnf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUK/GmBs0eeqRJKZKS7z+WpDbrQ1IS9CUCS35p13KWpQkWuL1WAH9/QOvpJs3ZQEcHHIc8Pd+Tv8FnIh16vX4VaYOx/F4QaIPs9kUeTQZ+A08WjyvRYT2BC+nEwH1WGc/PY0OhrZA8U5efM1iNxeZvbyMYiDD+sXsaAs/t96vO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7ZjsZCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7ZjsZCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515ACC433F1;
	Mon,  8 Apr 2024 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584109;
	bh=2KQwLutt+oKU4479H+IPEDkqbFK8L3JKJPklv+DPnf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7ZjsZCUWZHAkVLjsX4dlyF4HoYn5tcHUU8bZO8HLzFvcI+JefKqjW85RmisBvcdQ
	 66Zzyfu2VTMPaLzGW3HpdSusefJeyzYQTWCBvDmiFNob47ATZ6tqx71FFMdPUDHx7u
	 1/YCvsqh4zwiR6Evy8SthZn1nOHmtBZOQOSF3Tfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Mammedov <imammedo@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 335/690] NFSD: Decode NFSv4 birth time attribute
Date: Mon,  8 Apr 2024 14:53:21 +0200
Message-ID: <20240408125411.742648421@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/nfs4xdr.c | 9 +++++++++
 fs/nfsd/nfsd.h    | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 96d41b1cc2d17..07f891d7fa0ae 100644
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



