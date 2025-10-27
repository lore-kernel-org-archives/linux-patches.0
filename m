Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19984313520;
	Mon, 27 Oct 2025 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590485; cv=none; b=Q06xadXDxK1mfSkrwO6bhj2pYwIp/8AlIYBhdMT1W0D/bLG3ZYmJc69bVhaefnWvHhGlqbLt57FLBetDZ+/aOf5uW5osdW/qw1cnGaKGhZXH4lfpF/FsgNWtrAnY3fOqzlUqvg3NUWFQI16rS0q+9oGidrTEF9XmuOyEuNC0NOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590485; c=relaxed/simple;
	bh=mDYe/LF3hGlTOJbAVNeJB6wIotIfbjf7D1i3j2N0g3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZvjkwN/S6qX+qJTVwNHFn0FuIVBjKfFAfFlu2d9mWO11Hoz+U8V+NR6BXxFIv2mF5kpuEaUWaNoKffZVVeS8ttOozZNNpfxit2f0SjppNv4uO8ZII+gRncR5CFS3qKpO+l7r8uajs1X/5OV6ijElxwIOcgtaCEfA3YudEY3k+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFIRxeIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFIRxeIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A47C113D0;
	Mon, 27 Oct 2025 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590484;
	bh=mDYe/LF3hGlTOJbAVNeJB6wIotIfbjf7D1i3j2N0g3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFIRxeIZXEUhByvaOcfxAQbHlMjyLANqv8WIAuNK3aRhbY2Wyg1xoswtXLli+tSXZ
	 MBEh4uU3D37elh1ijOO07RhvaRAqWBR9FFICmIomKW6K2lWCq3GAOUSeAmNAxg11as
	 TPtDNnS6EktSJpu1yTytP3IirE0RZ9r5aJ1oIhAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/224] NFSv4.1: fix backchannel max_resp_sz verification check
Date: Mon, 27 Oct 2025 19:33:28 +0100
Message-ID: <20251027183510.664165618@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit 191512355e520dfc45c8bc3b56d4de59c3ade33e ]

When the client max_resp_sz is larger than what the server encodes in
its reply, the nfs4_verify_back_channel_attrs() check fails and this
causes nfs4_proc_create_session() to fail, in cases where the client
page size is larger than that of the server and the server does not want
to negotiate upwards.

While this is not a problem with the linux nfs server that will reflect
the proposed value in its reply irrespective of the local page size,
other nfs server implementations may insist on their own max_resp_sz
value, which could be smaller.

Fix this by accepting smaller max_resp_sz values from the server, as
this does not violate the protocol. The server is allowed to decrease
but not increase proposed the size, and as such values smaller than the
client-proposed ones are valid.

Fixes: 43c2e885be25 ("nfs4: fix channel attribute sanity-checks")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f511087d5e1c2..44770bb9017d5 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8686,7 +8686,7 @@ static int nfs4_verify_back_channel_attrs(struct nfs41_create_session_args *args
 		goto out;
 	if (rcvd->max_rqst_sz > sent->max_rqst_sz)
 		return -EINVAL;
-	if (rcvd->max_resp_sz < sent->max_resp_sz)
+	if (rcvd->max_resp_sz > sent->max_resp_sz)
 		return -EINVAL;
 	if (rcvd->max_resp_sz_cached > sent->max_resp_sz_cached)
 		return -EINVAL;
-- 
2.51.0



