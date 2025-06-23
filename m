Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC8523F295;
	Mon, 23 Jun 2025 13:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684381; cv=none; b=SYljbz4AZxDXkFIpjCtfdwetVrAh13pus42T/JsvOmNa5UC+n8CsaHpkSdp8HEV2xQJwfiCGAQRgDhAWqyZXghTeFtM4+MbfJNTBCvm8aSGV+UK1LMOho8QzdgJRWVXQCmixC72B2ZOwutwq+BfrIBUikPrdYXfeXnwFU0G4SsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684381; c=relaxed/simple;
	bh=fWA3eHFjuhU+7OCPICQBLYhed1XOPrpME+fVUpcEWpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfKi0rbhFj9wlpngy/1ZhyV8Cs6atQ2bu7aDFn5KdT5KZeFjQFiLlvoUPt/BixA6Ea85u1+k5/GVRx21jGJFV9seKJFQSDfvu49G0NuzRCEfLKAUAsIsk8OCBZbG9ew0K+7B5gXu/Y3p9r/zOq7fgxeUH2eCkDW7oFpwqMxL2aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sv3pOMDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sv3pOMDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6113CC4CEEA;
	Mon, 23 Jun 2025 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684381;
	bh=fWA3eHFjuhU+7OCPICQBLYhed1XOPrpME+fVUpcEWpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sv3pOMDjWE9MwbhoqWeIMJh0IW5yNVx6y2yuk8xIamKghnIlhVI5Y6ZoAABiOINZq
	 KwqDeeXTchtam2WRoH5MNZ9LLnkQ0042EfPjrV4hXidiZ5+azmMVH3/tk8BowkryGC
	 RdgdHMSfjjNao4sW2FzDAYpgh7pQHwF5j7bxgfzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.15 047/592] NFSv4: Dont check for OPEN feature support in v4.1
Date: Mon, 23 Jun 2025 15:00:05 +0200
Message-ID: <20250623130701.363786313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 4d4832ed13ff505fe0371544b4773e79be2bb964 upstream.

fattr4_open_arguments is a v4.2 recommended attribute, so we shouldn't
be sending it to v4.1 servers.

Fixes: cb78f9b7d0c0 ("nfs: fix the fetch of FATTR4_OPEN_ARGUMENTS")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3976,8 +3976,9 @@ static int _nfs4_server_capabilities(str
 		     FATTR4_WORD0_CASE_INSENSITIVE |
 		     FATTR4_WORD0_CASE_PRESERVING;
 	if (minorversion)
-		bitmask[2] = FATTR4_WORD2_SUPPATTR_EXCLCREAT |
-			     FATTR4_WORD2_OPEN_ARGUMENTS;
+		bitmask[2] = FATTR4_WORD2_SUPPATTR_EXCLCREAT;
+	if (minorversion > 1)
+		bitmask[2] |= FATTR4_WORD2_OPEN_ARGUMENTS;
 
 	status = nfs4_call_sync(server->client, server, &msg, &args.seq_args, &res.seq_res, 0);
 	if (status == 0) {


