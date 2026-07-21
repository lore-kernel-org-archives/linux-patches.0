Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CDC19049B;
	Tue, 21 Jul 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654587; cv=none; b=p2jtE986rMvhKLtbf2KyQlAS0bCgPOS5KyAgC3+dRkRRRD+J0wE8Bpp9/Z1RA1wUeGxccYPbYItXcOtafiq3vbZ0HLcupqSWdDCpL5gA0sNKcCf5e/aNE6V1ueiIu4wsyixYxZdVTZdayKZ0YqcsnFJu3w1Fo2s+b/GmYz+BJzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654587; c=relaxed/simple;
	bh=wvEWS2P9NVB/FBv8miOExWLwEWZO+EYqEfumb6NQtv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5p83t0ZhQBSLZqTAPelZ+T5Ie4vmOHUQzksNm+09/5MwrT4sn9DSPu7dRcY9lwzhjv+AvhxgOJDYF8ItrEJEG4xnYjaj9zciUcP7tZruwdvk+fZw7hfFwExIMz1WKPXierVo6lpDVlqqaGMLPSPFziXv2d6y9T8OkBMSG/a1WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rLGvgkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rLGvgkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B911F000E9;
	Tue, 21 Jul 2026 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654586;
	bh=OrMcPzEYkDB/DzbCPmD7GQXowvl6py84p/xHXNt/pE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rLGvgkPXCwQFUnl1D2Y49WStOptjhtI508qpU7ncnaWi27JQwQhADncsg42I4nxi
	 5sjG9V8uYEonJ6R4l8VpDiXvdi/Pv3R7Nx8s7djbdnRyud3OKg88YNYfJTblHHlfuc
	 AgQPsyw0fuAcw/lZLzc9kPj3alEvO36ur5PH/BgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.1 1762/2077] s390/pkey: Check length in pkey_pckmo handler implementation
Date: Tue, 21 Jul 2026 17:23:55 +0200
Message-ID: <20260721152634.305205000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

commit 1ac287e2af9a9112fe271427ef45eceb26bce8b4 upstream.

Explicitly check the length of the target buffer in the pkey_pckmo
implementation of the key_to_protkey() handler function. The handler
function fails, if the generated output data exceeds the length of the
provided target buffer.

Cc: stable@vger.kernel.org
Fixes: 8fcc231ce3be ("s390/pkey: Introduce pkey base with handler registry and handler modules")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_pckmo.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/crypto/pkey_pckmo.c
+++ b/drivers/s390/crypto/pkey_pckmo.c
@@ -257,6 +257,10 @@ static int pckmo_key2protkey(const u8 *k
 				goto out;
 			break;
 		}
+		if (t->len > *protkeylen) {
+			rc = -EINVAL;
+			goto out;
+		}
 		memcpy(protkey, t->protkey, t->len);
 		*protkeylen = t->len;
 		*protkeytype = t->keytype;


