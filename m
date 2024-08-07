Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7CE82D66;
	Wed,  7 Aug 2024 15:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043135; cv=none; b=pmwYh5iGOzSoWcGr4sJ/ayBHM/VkvBWTS0es87JTPUDb7Gk1p2nn4UDqA6Xge7qL3/gKsSsQeD9vJsSk61gEdKVpp5ZeX7VQJvUl3nJaVR3Zyhgds2JOVKf5iOg8obJ8QAZkQFF9eED5cIIqpsEZg//z/bEj2SsAGUZOJpPJYLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043135; c=relaxed/simple;
	bh=x/HMPpBpsy/eTSkuRf25RK78XNQAhVsgBUpq0VyHLv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ft2ymELXjo0EmNgO/YMZwqcwQ73ojVRiyofSAyNt2HKLLY+zX3rY/P+/5G6Nvu9Bni9jy78VpyD6ga2QsHPpLWy8Jco4QpnftwGyGPeMlQ2Q9slDKbxaIopNJBzrKH+IwJwAphwZlAwSZUqE18iWLY24/Df4FDVY1rIVcHckfEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJIurKkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJIurKkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE6BC32781;
	Wed,  7 Aug 2024 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043135;
	bh=x/HMPpBpsy/eTSkuRf25RK78XNQAhVsgBUpq0VyHLv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJIurKkXC9KGxM1/DCn646j56pYHRXolGNgyw2JlMl+ZiYDxTAjPjWtHSAmKKXSez
	 ZKZ/irW9GB2iVRSwCPaOwPru8seHwDmjdcXinNQSP4QS2Zyz7FeKbTTDb90N6/H4wL
	 bLJIPBNRBTprlySrLuWZ1Yjak/OMjQVpxfiCQ+3M=
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
Subject: [PATCH 6.10 067/123] ipv6: fix ndisc_is_useropt() handling for PIO
Date: Wed,  7 Aug 2024 16:59:46 +0200
Message-ID: <20240807150022.963573788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d914b23256ce6..0282d15725095 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -227,6 +227,7 @@ struct ndisc_options *ndisc_parse_options(const struct net_device *dev,
 		return NULL;
 	memset(ndopts, 0, sizeof(*ndopts));
 	while (opt_len) {
+		bool unknown = false;
 		int l;
 		if (opt_len < sizeof(struct nd_opt_hdr))
 			return NULL;
@@ -262,22 +263,23 @@ struct ndisc_options *ndisc_parse_options(const struct net_device *dev,
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



