Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A134F279;
	Tue, 21 Jul 2026 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656320; cv=none; b=qYWOOIw5PuEvTF6r3vFwk04Id0GM/Ey01VI4x8itryYs2YT0JPY6DTBPZTeLVL4G772Ygl5Fwvqt/wBjqvzC0XuL7o1LDSU1ulFhHYy6+i+FE3Kp65VZn767k1I1sSnYHVa82T5fqXQjb8+cRsmFEVxfaR+W8MLa3o6yLOuXC18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656320; c=relaxed/simple;
	bh=TNRKl0FjH/WrnOVIy4hTDLWk+L9UYyzrOhGgdsbtF4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm3TmZI6PLyb/dYF0kyVM5mJYcM8PEvMwlBrSlJhPG2Yw/bTxhhUQYdJuksU1vyRhHBiwL4UJpgCVja9hzvlhrM0OZashs22knPivInchuBxY8UfnoYym//M1JBFUmfuaF83VQWIC9ONG+lBBT7VbQHKz8TBrf4KnKGH6HU5pnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp1DAfmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp1DAfmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A37C1F000E9;
	Tue, 21 Jul 2026 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656317;
	bh=sOq/DaqqrLb6Xc3n4DhFqjRhSSt74MUFR+sS5s3cymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp1DAfmd9WehJO49etlhv+3NJ9qrz1rAxhR3UXrY0yR9nNhbwK5xul+7uT4J+ZpNB
	 nWLag6rFA3dIcF0YrsZso52IFNbMDx9cNKp2dVsZwKHZ0duBw57JrUPkMVA5z/CXVu
	 /tPyIiLk+2XRvuFuvDQjY+DZq9YNCb6+FwSOveAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0343/1611] netfilter: synproxy: adjust duplicate timestamp options
Date: Tue, 21 Jul 2026 17:07:39 +0200
Message-ID: <20260721152522.838361719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22bb132cfb9b94847d52d73614284b8c5ea8d36e ]

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index a90511238ec378..3c021fdec2b574 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -232,7 +232,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



