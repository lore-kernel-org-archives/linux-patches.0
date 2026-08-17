Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C51554781;
	Mon, 17 Aug 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976309; cv=none; b=sYBqV4nkQisDBFDxMtTSIUzN3qi5acbT9EjjBN7CcC/0cUsY2IXf1lwTiuPPjvHzJMMqQQoVe6spfuj3Cd10vleIq4TNLXTdfnsWtYgLIlcBIQG/to81RWZoH0gQJ14gAUQrKVZRDreaqkROrEr8HHsyRy5jROctojxgEBLEGAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976309; c=relaxed/simple;
	bh=0LyybQ1KlVQCjRT1ujmh7SnAjO9XBJi062ibU3ZlO4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uREk+QUvPmWwlUzworjWoUZdfe6agFUHTDVqA+V9s9OPEGAd1l7BtPXpVVI4Yu2/wpvOlEnAl0YrlspO/XZYGT0KrtHwKFAsHWeueo+YOZKE3htMlmM6KU5VcO2pr1tvCXJvYGpQE7/TckjDGlcAacGMVDHwrwQJImmbLNdZbbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIqyqnlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIqyqnlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C301F000E9;
	Mon, 17 Aug 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976308;
	bh=QDEdolEANYxqM1cq6L62ntj81BmkGYhL0xXWzPYyres=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIqyqnluMjm+Ji9Y0V9GhfQAXzaaUV1mHkhAbyeItvJOY65Dnq5Ky4qNRPEmJRVCu
	 Z249+0YQPwF5ZFGoRsPg4WT2t/Bg0uJMc0GgJhrU5VOBqHw9HgoHChkRXpvckd2D4c
	 XUeeBMHUxhjt0vyk83UC5q0V3H3Ji/OuV15i8p1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/389] sctp: fix addip_serial increment on ASCONF_ACK allocation failure
Date: Mon, 17 Aug 2026 15:32:48 +0200
Message-ID: <20260817132551.730408918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit aa2e13ae8d3cbe2c15ef4f7e971b2de0832794aa ]

In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
the ASCONF_ACK chunk due to memory pressure, the code jumps to the
done label where asoc->peer.addip_serial is unconditionally incremented.

This leaves the peer's ASCONF (serial N) unacknowledged while the local
endpoint now expects serial N+1. When the peer retransmits serial N, it
falls into the serial < addip_serial + 1 branch ,
which attempts to look up a cached ACK for serial N. No cached ACK
exists since the allocation failed, so the retransmission is silently
discarded. The peer eventually times out and ABORTs the association.

Move the addip_serial increment inside the if (asconf_ack) block so that
the serial number is only advanced when the ASCONF_ACK is successfully
created and cached. This way, on allocation failure, the serial number
is unchanged and the peer's retransmitted ASCONF will be correctly
re-processed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260804025514.241767-1-l1138897701@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 651fd41996ae1..06309c1869da0 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3316,12 +3316,11 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
 			goto done;
 	}
 done:
-	asoc->peer.addip_serial++;
-
 	/* If we are sending a new ASCONF_ACK hold a reference to it in assoc
 	 * after freeing the reference to old asconf ack if any.
 	 */
 	if (asconf_ack) {
+		asoc->peer.addip_serial++;
 		sctp_chunk_hold(asconf_ack);
 		list_add_tail(&asconf_ack->transmitted_list,
 			      &asoc->asconf_ack_list);
-- 
2.53.0



