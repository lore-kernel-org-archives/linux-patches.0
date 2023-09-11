Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8D611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F36C433C7;
	Mon, 11 Sep 2023 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444287;
	bh=8rz3qbjCtF6bxOZw6kMuBVsYqPLdHVkSaNaO9UFUo18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMHNQie30Yp9DVzAC5nO3QF0Fwiuj9mAb4PFzrdBapKyRp/Jk0rP7uh2voxroYZAK
	 tT428tTgl6QdXkjgv4xGIwVxaZtgwzoHG/e4RepZsveQfF2Rm8ph4HS3tB0VTaIytJ
	 /a4JdlVZMU+IBOBEYiebXi36SRSrdC29szZ01fH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Leong <wmliang@infosec.exchange>,
	Wander Lairson Costa <wander@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.4 639/737] netfilter: xt_sctp: validate the flag_info count
Date: Mon, 11 Sep 2023 15:48:18 +0200
Message-ID: <20230911134708.380785263@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

commit e99476497687ef9e850748fe6d232264f30bc8f9 upstream.

sctp_mt_check doesn't validate the flag_count field. An attacker can
take advantage of that to trigger a OOB read and leak memory
information.

Add the field validation in the checkentry function.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
Cc: stable@vger.kernel.org
Reported-by: Lucas Leong <wmliang@infosec.exchange>
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_sctp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -149,6 +149,8 @@ static int sctp_mt_check(const struct xt
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 
+	if (info->flag_count > ARRAY_SIZE(info->flag_info))
+		return -EINVAL;
 	if (info->flags & ~XT_SCTP_VALID_FLAGS)
 		return -EINVAL;
 	if (info->invflags & ~XT_SCTP_VALID_FLAGS)


