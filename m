Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80C19EED2;
	Thu, 15 Aug 2024 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728833; cv=none; b=ZqOWlsOxPoRfwWHoXzptrTH//ATdmCKC/N0zCNvhYXT+XteuSu3SqllqynpatyejL+erY8+eFkg9AREKiemMwwHQHdC/oYj1BWu575lqpe3l8DdsvfvCjaYobph15bNunRf9iluVNAD5/DbrBrJu//acdoFR64uPEflJr+9sc8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728833; c=relaxed/simple;
	bh=h7iZ2mQ0fXDoyyHop0ETSKUqP9IsnetMP0qgyyg+kZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCrbgJeg34GtXSu/0v1wgGQQ2m3XaHuujMQ/bA9HX/hCe34tgAfZHdxGzY2R+lhe+uL8/flz76cO9nN5KZrn6gBjRqQ7nw/KLzHG1TkaC52Q4GCvOVtL6TLhuMKx4XvYHh65BB1L3Da/NNTZoXQPRyt5Mtrw2OklO4q4JC9DR+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtK0lPfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtK0lPfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF4CC32786;
	Thu, 15 Aug 2024 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728833;
	bh=h7iZ2mQ0fXDoyyHop0ETSKUqP9IsnetMP0qgyyg+kZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtK0lPfzbaJRW2cBDeYlQsg/Z4HvPkfQ9FJDgOIUZvzlwYv+GjdY95VT5v/xFimvq
	 Xc+xjYU45uHKuG2voUJ/b4lIVCKTyP4VGDjINGACC8a53FPttL+owiw48/fCNn9Qm/
	 HbTUT2j6+CDXlr1xOJ0yX6K7mIlqLEhAMLZRxcYk=
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
Subject: [PATCH 4.19 125/196] ipv6: fix ndisc_is_useropt() handling for PIO
Date: Thu, 15 Aug 2024 15:24:02 +0200
Message-ID: <20240815131856.857105431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv6/ndisc.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -223,6 +223,7 @@ struct ndisc_options *ndisc_parse_option
 		return NULL;
 	memset(ndopts, 0, sizeof(*ndopts));
 	while (opt_len) {
+		bool unknown = false;
 		int l;
 		if (opt_len < sizeof(struct nd_opt_hdr))
 			return NULL;
@@ -258,22 +259,23 @@ struct ndisc_options *ndisc_parse_option
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


