Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F16B1F755F;
	Tue, 17 Dec 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455564; cv=none; b=HvshBHM2bDoZSoGy+9JBcCZ91M5S9NbYoimE4D/pS0O8ORIc23wz3AbCuDYdEnWsKVOFv2jzjhij28fAwFsgA7kw6gZfBsd3h/IcpDdX2je7TeaxkVTMRjx4BBgSdW8AGfmnsCEJH5RYJcz26F8L5uNiwKkeSQMYX8e0kdtPe4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455564; c=relaxed/simple;
	bh=YgdPfSqCw5b6pqiiAJ9VU3dv7Ea2irDV6WdhwwLC1+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrVOnSxkBWyateJCC+DbEUju8JvIJWdvcL+YQbYCq+9SDNyZujyJnHv9cxSHyhwvcaJFgrSJa/gQMWRK0RmEjE7CG3uU3ebMjqRPVdwqKGD0cXSdhCJKjL1EbpWTgnvKPUabySa0XGh08hVlofDDEp+XdmItVoXFbsSvYbLZzvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNDFbqkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNDFbqkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B10AC4CED3;
	Tue, 17 Dec 2024 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455564;
	bh=YgdPfSqCw5b6pqiiAJ9VU3dv7Ea2irDV6WdhwwLC1+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNDFbqkbxZj2dSxkXN3kXdCt9Zm+nwUSVcbznim8JI8Wetw/nAcsEcc3EO10Ikh8k
	 tVWEDVE93FLforQySSR16X61ztd2svh7HoEMPR1cdMVMjDcGPBpOlxvSf5Zc74wYyx
	 PtI7q0xj56tdVALDEHLYwqIx2swM4yQNpph0mVto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MoYuanhao <moyuanhao3676@163.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 01/51] tcp: check space before adding MPTCP SYN options
Date: Tue, 17 Dec 2024 18:06:54 +0100
Message-ID: <20241217170520.365840428@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

From: MoYuanhao <moyuanhao3676@163.com>

commit 06d64ab46f19ac12f59a1d2aa8cd196b2e4edb5b upstream.

Ensure there is enough space before adding MPTCP options in
tcp_syn_options().

Without this check, 'remaining' could underflow, and causes issues. If
there is not enough space, MPTCP should not be used.

Signed-off-by: MoYuanhao <moyuanhao3676@163.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Cc: stable@vger.kernel.org
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
[ Matt: Add Fixes, cc Stable, update Description ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241209-net-mptcp-check-space-syn-v1-1-2da992bb6f74@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -824,8 +824,10 @@ static unsigned int tcp_syn_options(stru
 		unsigned int size;
 
 		if (mptcp_syn_options(sk, skb, &size, &opts->mptcp)) {
-			opts->options |= OPTION_MPTCP;
-			remaining -= size;
+			if (remaining >= size) {
+				opts->options |= OPTION_MPTCP;
+				remaining -= size;
+			}
 		}
 	}
 


