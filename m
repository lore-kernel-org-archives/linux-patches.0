Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F550E587;
	Wed, 30 Sep 2026 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785099; cv=none; b=mhzuAPT3DV8CTW+yMYKCrl7At2NEfEOlyawkrjTUqWT5lLAHyRiToVZUeH/G+YHQkZTolgwkwyXRQOrp/VJpiwvwyTheC/Z1BleLovhBPRl7o+z89S+ISEC1FhdX8xo9bQoFh1QECuSAJ9gqWdLhlreGzbcmTJaCsuc9g8QGd6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785099; c=relaxed/simple;
	bh=vJ2lbrK+hGtF0B8FhCp4g/v8KEyHFFg1kasOoLRvWOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYTpUzpbFWhBCn7k3UbI1sRg/w1W2QRarUaylaCRYc7N9rhF43hTvvAAd1t7wSylpqHTYQ2gzNf9l1L0H/YGcTLpCLcbPQHHx6U/S/sBfKICdJyQVAbm+Hka0H+KxUQ8bWLYfjJLZ+GYqRuy4u8+g5nF+1XVlESmDxRB25fduSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxxMgI/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxxMgI/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E6F1F000FF;
	Wed, 30 Sep 2026 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785093;
	bh=P3jgV/sHmxXQhakqVmCcR7/Dy69mnEiLur/d3NYSLKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxxMgI/Cz3kj2dXJCIBcxzL2ZoOIaQ/JBkxJv5OTME2z/kL/k3uoRkoUFYnmQm3dH
	 ZOyiXZsfXhP+Gyl2fHbttLUk8+aYK2z0YIX3zkBd3d2RwL7qszH9I1Q0Xu+RawFJC0
	 X+SUZWny/bi5opL3VYS+KBnWDsAWifi+qk4ivCLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/982] netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()
Date: Wed, 30 Sep 2026 17:18:42 +0200
Message-ID: <20260930152425.098842271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



