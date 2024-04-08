Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F44A6A342;
	Mon,  8 Apr 2024 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584215; cv=none; b=aVOvPPRZbTENViwSQXOHhkERUxG7M/gKzQdGs6rxFCry12zC8nvgDNG8Ho0ovZWwzCHWFltbtS1HZynlmmfJzg1YDLHXsJ9L7olhX/q2thQlaiqScTYZ3x6hJbD0AP7x90pUBd/umghjZ3CFWSdfV7gyrH8mySzcLYyX3SGBBQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584215; c=relaxed/simple;
	bh=rUnNuN0lwDoQKbI2L+oyQuiK1nuSxWAjAFXsR8cZHck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz0kl1A3npeTv4RxXGpwhniJKowu4LpPcFPJrkHKJQCEnBhgZbq7WHvZwY4BUgA6cNk2i3bCn+ahzbf/8kdJPU62Bdd+rItO44Y3umENsxqpUOA+6+qb4KLVzvXeK9yw/0bd6OeqSTixqd5r6B1RXpqVqaTSIAgEagMg9/JmzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnnYGk5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnnYGk5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1883EC433C7;
	Mon,  8 Apr 2024 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584215;
	bh=rUnNuN0lwDoQKbI2L+oyQuiK1nuSxWAjAFXsR8cZHck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnnYGk5VOAiU2P2hXM0N+lA7ucN2ADwgVVoHfHk2QxalQ4A5AQdDrdo5vCrwr1NXN
	 oIx09i8ITTPuPQKtkf2w+jPxv4bRRi9LEX7IurzrJiIsdgyaEg1F1boXxHlj4zAxVD
	 +0nJLXjQAtqAVuaZ4/X4sfVUVRdVF1nRSqML9sWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 345/690] NFSD: Demote a WARN to a pr_warn()
Date: Mon,  8 Apr 2024 14:53:31 +0200
Message-ID: <20240408125412.097343192@linuxfoundation.org>
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

[ Upstream commit ca3f9acb6d3faf78da2b63324f7c737dbddf7f69 ]

The call trace doesn't add much value, but it sure is noisy.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index d70c4e78f0b3f..15991eb9b8d8c 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -630,9 +630,9 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	}
 
 	status = nfsd4_process_open2(rqstp, resfh, open);
-	WARN(status && open->op_created,
-	     "nfsd4_process_open2 failed to open newly-created file! status=%u\n",
-	     be32_to_cpu(status));
+	if (status && open->op_created)
+		pr_warn("nfsd4_process_open2 failed to open newly-created file: status=%u\n",
+			be32_to_cpu(status));
 	if (reclaim && !status)
 		nn->somebody_reclaimed = true;
 out:
-- 
2.43.0



