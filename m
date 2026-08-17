Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A73D8105;
	Mon, 17 Aug 2026 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974892; cv=none; b=YzLgfdYqhiZDpZZzLwLUKUnTsrgX6wsyS4f1vXUgCRjNX0V0H2zWrCfOoe3tiKC0Tnkl3AK3srHoYMr4xCC7zXhHNxI0mvIRLaxdWP9FPyf+vJ5oiVgf5JceX4C3XdRGq40si3/uMl+0YvVPetd80gvdj7s/vmynDG2HN7cLiXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974892; c=relaxed/simple;
	bh=ofca9XGz8jSoBp8ckxxziTMpBBqPTJyfW2YaNzSRr58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oONK88zl6b+VnOllMqfU5w4LRYPYEycQxXtfEadxe/VLTXo5Xwfo/Ckp66DuQ1pFef/SLn2x93Ra5skIXD+1JweV86aVFNit5cPmPEupXyeC1G+e1g0ftEMTGTydkoYxsl8B7osxoeol6Tg3oOo4A+lTqB+1Sw3gasg+8SQhrf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bchxB1f1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bchxB1f1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3EF1F000E9;
	Mon, 17 Aug 2026 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974889;
	bh=FerI9sCtc29rQ7FJeDSUtxZm4KeE3bcGEyottcNaDA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bchxB1f1oP6gYMLP/AGF+0fgm+psMKJtPz43OvyxMCXloz2TgU6Wq5pXg9xZUM+vA
	 3ryqUYDG/qvbvDntoLAoI8Yv6tt6dJJ36bDgDl57TitfXX1ewNavbR1GcM178E/xst
	 Ibo0fzviXU2EsMCJD/JIsrsKpbGYIyoy4ecvUJnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/250] sctp: fix addip_serial increment on ASCONF_ACK allocation failure
Date: Mon, 17 Aug 2026 15:30:50 +0200
Message-ID: <20260817132540.117787413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 721e147091a97..757aff3e917dc 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3336,12 +3336,11 @@ struct sctp_chunk *sctp_process_asconf(struct sctp_association *asoc,
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



