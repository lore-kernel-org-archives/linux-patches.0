Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B98337B97;
	Wed,  3 Dec 2025 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777402; cv=none; b=UixnKUFMt+SziXuWAigEH4jSPWhIEDEqPmBZxuYgHkTCYSPgSwhpq/N3v0TJNv8MD5so9VvdpbKJXPQp+1u3Vqu93t5C+8dHXSlPD2wWVH/1I+DxYGeoweNxYMrN1Mcs5bMT12g8Xg4YWHQTCfnz3TFsLXGeT5laZvvH0EAuv2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777402; c=relaxed/simple;
	bh=noLVJgj+gBR54e89X/gPUqt6fCReS6bez4EZm26g3Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoknhvwLjKAJqVxSKr5yQYsx+Vx2iaRAspSwY3U21LnhEQDANStLDayex6dyK+XKCdJpGkiAV5HdsU3YU8LnO/qBcQHqBS5YyvcK9OcrPheLQ9MSinBF7KSM73WgBiOjDVGZv7KG707/2yqjKghQy9QwBrZCDqFLEyT/WH4fAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRPWdAxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRPWdAxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D6CC4CEF5;
	Wed,  3 Dec 2025 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777402;
	bh=noLVJgj+gBR54e89X/gPUqt6fCReS6bez4EZm26g3Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRPWdAxZwsEy6u2PUcQ0iDs+YBpPAANii+EBFjSUKML1ylEkzXbYfXWAkxwBQf6QZ
	 9F2pggJMGDUdH4tvAe0IPPZFnoSfflUI+kNs/v76VvjsAmaKEmbmBgyuIuvJXHBNg+
	 NePsgGD5aYw0bSyOmgdZiRs9bkR67QuwwEcVDNS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 006/392] NFSD: Fix crash in nfsd4_read_release()
Date: Wed,  3 Dec 2025 16:22:36 +0100
Message-ID: <20251203152414.326289697@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit abb1f08a2121dd270193746e43b2a9373db9ad84 upstream.

When tracing is enabled, the trace_nfsd_read_done trace point
crashes during the pynfs read.testNoFh test.

Fixes: 15a8b55dbb1b ("nfsd: call op_release, even when op_func returns an error")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -945,10 +945,11 @@ nfsd4_read(struct svc_rqst *rqstp, struc
 static void
 nfsd4_read_release(union nfsd4_op_u *u)
 {
-	if (u->read.rd_nf)
+	if (u->read.rd_nf) {
+		trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
+				     u->read.rd_offset, u->read.rd_length);
 		nfsd_file_put(u->read.rd_nf);
-	trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
-			     u->read.rd_offset, u->read.rd_length);
+	}
 }
 
 static __be32


