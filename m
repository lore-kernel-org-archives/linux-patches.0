Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A15135C69D;
	Tue, 21 Jul 2026 21:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669699; cv=none; b=NBsygn95owEu4j1fPTEjZYuO7nwgXL9HlWpOl/+XtOfvqn22++8mm2yytAxCULoYkwrIm1FB0GKQzPuLn5z2YY+baj3xmHsnpFJZOcUIlWSkP0NFNFtPrL8lgqa9cH3liKRnJZz6DDDhnFvdRcrIEH83r+JCnCUUx0vcsrUdkPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669699; c=relaxed/simple;
	bh=mUVLX2RhNIJlskyhUk39OJMZSOEC/P1lVFkQ4ZByxmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaRGbbixXf1VZh/hddQ5q896EAXw3SbQ0sVmrtd37lypXfIxu19tRC5ZljbVoBZA6TyeV4+vMgSsL1vNqGgW4dFMo8RiaqWUE6SmFxIPLisJFzOMzG85UbSNw69DfiPhCEu+AlkyscHRyulnEU7Ts+ZOu8ogztDs79epINaml/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj6voD0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj6voD0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5FB1F000E9;
	Tue, 21 Jul 2026 21:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669698;
	bh=jnMVsuCysmGX2scJ5NaQiydpVtziVpb84/g9HyT5L7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tj6voD0m/D0K5RCAMlsrIkKR3yg1fzh92CJHuPhnCz7KpnrUYXinOMdW5fU/zUOXh
	 RjgH+Tu2zI2DpZAPivSM8LMhvATjJ+XH4OCctExqmPCBEmvVMF2nDjHmXpVk2AEFUq
	 VgDZJTgZzOU8mMaO2YpL06E7YXYo6H8MM01w862I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0651/1067] seg6: validate SRH length before reading fixed fields
Date: Tue, 21 Jul 2026 17:20:52 +0200
Message-ID: <20260721152439.155604248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit a75d99f46bf21b45965ce39c5cfb3b8bb5ffb1aa ]

seg6_validate_srh() reads fixed SRH fields such as srh->type and
srh->hdrlen before checking that the supplied length covers the fixed
struct ipv6_sr_hdr fields.

The BPF SEG6 encap path reaches this with a BPF program-supplied pointer
and length: bpf_lwt_push_encap() and the SEG6 local BPF END_B6 and
END_B6_ENCAP actions call bpf_push_seg6_encap(), which forwards the
length to seg6_validate_srh() with no minimum-size guard.  A 2-byte SEG6
encap header can therefore make the validator read srh->type at offset 2
beyond the caller-supplied buffer.

Reject lengths shorter than the fixed SRH at the top of
seg6_validate_srh(), before any field is read.  This fixes the BPF helper
path and keeps the common validator robust.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260623-f01-17-seg6-srh-len-v2-1-2edc40e9e3e1@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index a31521e270f785..5a50755ec69f08 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -31,6 +31,9 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 	int max_last_entry;
 	int trailing;
 
+	if (len < sizeof(*srh))
+		return false;
+
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
-- 
2.53.0



