Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE3F30C63F;
	Mon, 13 Oct 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367269; cv=none; b=Ez3tim8Zrfc3whPNbQJZZ2Exhqa9sl7VWFae1dJxGBUbRrDaV+yiYQ0dHykmGww16iwo1Wgq/qJOAUoGW2kJxqVKuY6q7xVqaSWHyjC/5B2/hJF12uNITgovP5gvG77ChvLi1xOvJai4qzNw4U0jCCmIzN8qhzv9s7tqVL2yzyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367269; c=relaxed/simple;
	bh=HucGJrqNmmajxGFkKAEkxSR/ilrNqP5UGSkxYHSGoaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnLUf3aS3Sf/iu/C4rsORYh4/RoTN4nXc8xsgWypnQjt6dQCp0nRj3y2zH+3Fg/MQUmuk920gurhA0uI44sas7vKP8/iR4O8MKySlazLrwIUAPSpO8aIPC8khfB6xsUf8+9hoAELgnrtMJSlVM1CIN/WnMdr+ghi4vYh0Cye4OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/OL1GST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/OL1GST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D09C4CEFE;
	Mon, 13 Oct 2025 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367269;
	bh=HucGJrqNmmajxGFkKAEkxSR/ilrNqP5UGSkxYHSGoaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/OL1GST1FFCq+7DEp7aKccKIey2/prvia07upi2DNgOJd+5raBffo6nW9g83awTT
	 rmaiKpQBak5s3b7LsYGRidkUgqo0lmaJDGdt1qrClIDSDVcN8a8jxfkU9ebfViFakH
	 CfN2V91ujWTJEsMi4We+rLCEKph5M0ociGrrLBUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/196] NFSv4.1: fix backchannel max_resp_sz verification check
Date: Mon, 13 Oct 2025 16:45:23 +0200
Message-ID: <20251013144320.124225917@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8a91d15982dc..cbcff4603232b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9231,7 +9231,7 @@ static int nfs4_verify_back_channel_attrs(struct nfs41_create_session_args *args
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



