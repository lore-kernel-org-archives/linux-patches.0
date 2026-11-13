Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585518;
	b=mpa6ZSyfEI6G+nx60asqbcMfSWpBjgBcmHFPkTsyT42/1eWxOkG6NOJYUz4Z4ED7mF4O
	 56S5JnAPYGdGv3TDfxUKTLFfvA2uFQNkFzUodri3pPeDO5EWilwZqyU5XAHykMCrUvr0O
	 rYwd0zDAkPtahpzx6eds1/BMU2PNtZwAQVH6fUJRxcMpSNKJzDGHBF5Xe2SMSIKWpWndW
	 vxHdh7TgKD193F8UVDOfcadeczdYG5GZ2UP704SFIN7KnSXCI2kBh+6v2GJBPc2uHAnlS
	 d3eE2UJOvHDd5Cdv7rGNPwCohYMDsXSEIGuQVCEsaNpr5tC3T4xhOIokf0KmIjMGqxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cHQwQebnIkZV02MIZ/5c56vcigaeLakX79DysD2nfg=;
	b=DTrdM7CFHYdtzsKkjqVi3i5CWkq+44p/ToKmseqS1T4S8F9CEVRz1pISayGT8nNgcDbq
	 byOj9CTDleAkg3uCaNNI58JsxFDRtf5TCJjPnw0IQs6yyqVzXcFtfSy7jqo37fAE0PyCe
	 QKyf6HOgGNQi7rarc9mmNue/SJR7FUojZCXqSFb0ybwMcTreAQu2cncaE3YrfojwQQTlp
	 1/o6BYjKpamQ2tcXByjEub2liPZuwmN/Go6pJWmkbBpKYabkhp17L7UMreOZh2kfFVraJ
	 mfdU2JDzSYRrhbuMdvyQQbs5jlhHAYnXBSRYCQwsBifkiI15eqURhGGIm60dSk6QNsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4ll3AQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC59606AE3F;
	Fri, 13 Nov 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4ll3AQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1787B1F000CA;
	Fri, 13 Nov 2026 15:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585518;
	bh=4cHQwQebnIkZV02MIZ/5c56vcigaeLakX79DysD2nfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4ll3AQLv3ZFGn+tftzDVo2EbOPcOQJubMcVGH+kM9GFlxcsh2hZOBGF59jK3f/Jk
	 Tx0xt8zvdsZ6gVv03TcOoUaHQ2A8lRuHn2WBT3pZBNZxtesx4WHhfySpoBaSDBVPaR
	 m5vYGGWqNkpnaz56BW+mvN0pqRXKx2v3E7bYpX8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 162/507] cipso: fix optlen corruption in cipso_v4_delopt()
Date: Fri, 13 Nov 2026 10:47:46 -0500
Message-ID: <20261113153759.988155846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 1f1f8e8c5176234fa31858cd25f2e9b88aac0a45 ]

cipso_v4_delopt() recomputes the option length by walking the option
buffer after the CIPSO option has been moved out.  The walk then reads
the stale bytes at the tail of the buffer as option data, and a crafted
setsockopt(IP_OPTIONS) buffer can make it treat one of them as an option
length, increasing opt->opt.optlen beyond the valid option data.

The corrupted length stays on the socket and is later used as the copy
length by getsockopt(IP_OPTIONS) and by the udp/raw/ping sendmsg paths,
where it exceeds the size of the buffers they copy into.

Compute the new length from the intact options before the move and
subtract the CIPSO length, and fill the padding with IPOPT_END.

Assisted-by: LLM
Fixes: 014ab19a69c32 ("selinux: Set socket NetLabel based on connection endpoint")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 1aacbbeffbc64..e65a3f29d2caf 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2013,6 +2013,10 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		cipso_ptr = &opt->opt.__data[cipso_off];
 		cipso_len = cipso_ptr[1];
 
+		optlen_new = cipso_v4_get_actual_opt_len(opt->opt.__data,
+							 opt->opt.optlen);
+		optlen_new -= cipso_len;
+
 		if (opt->opt.srr > opt->opt.cipso)
 			opt->opt.srr -= cipso_len;
 		if (opt->opt.rr > opt->opt.cipso)
@@ -2026,11 +2030,12 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		memmove(cipso_ptr, cipso_ptr + cipso_len,
 			opt->opt.optlen - cipso_off - cipso_len);
 
-		optlen_new = cipso_v4_get_actual_opt_len(opt->opt.__data,
-							 opt->opt.optlen);
 		hdr_delta = opt->opt.optlen;
 		opt->opt.optlen = (optlen_new + 3) & ~3;
 		hdr_delta -= opt->opt.optlen;
+
+		memset(&opt->opt.__data[optlen_new], IPOPT_END,
+		       opt->opt.optlen - optlen_new);
 	} else {
 		/* only the cipso option was present on the socket so we can
 		 * remove the entire option struct */
-- 
2.53.0



