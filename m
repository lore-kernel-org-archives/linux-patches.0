Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662F1EB5A;
	Mon,  4 Mar 2024 21:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588955; cv=none; b=DYLo45ok7eIcvLBI1wpRuzthUfM6frov19nh8GNv8jHtjvNu+ATHqa+nvh/UhdeOokyh/iVW/CTEPEMC9qepUZSxBWtNP0ENNjIYgfFMpTkcenSB1ugXjHA66ArIA/y3DYMyumdbXc6qS/HpKR8uTGtCQwOOyITyVUTTGhrLGUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588955; c=relaxed/simple;
	bh=slF9F6EnIwgrG+38TGJKcofgCwK0bgVrqZKKqcBeQvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCRpG+ClNU0iKMUzGUmkY6dFEm4Q69DZaPxRMi5Jd3o/bmqdCsscxYLpZ+wJXWRuPAuK0w7BuKFqMgBe8E65IDSPFP73eNFUTYHgTBWPJJu1VLhmrfg2TlaVRU2Pmbhtb6Rk0TlZsnl93XnuaVIiq7MHBmt8tDHMZzQ3tdBfNtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy/ER+T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy/ER+T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E15C433F1;
	Mon,  4 Mar 2024 21:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588955;
	bh=slF9F6EnIwgrG+38TGJKcofgCwK0bgVrqZKKqcBeQvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zy/ER+T22SZhtMmtn5eySkEJM3OLX+Kyl+84Yr/3yvDTjwFcIJ6JK+6XmyZx2sPY/
	 THTCrETun6NwlqVgFSDC6DYrNsX3ZrfNJQ9eP2LBEH7pkCeXiuJVLx60QxzAkhKZv+
	 5gdcvGlDekZgbgUtuy3QkhKHLAAqh66nSws9Rco8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 145/215] nfsd: ignore requests to disable unsupported versions
Date: Mon,  4 Mar 2024 21:23:28 +0000
Message-ID: <20240304211601.644996227@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8e823bafff2308753d430566256c83d8085952da ]

The kernel currently errors out if you attempt to enable or disable a
version that it doesn't recognize. Change it to ignore attempts to
disable an unrecognized version. If we don't support it, then there is
no harm in doing so.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -601,7 +601,9 @@ static ssize_t __write_versions(struct f
 				}
 				break;
 			default:
-				return -EINVAL;
+				/* Ignore requests to disable non-existent versions */
+				if (cmd == NFSD_SET)
+					return -EINVAL;
 			}
 			vers += len + 1;
 		} while ((len = qword_get(&mesg, vers, size)) > 0);


