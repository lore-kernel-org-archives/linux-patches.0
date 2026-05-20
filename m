Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB423EAC82;
	Wed, 20 May 2026 17:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296404; cv=none; b=fVZbkdjJlUtHCJCFYra0GU7rkZFneAlPbFqaBfhTiwJNA5/DOfXGnRlPC8vmT2PxX/X1lbtlv4fnl0KC5894j0yYjmdF997oPaaM2UtM4M8PWggmimy0E7c3S6XHrAKX+9I4GWcJB+kLClm7V7gElWL7w8D8hCkBaZVvk6ULUMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296404; c=relaxed/simple;
	bh=TINbdzr9lMUREPk76aCLX5BKU0XyWYFXYPba7aBGyiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiEd+l8r/btOK80VaO/XbTsHUVc0eKWiS00TWsBdbuj+N5d9ujLqqERzM3OgRHpD8sQ7vi9QZYNfianT598VUaW8TMenXCwXwGqtqSopfP11eaWCyMHPb99RkoqBNGiWQZbdh4mNuK1So/ZJp5TjP1PtW4w+/WkSwzEIP1mVpcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ujhlcgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ujhlcgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104931F000E9;
	Wed, 20 May 2026 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296400;
	bh=zMR2ziScSuoymNoLBZI7kOUTpIOAK0GUHLC4ZeJlDXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ujhlcgxDQptueaxqmaj8T217yXuOmm8gatuICubAze3G+FT8/PD9Hzoq1aStEd2M
	 6tN/SjL588pcpgF46FC/+WDQCEmUKmKV0Yrbaoa3YkbJD11/rBEy4CDTQzCZARLsOD
	 ul7oZxLZbqU2PIPc6NWLHLxMNffyFFUzA2CuJoLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0778/1146] tcp: move tp->chrono_type next tp->chrono_stat[]
Date: Wed, 20 May 2026 18:17:08 +0200
Message-ID: <20260520162205.822857293@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4b78c9cbd8f1fbb9517aee48b372646f4cf05442 ]

chrono_type is currently in tcp_sock_read_txrx group, which
is supposed to hold read-mostly fields.

But chrono_type is mostly written in tx path, it should
be moved to tcp_sock_write_tx group, close to other
chrono fields (chrono_stat[], chrono_start).

Note this adds holes, but data locality is far more important.

Use a full u8 for the time being, compiler can generate
more efficient code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20260308122302.2895067-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 267bf3cf9a6f ("tcp: annotate data-races in tcp_get_info_chrono_stats()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index f72eef31fa23c..c44cf9ae8d16f 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -228,8 +228,7 @@ struct tcp_sock {
 	u32	sacked_out;	/* SACK'd packets			*/
 	u16	tcp_header_len;	/* Bytes of tcp header to send		*/
 	u8	scaling_ratio;	/* see tcp_win_from_space() */
-	u8	chrono_type : 2,	/* current chronograph type */
-		repair      : 1,
+	u8	repair      : 1,
 		tcp_usec_ts : 1, /* TSval values in usec */
 		is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
 		is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
@@ -264,6 +263,7 @@ struct tcp_sock {
 				 * total number of data bytes sent.
 				 */
 	u32	snd_sml;	/* Last byte of the most recently transmitted small packet */
+	u8	chrono_type;	/* current chronograph type */
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
 	u32	chrono_stat[3];	/* Time in jiffies for chrono_stat stats */
 	u32	write_seq;	/* Tail(+1) of data held in tcp send buffer */
-- 
2.53.0



