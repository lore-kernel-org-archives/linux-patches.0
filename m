Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1B1D61AA;
	Thu, 13 Feb 2025 15:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461002; cv=none; b=e88qDY8c9FkEhYdhgSbVcUVWTL6ileS3p6GWcB+VfLhZA1zVup2tSnNepTxVqvH9HBGCXnqj/vB2j4CPAEkU5LAYb72ITI51fGQk6qBVwg7rwdJpm7Ph/5RLP/UpGLnIzcBmk0k3GcFEwDatz4lntH3iA0p+8chV/MEPspgU4oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461002; c=relaxed/simple;
	bh=vNLEWDOxxZhrphm7MRDsbHl6bR2W5ig9hhO7eeEN6vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEFZ9Ge02d+OVfAEvcY86z2Lwgcx5MRCI+LK+OrKEWh2qEaKfFhY1NC+s0iu0DFtSdNS7SF4ipJLRmpwkqoPngve3veMvYTZY3LPco1cvzTZPLoxiHSPj65M4N8SOW9J9WzloySnhH8CVu0DNm04TKifuhLwFwLWpqfkXSao9fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1mh/xmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1mh/xmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7EDC4CED1;
	Thu, 13 Feb 2025 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461002;
	bh=vNLEWDOxxZhrphm7MRDsbHl6bR2W5ig9hhO7eeEN6vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1mh/xmymqbHmfb5pjeVJy0TWg6I/xK2uFQJwwAGuCYWj8zy/AA/sbDew3iUO2ypk
	 lExMgzhNd7nlrFLQsG+nM5cOpEQSNu+gldXym4rvV/yfS6/ljRL6oW37XDZNZTvnOy
	 LoG8OF0Rg8Azw6jHiMjwT9GZ10T5MUPJgIURMZKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <quic_anane@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 242/273] misc: fastrpc: Deregister device nodes properly in error scenarios
Date: Thu, 13 Feb 2025 15:30:14 +0100
Message-ID: <20250213142416.999788867@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Anandu Krishnan E <quic_anane@quicinc.com>

commit 637c20002dc8c347001292664055bfbf56544ec6 upstream.

During fastrpc_rpmsg_probe, if secure device node registration
succeeds but non-secure device node registration fails, the secure
device node deregister is not called during error cleanup. Add proper
exit paths to ensure proper cleanup in case of error.

Fixes: 3abe3ab3cdab ("misc: fastrpc: add secure domain support")
Cc: stable@kernel.org
Signed-off-by: Anandu Krishnan E <quic_anane@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250110134239.123603-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2327,7 +2327,7 @@ static int fastrpc_rpmsg_probe(struct rp
 
 		err = fastrpc_device_register(rdev, data, false, domains[domain_id]);
 		if (err)
-			goto fdev_error;
+			goto populate_error;
 		break;
 	default:
 		err = -EINVAL;


