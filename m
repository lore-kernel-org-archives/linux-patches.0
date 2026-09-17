Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299C74DEC05;
	Thu, 17 Sep 2026 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669046; cv=none; b=TM6CmYMqL12twpX4e/3bdPaApBGv9BI0Oa8Ywh7SiySXQL32Q+xRzPso5ZdmXXWFiOvhgeV8U4h9QPGUsblLbO5NsQlghCi+d56AryK/f3V75iIENcAMHKFET+uM/8lyMGEp9CdJD3tuLYkpYYqiNFfmq+25JZP00sdxT6vGeW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669046; c=relaxed/simple;
	bh=/kAmITuLxt/JaYQGe5BUHFEkBOoJBo4MYRP4kl9zVCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbYJ5bTaTUk2ilv82I0vpay25OV2zJCu2b+xdDGd6cN5ViDKJlk8QRO0wJ1miZa3Mo9PGNtbRrvMkFvVaQ1mvZTWlhyoVUENbDyd6LNn3wrmyqsOhw+hjnEFoEsSWsYy8SFGQ4e9sInyafRE+elJNfH0yRItOVPOiHFtd/dPKnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8ZxJan4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8ZxJan4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D5B1F000FF;
	Thu, 17 Sep 2026 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669045;
	bh=1fV4eZX+rwaBTlf239XQkmtn6kl7ckR6RPWGdLHrU8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8ZxJan4n5EkDZ0HEybkcBlJG9XWQgOf6/pEQMR7dDR/lPCjqt9XAR0PfATVbyb7q
	 EbxLeqP8JYQt19O2RRGrvYuVVAzBtzQdE2Qvbza+hlvaw4B26ac5Kb4PsX980IcbMA
	 lE+dxnPC4c+zraOpD9ig8k8HxBC/NwC+7bDLUEHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0625/1102] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Thu, 17 Sep 2026 16:09:28 +0100
Message-ID: <20260917151555.778053553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



