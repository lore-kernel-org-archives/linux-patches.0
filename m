Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0F622258C;
	Mon,  2 Jun 2025 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873137; cv=none; b=hAiWhPB7o2cx0P4ElXF5Srq4Dj9dFU53Xb77gsueAaUpMuJTCArKpBYuEzFJKsounfg4C9KaL8EyBnfpNImSauoDkAklLDv3Y/fhPKRkvqZCccmywcgAnfD0OlmuiKcDN37uRCeY4jm6T6Dt2TFaF9PuRVRU/bCE1k3rEyUVErg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873137; c=relaxed/simple;
	bh=8+YRY25d9eAqDuY9GDbpfbI5u6U77Z91Crz3bQsrJYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIifSs8UXg56jgLeaz7EJ/YSYhBqMbmDq9eIgLZCCzcNH90o/cd/zFjseGAaVbPR50YcvZRNK/dCV2bJdCNiMS1dKNfpuTZ6naMsgf1VtmSgPhW3f/Pevo3UuUxaVuJgpSMkQEenJ99zoqayCLjXkChHJ4bn/yn40/qFqi3oCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xzv9K2+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xzv9K2+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1967C4CEEB;
	Mon,  2 Jun 2025 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873137;
	bh=8+YRY25d9eAqDuY9GDbpfbI5u6U77Z91Crz3bQsrJYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xzv9K2+y2AYE4AXeIbXS5VWMYB98iA0dOAY2s6mDEcUdjXXBlEcp4J2a3pECexesH
	 b/daaBy/obucfh5UC54Ye4NfubVWJr7p9zVTHYJADGqae9Ck6cK4i3gBrwcFmB2gfc
	 4fEbid3LWJP72L05Y/bOttwGZt0zzjVUO96qaw7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/444] SUNRPC: Dont allow waiting for exiting tasks
Date: Mon,  2 Jun 2025 15:41:46 +0200
Message-ID: <20250602134342.635873956@linuxfoundation.org>
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

[ Upstream commit 14e41b16e8cb677bb440dca2edba8b041646c742 ]

Once a task calls exit_signals() it can no longer be signalled. So do
not allow it to do killable waits.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 9b45fbdc90cab..73bc39281ef5f 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -276,6 +276,8 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
 
 static int rpc_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
+	if (unlikely(current->flags & PF_EXITING))
+		return -EINTR;
 	schedule();
 	if (signal_pending_state(mode, current))
 		return -ERESTARTSYS;
-- 
2.39.5



