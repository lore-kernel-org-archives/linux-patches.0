Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B024E4C38;
	Thu, 17 Sep 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659044; cv=none; b=CilGutcJHjiGAHBNZYI/9NrcobaCC3UhM4SkZ4b5OcXckgWSRNmSuU0T59yhUFZDH8xl89oMVJHaov4tsC00larPtAr4TqjgYCPtrt4kChNo4ItGDwdJtXr1VTXKwBjPr6aKlRvg7PSEgeafbuDhe+SuG3S4awBzt/dP3iB+jtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659044; c=relaxed/simple;
	bh=Eh9oJxeRXix1SOkG/o5fmgvJbJoKynkCsJnQZJFi8OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgzTp2bV2jRyeyaavsaoEcQ0mSO9xlhh20TbAbaekH2p5Ej3ov3N4bbZMIsoTqHpCRB6qTAaIZ4VYN85fqpZdpmh2WBBRzJSvT6R0zu+Jfy+AybwTcTzsJ9ptnTX7pgvtSiBnSNTTFei8dFpwCRjqFMidWVbdcYX17j341Uzqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRngsfvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRngsfvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE12C1F0089C;
	Thu, 17 Sep 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659037;
	bh=JBCgPqo1j6GcItjCb4+SQMtsNQwXfoHJv/0e0DTdkno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRngsfvrKZfmYCn6PQHlDenYM8D6NuUDYMibIFVNYv4zTvjO5P+POcP5Deh5wiXxX
	 6+ziU0iF+HN8QCnHcjNU1HEDGrj+2tlX4tmnfExE8hjojuEQQYrq9cWSddIDYYa8lq
	 Nh5OtGfghQ8KIrRF8lNHTvu5cCHOMTEJZafLk2EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 083/733] netfs: Fix subreq ref leak
Date: Thu, 17 Sep 2026 16:06:31 +0100
Message-ID: <20260917151352.965627278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3c30087e27598d9d359763e8be9bd3017fe08348 ]

Fix a subrequest ref leak in netfs_unbuffered_write() in the event that
subreq->io_iter ends up zero length during preparation.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-6-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index e07e7850a5a21..86beeb337ed7f 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -121,8 +121,14 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		}
 
 		iov_iter_truncate(&subreq->io_iter, wreq->len - wreq->transferred);
-		if (!iov_iter_count(&subreq->io_iter))
+		if (!iov_iter_count(&subreq->io_iter)) {
+			pr_warn("netfs: Unexpected zero-length iterator R=%08x\n",
+				wreq->debug_id);
+			__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+			netfs_write_subrequest_terminated(subreq, -EIO);
+			wreq->error = -EIO;
 			break;
+		}
 
 		subreq->len = netfs_limit_iter(&subreq->io_iter, 0,
 					       stream->sreq_max_len,
-- 
2.53.0



