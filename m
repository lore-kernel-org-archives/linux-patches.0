Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A262B242D9B;
	Wed, 25 Feb 2026 01:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982842; cv=none; b=ZBna5bIQEvOvDh8qpxk7oyfKHEYuIyxJJ0nwVwbMs/gzCEm0DPGzkZPyhQZc1MX6a53NrnCUMoCNNwDctacAY57IohxbQoV5lAEQd8NFPxz4aBRL9Mt9Vt2oRohDd4B5wug0H4Ja+DEKCpedPrFTmAlkwwtWzlzgNV0eKBv8REc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982842; c=relaxed/simple;
	bh=Grj9Y3Q0ZtGRgJvuZ5fIXmovdAXxLLdFXFw7ZLpkWyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUGaCNRoC77ol3y+ypz3a9m/gbSJFWyKO+p0sOgXNNfsdBpNLuh+ua188xHv/rGYnUSQp7wyxm89/kzRyd43+JF9tfXM9z3MPFrnZvFTAzSll/P2bjIWR5Z7zxuEIIe2oy0XdKbZtnycfyZus9uoWUr01Ugo0+FDze1t//hAR88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeTjg2WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeTjg2WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20441C116D0;
	Wed, 25 Feb 2026 01:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982842;
	bh=Grj9Y3Q0ZtGRgJvuZ5fIXmovdAXxLLdFXFw7ZLpkWyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeTjg2WSi8zQAERBbwvVX3HT2rPaHP151eyqlW3HCwv3T6cNVxaxfvb1N+Uptw4QG
	 BxZQDOoSvti4KKAP1/4muPmSCocVNPXFtqfaKngTMLkoWKujn/nXgaevZ64YFdSwO5
	 YJ2nOU0/QGkTITUuLClXHeExN6nC46fwHMtKPoO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 034/781] netfs: avoid double increment of retry_count in subreq
Date: Tue, 24 Feb 2026 17:12:23 -0800
Message-ID: <20260225012400.540596737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit a5ca32d031bbba5160e1f555aabb75a3f40f918d ]

This change fixes the instance of double incrementing of
retry_count. The increment of this count already happens
when netfs_reissue_write gets called. Incrementing this
value before is not necessary.

Fixes: 4acb665cf4f3 ("netfs: Work around recursion by abandoning retry if nothing read")
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_retry.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index fc9c3e0d34d81..29489a23a2209 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -98,7 +98,6 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 			subreq->start	= start;
 			subreq->len	= len;
 			__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
-			subreq->retry_count++;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			/* Renegotiate max_len (wsize) */
-- 
2.51.0



