Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3070822A7E4;
	Mon,  2 Jun 2025 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875524; cv=none; b=JZEG0JyhKRPobU3SYEhoFC7t0OOwXtURC57FnZpZ4R+MLpwIdz32D2B/QobUYaY4tKongi7Bi1byFHFS0fCCRUQqqX7LOLlUpAl4I6LMRxhEBkUCLRJe/0HxainaUxqu8pq5JHL6a555lGKFe/Mmd4I37C6z9q481hQayuQo9dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875524; c=relaxed/simple;
	bh=TsaUmG+rxNwqEQMhSTmQ6GOLzgpLK3So3ajiJuojgEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SblXjEcuIuVIRVPLwS3uwzq/c3jTLnRrdm8ZJEPUL2PqhdW0tFtPSs3NN8mOcOyAXors5VjaSmlEcjmoG1IKk2EzuBojwZWgGAwvfwLEMwu3ld5SBqHIe7PPlWFBJ1eFD/3Y5cE721MkMvpvJ2S35/uRmmwTIcXU60XcOS9ebUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eelGGuir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eelGGuir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CF7C4CEEE;
	Mon,  2 Jun 2025 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875524;
	bh=TsaUmG+rxNwqEQMhSTmQ6GOLzgpLK3So3ajiJuojgEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eelGGuirpwLhQ1t9reeYOnG/7B8dKRuB7R+zUWzcYJjnfLnXKnPwjN8Clf9poT9iA
	 tk2jlLQ8x12Esmk5iuHDYPGfRNkV+rEjGKv4QvmszAgO7yDDYuwpfYy8ws4CEJA77h
	 ogXBreqHKXRrUkWgRDZ4FSQc2Q5AIMRfRXMykBbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/270] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Mon,  2 Jun 2025 15:46:56 +0200
Message-ID: <20250602134312.583672965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1af0b8ad83f2d..ce9c2d1f54ae0 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1260,6 +1260,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



