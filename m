Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532D247C0F8;
	Wed,  9 Sep 2026 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961740; cv=none; b=cbOUU6y9kAZz/4EzVKGfhagu8GyZeDf2ks9ZFHgDPjsUL9EcESjAvCFyUj8rPnml54SbKeysow7NGd799wbhqW0mTmsV0KmISS6uFbh8jgFdn4lVGgD6NfrLe7c0EZxrYiuJrSEdf2ficHB7JGsA2lRPl9YB3UIGSB+exr6QZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961740; c=relaxed/simple;
	bh=iUL3aI7wTr0wnD6JV6fRMiOsMfypnIdh6XqvXP/pAwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDFECfapOh8+QjnvPvx6Ce9aJmCBDt3XFhoIaiKHmRrLaB6rU6OSf3vW4Fs/kC6hM93Jf+V7GeSLssULi6NZgJEYXQ6nltS4KqMgZPNA76Sl6isyu/YYCK00tKn7wBWOzw+kYRnDHwCs1KMLRwtslsv0yM/ReAoGid8nw/o3WjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaB+HzI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaB+HzI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94071F00A3A;
	Wed,  9 Sep 2026 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961739;
	bh=n++kCYkakQ9FCcnterS3HBlEP6Ow+dCV+aJwDuDGi60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaB+HzI8l1gyxj1FLvwCi1Y2yy/s2ogTNQa/bYOyUvN4g/JfV/6Bn6CFlx4OKiJCh
	 h/R0FkdRw5cr7hN7xqfDSPobKr88i+hxLpKrY94J/Fsjz1kNzlMUalu+fihhmiJ+RS
	 WNbV9YVf1aADgZgPDha34ks0Rx9QVQVTkzhabMII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 7.2 052/556] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Wed,  9 Sep 2026 15:35:32 +0200
Message-ID: <20260909134232.305368019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit 28a289beaf226b30b1e6e7d7b1a2946fe2d6e852 upstream.

rtw_restruct_wmm_ie() scans in_ie for a WMM IE with:

	while (i < in_len) {
		...
		if (i + 5 < in_len && in_ie[i] == 0xDD && ...) {
			...
			break;
		}
		i += (in_ie[i + 1] + 2); /* to the next IE element */
	}

When the "i + 5 < in_len" match check fails simply because i is
within 5 bytes of the end of the buffer (i.e. no WMM IE was found
near the tail of in_ie), execution falls through to
"i += (in_ie[i + 1] + 2)", which reads in_ie[i + 1]. If i == in_len
- 1 at that point, this is a 1-byte out-of-bounds read of an
attacker-influenced IE buffer built from association/scan data.

Commit a75281626fc8f ("staging: rtl8723bs: fix potential
out-of-bounds read in rtw_restruct_wmm_ie") added the "i + 5 <
in_len" guard to the match condition itself, but did not add an
equivalent guard before the fallthrough advance, so the same class
of OOB read remained reachable through the non-matching path.

Add an explicit bounds check before advancing to the next IE.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-4-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1980,6 +1980,9 @@ int rtw_restruct_wmm_ie(struct adapter *
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 


