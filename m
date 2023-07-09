Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDB6522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00323C433C8;
	Sun,  9 Jul 2023 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901889;
	bh=k2CA7rI2ZOVYfokyffwdv1fmht2eZusReAvJvYCjrT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYnqlVjg/W1j4IHZ6NPpdojoZjNimIFoQW1jp/FKmuv77obHfJtajd6qOQuqTWMe+
	 TJYNNUI9kp4ut8KgFRHJu2JE05M6dXV7dTGCOf+VzYXvXkYuMlmmpqIB8pDEtIQ6PU
	 fRgJX/3+GIPUJYL/DDeOeEbqKJvgLm4WOMmdbTpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 153/431] netfilter: nf_conntrack_sip: fix the ct_sip_parse_numerical_param() return value.
Date: Sun,  9 Jul 2023 13:11:41 +0200
Message-ID: <20230709111454.752871510@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit f188d30087480eab421cd8ca552fb15f55d57f4d ]

ct_sip_parse_numerical_param() returns only 0 or 1 now.
But process_register_request() and process_register_response() imply
checking for a negative value if parsing of a numerical header parameter
failed.
The invocation in nf_nat_sip() looks correct:
 	if (ct_sip_parse_numerical_param(...) > 0 &&
 	    ...) { ... }

Make the return value of the function ct_sip_parse_numerical_param()
a tristate to fix all the cases
a) return 1 if value is found; *val is set
b) return 0 if value is not found; *val is unchanged
c) return -1 on error; *val is undefined

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 77f5e82d8e3fe..d0eac27f6ba03 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -611,7 +611,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
 	start += strlen(name);
 	*val = simple_strtoul(start, &end, 0);
 	if (start == end)
-		return 0;
+		return -1;
 	if (matchoff && matchlen) {
 		*matchoff = start - dptr;
 		*matchlen = end - start;
-- 
2.39.2



