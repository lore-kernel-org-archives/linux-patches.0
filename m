Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B0736F414;
	Mon, 23 Mar 2026 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274863; cv=none; b=DpsbGzy8AnXvpqMwKXI8BFyoRTlT7pp9hqhK/ZtJX5oRZoC/Bj4/H0iy//+uFIC/eLoGt6aYWByPvx3/5Ri8rA03mxj2szWqScGO8IIbBIqONTzdqd0EGxvtLyIlSRpcB5AFKCWlakauRt0M+ZefgTGHFupxg8ZaqV/x5JCcFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274863; c=relaxed/simple;
	bh=Y9hnJvaRUzAx89XnlU56jfqrV6/f4Xhv7HcVCnDcbHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSllIuQTc+bleGEQd/bYcvS3O/TgrELJB0AgBUQBhvQ2j4mGNJ1bctQ1pVprxRGUSbp3U31+TwQ83R2NbFBEU4WQHs9X5NkziTGor4Q5d/xfcS/ekxUJsImTbCuQScufH2XlRPklTNPbqFxGNkrCNy7lJbJeCI61vH0ZLADKNws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HX3ZSy5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HX3ZSy5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20686C4CEF7;
	Mon, 23 Mar 2026 14:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274863;
	bh=Y9hnJvaRUzAx89XnlU56jfqrV6/f4Xhv7HcVCnDcbHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HX3ZSy5DBR1WgsiK7N5gqIkAt64QGHBVNXf8xEiCZtgS/FamNFSgoCJJgQ9bzT+TU
	 VotsYj8ovUCggafhzMdJ4IPizRvIfMdZKNq9BXXHZhp34pRdTUVko2Lv5kb5wXInMZ
	 zxM9iNNj76p1Ww9VZTW3r/uiQDcpWJa4AyfRdLKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaudia Kloc <klaudia@vidocsecurity.com>,
	=?UTF-8?q?Dawid=20Moczad=C5=82o?= <dawid@vidocsecurity.com>,
	Jenny Guanni Qu <qguanni@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/212] netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
Date: Mon, 23 Mar 2026 14:45:57 +0100
Message-ID: <20260323134508.067301563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenny Guanni Qu <qguanni@gmail.com>

[ Upstream commit 1e3a3593162c96e8a8de48b1e14f60c3b57fca8a ]

In decode_int(), the CONS case calls get_bits(bs, 2) to read a length
value, then calls get_uint(bs, len) without checking that len bytes
remain in the buffer. The existing boundary check only validates the
2 bits for get_bits(), not the subsequent 1-4 bytes that get_uint()
reads. This allows a malformed H.323/RAS packet to cause a 1-4 byte
slab-out-of-bounds read.

Add a boundary check for len bytes after get_bits() and before
get_uint().

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 62aa22a078769..c972e9488e16f 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -331,6 +331,8 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 		if (nf_h323_error_boundary(bs, 0, 2))
 			return H323_ERROR_BOUND;
 		len = get_bits(bs, 2) + 1;
+		if (nf_h323_error_boundary(bs, len, 0))
+			return H323_ERROR_BOUND;
 		BYTE_ALIGN(bs);
 		if (base && (f->attr & DECODE)) {	/* timeToLive */
 			unsigned int v = get_uint(bs, len) + f->lb;
-- 
2.51.0



