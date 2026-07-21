Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3DF3AEF58;
	Tue, 21 Jul 2026 22:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673999; cv=none; b=t/DTxcuf2c5ZDno5+gFvfwdkR23sYp26e915qmwP5m19LvLzNgGRPqDw6noX9tN0Ck4JlbiPOactYzsi1HDetGSHU9NY+cEJLLChmLY71LP9O6QPk6iAMACN2n5SGdwb7Ffl+AtFxlW797RJg8Cvzu3hS6RDA08YNTEAZoJ4RO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673999; c=relaxed/simple;
	bh=tURhZePyzAnae0Wi7XUVc8OVcAQwLO+MAELtoUxV1iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3/sNB/9STlFT2nZ6ntHvtJD0/tgy+iLF0ed2BTHYxTwZxN+1JSFUHpzP/M9TkhzLTR91vaj/PbchWRDcMpiWhoycrjxRiNm2RtnRzc+CEt6DTu2AY1VpUJHL3GHQ+K2vPSe8PbuO92Glsr1tIobKQub8eTkqw4YDYJaX3GmHDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpXlF4cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpXlF4cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3098E1F000E9;
	Tue, 21 Jul 2026 22:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673998;
	bh=LAqqyfjBtKfFe7KBYRohS0kq8DANqmZhR6I5Z9ly+5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpXlF4cwAZ8ANjQi/2c1aftr6ikLDPf6Pz+D/KPscm3yBmpwg9nP+CYxJPFEksskH
	 WS7AxenJC8PzoYrn0y+Rv9t4lZErZTVQ5PDJ/L365qiWJ2xcmVrAr/PCgi9jKtONuM
	 voBSxHIYOaPoEAL9yMf5Bavw4P/v3MVCsaAKtYgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/699] seg6: validate SRH length before reading fixed fields
Date: Tue, 21 Jul 2026 17:22:15 +0200
Message-ID: <20260721152404.175173064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 77221f27262aaa..cb494c67c94445 100644
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



