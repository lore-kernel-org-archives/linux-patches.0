Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3D97DA7D;
	Thu, 15 Aug 2024 13:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730313; cv=none; b=aVJC7XkbgUSJicThwfBqfAVfcWBKGKrhCiRQdEv2XPoZMUFQYohALVR18fLTbvhZOPEpgt5n6T7ZKzn7IYSXv0TZbW/Dp7q1lzXavdRo1i51HCA81EvgNH5SYDtyWJl7PtjgVfeenhiyQt4V39xprz38IQSBKNbEXH7l/NkicLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730313; c=relaxed/simple;
	bh=rLALTX5ZYjD8ckO/+ATdlyAd2XpTQQON8DAX7LGlXSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtLKHKW9jdwAn5Lt3BpjQmxuRbb2De+z40n3+PsaOhYAVqWzsWp4bsAQKKsn4DQrTh+u3ibER2Yta4FQkhz74+/o+hKbSkdn97DMPRxPnJf2ZxftnYZ/dzbr9xWeBLH6BfMVFhgzuQp0b6Hz8c0X3QDTVEfSBMhgsaQDh1U+DXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfJKh+m9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfJKh+m9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6844C32786;
	Thu, 15 Aug 2024 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730313;
	bh=rLALTX5ZYjD8ckO/+ATdlyAd2XpTQQON8DAX7LGlXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfJKh+m9Lv4v5w9fWGss40zchlBSkCUcOW+nTAKGQWr0SVa2/TpK8yz+LT/Iypxbr
	 Jq0F1HBqExgIAaumb10gDTM4qv9Ygzri63P4H5sLEIBIdyboVczSNUWMcGetiUCJvB
	 6BItsifNabp7w2ZWktkrJpwcX6QHkiN6zEWQULh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jen Linkova <furry@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	Patrick Rohr <prohr@google.com>,
	David Ahern <dsahern@kernel.org>,
	=?UTF-8?q?YOSHIFUJI=20Hideaki=20/=20=E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E?= <yoshfuji@linux-ipv6.org>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/484] ipv6: fix ndisc_is_useropt() handling for PIO
Date: Thu, 15 Aug 2024 15:23:17 +0200
Message-ID: <20240815131954.506467757@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit a46c68debf3be3a477a69ccbf0a1d050df841676 ]

The current logic only works if the PIO is between two
other ND user options.  This fixes it so that the PIO
can also be either before or after other ND user options
(for example the first or last option in the RA).

side note: there's actually Android tests verifying
a portion of the old broken behaviour, so:
  https://android-review.googlesource.com/c/kernel/tests/+/3196704
fixes those up.

Cc: Jen Linkova <furry@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Patrick Rohr <prohr@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Fixes: 048c796beb6e ("ipv6: adjust ndisc_is_useropt() to also return true for PIO")
Link: https://patch.msgid.link/20240730001748.147636-1-maze@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 856edbe81e11a..d56e80741c5ba 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -226,6 +226,7 @@ struct ndisc_options *ndisc_parse_options(const struct net_device *dev,
 		return NULL;
 	memset(ndopts, 0, sizeof(*ndopts));
 	while (opt_len) {
+		bool unknown = false;
 		int l;
 		if (opt_len < sizeof(struct nd_opt_hdr))
 			return NULL;
@@ -261,22 +262,23 @@ struct ndisc_options *ndisc_parse_options(const struct net_device *dev,
 			break;
 #endif
 		default:
-			if (ndisc_is_useropt(dev, nd_opt)) {
-				ndopts->nd_useropts_end = nd_opt;
-				if (!ndopts->nd_useropts)
-					ndopts->nd_useropts = nd_opt;
-			} else {
-				/*
-				 * Unknown options must be silently ignored,
-				 * to accommodate future extension to the
-				 * protocol.
-				 */
-				ND_PRINTK(2, notice,
-					  "%s: ignored unsupported option; type=%d, len=%d\n",
-					  __func__,
-					  nd_opt->nd_opt_type,
-					  nd_opt->nd_opt_len);
-			}
+			unknown = true;
+		}
+		if (ndisc_is_useropt(dev, nd_opt)) {
+			ndopts->nd_useropts_end = nd_opt;
+			if (!ndopts->nd_useropts)
+				ndopts->nd_useropts = nd_opt;
+		} else if (unknown) {
+			/*
+			 * Unknown options must be silently ignored,
+			 * to accommodate future extension to the
+			 * protocol.
+			 */
+			ND_PRINTK(2, notice,
+				  "%s: ignored unsupported option; type=%d, len=%d\n",
+				  __func__,
+				  nd_opt->nd_opt_type,
+				  nd_opt->nd_opt_len);
 		}
 next_opt:
 		opt_len -= l;
-- 
2.43.0



