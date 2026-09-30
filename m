Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5343EC6A9;
	Wed, 30 Sep 2026 19:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795166; cv=none; b=LUxQPWFSAJGgGWd357foayuGlSBsSUPPwYTq6L6gTh4D7cmWhcdIHVOvffyrqvEk4gkz4PZS0r03/vhbt51YDtsFLCeSYBZHTczvK7l4rIu0spHY2Zci2oywUt6fWPeeQWvUsS+6EYctnJ0J8Lc7cQg2EMHJyZYjIUH8gfX75i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795166; c=relaxed/simple;
	bh=QAHtdWFiNMVzAsc3MnP4c8H1/yXZ/yvd5q6Cv4iwNdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbe73gsyZQ5iTNGo9tTT/BY+dgPjRBYI6A8oUjweM9tNbNne4sNKe1Lz6yTTpgCzA6pGGlEj7eAYgIF5p6/4S5myjPdBMVoGktPE+qqvQAaqvAujcIBWm/4cgbdB8m+Bot0Kxt1UHNJjJoqur1vPDIgXHww4brvMz1oFZUD4WoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbeTgNm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbeTgNm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A1E1F000FF;
	Wed, 30 Sep 2026 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795165;
	bh=zUNb+K/6/JfAzvmq4FoKyjOYQTWXuBx3j2EeDPn/Hkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbeTgNm5k34HgIkaDaurMuvZYGFGRkzvB1kC7m0zc5jnfmEiRh22RlOJPBjHPMS03
	 RA9v/5jsS/Cv+dNH64JgPtr2/V8zZR4es/NOhmbopfhgk2n73kSlFoXzuHDEhElIqL
	 akC7PAHYVoQNrXb4Rhw25Yj993CFkI1+HthkdelE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0464/1193] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Wed, 30 Sep 2026 17:19:08 +0200
Message-ID: <20260930152444.481141343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit e8f8231824b5815f57ce62cba116e511b10196de ]

sip_skip_whitespace() returns dptr unchanged when its own loop
exhausts the buffer (dptr == limit), instead of NULL like its sibling
sip_follow_continuation() returns on its own "no more data" path.

ct_sip_get_header() only checks for NULL after calling it:

  dptr = sip_skip_whitespace(dptr, limit);
  if (dptr == NULL)
          break;
  if (*dptr != ':' || ++dptr >= limit)
          break;

so a recognized header name followed only by spaces/tabs running to
the exact end of the SIP payload, with no colon, makes the very next
statement read one byte past the buffer.

Make both "no more data" outcomes return NULL, matching the
convention sip_follow_continuation() already uses and that both
existing callers already check for.

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4f975b83c84f6..2b5f807436e2c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -429,7 +429,7 @@ static const char *sip_skip_whitespace(const char *dptr, const char *limit)
 		dptr = sip_follow_continuation(dptr, limit);
 		break;
 	}
-	return dptr;
+	return dptr < limit ? dptr : NULL;
 }
 
 /* Search within a SIP header value, dealing with continuation lines */
-- 
2.53.0



