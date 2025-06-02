Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC981FBC8C;
	Mon,  2 Jun 2025 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873186; cv=none; b=b22GQrdPFPnwgXJjuKQwTXOlabstazJj7SlRIVkTEe/wFXqWGFN7d6mtVtF94sfj2hsIJ7TfK6Em/R2F3MjYKABoSQ01q7xF5Url0B+qYHsc98uKOjgBJkrnz8QFnnFtDaiVydwRv0+HIPdcVJqtDsoo/6RYsCZg7OlMmQy4jCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873186; c=relaxed/simple;
	bh=Lf+eNZKbwFzbMb85iAUv3gy/Ap4RIQhePCTyf39vsmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyWSEQ9qmQzvuRXxrRjjSPHAOTyQ5ZpwFXe9hX50KWtC0d7R4igldhsbG7fTEEw+AIHCmKXbK21LcttJxj4PWEnegepQ99G6+JxDXAu/lyakngigrteAZO12uGbtxK5HdFlIGnIIZlil1BZvbOMJy1n/MtcF2V0lAHlZTgMmyxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cu7mKwX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cu7mKwX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D099BC4CEEB;
	Mon,  2 Jun 2025 14:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873185;
	bh=Lf+eNZKbwFzbMb85iAUv3gy/Ap4RIQhePCTyf39vsmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cu7mKwX4NEjLLCj+vrHuZFn8zgjLpitWAMJ9j8jUB7v8BuNn9/Zo2Z5F6Ql+fcqkP
	 rmJgWXAIvN41xuytcLN1HVii5O8TO0Y4to3xk9fbgSKOvpw1LkC8nLBMkn2l0K0KNF
	 F0MSfO7Hqm9AwicfB5vCV5klulyd+DKUJe9TbWtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/444] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Mon,  2 Jun 2025 15:42:08 +0200
Message-ID: <20250602134343.520053489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b3c5eea1f134..0bc537de1b295 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1255,6 +1255,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



