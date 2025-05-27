Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7B43C01;
	Tue, 27 May 2025 17:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366528; cv=none; b=Yuox+g4AH+DtdkBdsoBWWbbrHGNsShmRZ0b/eLhDeFiUjzM3lZRO1JYpHxTHRKw+mbxVMZHfDyrK6ZaRzomf2LakIZNYkvtEHR2GLDZZ9t+qZwf4AU8CVndZjxxHHK1z+uYdvR8cQEZxjIgjnLgv9FqzLWzgZ4xEZQxDd+h0Piw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366528; c=relaxed/simple;
	bh=qpne9oP5gZhqeIMxrv7pVGJxF9hXHskTbOJXNw2joEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhcuQDVxRPsnBYsx/ZApsZeVbx/Fqspo87Sbpgn/Zbm+6b+A94bwWQdCSKvZxvdKmPSsJTZ4Q4A9Vxv9V7jMQj+I+Zz10B2OCqik224joTQ/JEhoeXlr1WGZuZ8oaVMWTpTeOjM7SuQrV20+l7TmQ+Fw1XuhQEhT8bKewp44CC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLeMgV4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLeMgV4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE015C4CEE9;
	Tue, 27 May 2025 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366528;
	bh=qpne9oP5gZhqeIMxrv7pVGJxF9hXHskTbOJXNw2joEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLeMgV4pVsUo3FtJQqU+LyTZIjft1kdh9GYJ8/ZTQaPX3BZtPm7Z6jjli9tTzihUY
	 sJ3el4HD/WID9NTZu/oYUAL0AjLdzNO6Dp1jY75H+NSmfU9hkHZnAttXDzR6gFNVf5
	 Pn3B8DkD96+ELXG1WltA/6lrx4sa43Q6vf1jKQsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 098/783] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Tue, 27 May 2025 18:18:15 +0200
Message-ID: <20250527162517.133005543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa42add73ce9b9e3714723d385c254b75814e335 ]

If the client should see an ENETDOWN when trying to connect to the data
server, it might still be able to talk to the metadata server through
another NIC. If so, report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 98b45b636be33..646cda8e2e75b 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1264,6 +1264,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



