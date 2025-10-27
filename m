Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1907231D37A;
	Mon, 27 Oct 2025 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591190; cv=none; b=A1rDhnwHr+7npyFWop4TwDd/o1x/Ff7iRXNBDuFR/0lHhcKnLUFmZdGoNDcH6T/wjQ9u4wEP8x866teuJccF4q20iiTtXdmTourhG8jMUdSgoZYNAJJQHLSQI6nytC75FtconTuhbhDkeLrFN3ChbTr3YCndMUSq2Ty1jDlj2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591190; c=relaxed/simple;
	bh=lTR1EMGgzgIaDFMrfFhFFhu3SyOR48e1jmpAB2znq58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnN2SunsK9qVYALsyVeqEDhc+H88zCAvlM9ISod4CKl4PlarDTXT7RBlw/qOtb/cgseTpU+lJz8t43nD9sQGO/KW7v5nKeBObdJNxWE8TgRgCQQHJhea+TaYh9oqcgsNCMNY9+qjJ6VQGPr0pHVIyCE/Td/AnzuGhbxiwkQ74Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2JvD94z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2JvD94z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F496C4CEF1;
	Mon, 27 Oct 2025 18:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591190;
	bh=lTR1EMGgzgIaDFMrfFhFFhu3SyOR48e1jmpAB2znq58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2JvD94z5p3JwjLlwu4LJzrmCUziNppCQz3hjp8/xZkX9ovDxglZWlEidvcmYonKt
	 x2Kvf5CopAVHiZKyzUv39FmTw9AgcnUIE/jNz/F0A21HRDxVHkL5OlvicBuxsLw121
	 e1ccsq/2rqb1qiMadQdqKdpNI3EES5vsZxS2pulQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/332] NFSv4.1: fix backchannel max_resp_sz verification check
Date: Mon, 27 Oct 2025 19:32:07 +0100
Message-ID: <20251027183526.579582649@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c094413c17541..87774f3b4c354 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8971,7 +8971,7 @@ static int nfs4_verify_back_channel_attrs(struct nfs41_create_session_args *args
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



