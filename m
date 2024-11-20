Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C1A1AB6FD;
	Wed, 20 Nov 2024 13:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107702; cv=none; b=MTpeJPlOjA0/5jpS5eSCbR7poFOCX4h30wfIWEhu1u+uLskGB8eKcjMVRCUgHjkCTkyeHEA+DHvMhXN+u+Mx6kzsmFB54uGnUED3FMTBwKZtVGAOFkSc1hpoGRiamN55imJm2OF5Xi+tu+zhcgsfnJpEoCT7w0yNJicS9LhFya4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107702; c=relaxed/simple;
	bh=yVjI7VfFE+U78TzQ1SQmw65dN9Sfgcg+PCL0YoIvck0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8l003jcBYzgm5Y9K26YZFWRTz2q/cgiubZJbMLli7wMXMZCoQVsq89MOANpG+eKdX5vna34vcJ4tvuAtpsiiqu6VIjPNnI7yKv/dPP9wAEV+3AI1XaGQZRwZF5pgVqIWHJ3qp8oRy31RHtUwDRqPIXOc/VROhrzPSyY0VlZ2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELdOsY9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELdOsY9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8061C4CED1;
	Wed, 20 Nov 2024 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107702;
	bh=yVjI7VfFE+U78TzQ1SQmw65dN9Sfgcg+PCL0YoIvck0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELdOsY9v5alLxgzCopYGEVjGiT4nHy6X6fAQST17DnWUxTrDzBqXOtDEygkCnjtBQ
	 Ya6mJCdtprb6V9eUJPbBXg2JVn7q14tSP0aOqJ6OuBR/A8El3diCVOhDauMpZ9adjU
	 LKej6Yt2bAwmtYYodEona8+VdAT7pv/1bSjoK0jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 58/73] ipvs: properly dereference pe in ip_vs_add_service
Date: Wed, 20 Nov 2024 13:58:44 +0100
Message-ID: <20241120125811.003148264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Hanxiao <chenhx.fnst@fujitsu.com>

[ Upstream commit cbd070a4ae62f119058973f6d2c984e325bce6e7 ]

Use pe directly to resolve sparse warning:

  net/netfilter/ipvs/ip_vs_ctl.c:1471:27: warning: dereference of noderef expression

Fixes: 39b972231536 ("ipvs: handle connections started by real-servers")
Signed-off-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ Resolve minor conflicts to fix CVE-2024-42322 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1382,18 +1382,18 @@ ip_vs_add_service(struct netns_ipvs *ipv
 		sched = NULL;
 	}
 
-	/* Bind the ct retriever */
-	RCU_INIT_POINTER(svc->pe, pe);
-	pe = NULL;
-
 	/* Update the virtual service counters */
 	if (svc->port == FTPPORT)
 		atomic_inc(&ipvs->ftpsvc_counter);
 	else if (svc->port == 0)
 		atomic_inc(&ipvs->nullsvc_counter);
-	if (svc->pe && svc->pe->conn_out)
+	if (pe && pe->conn_out)
 		atomic_inc(&ipvs->conn_out_counter);
 
+	/* Bind the ct retriever */
+	RCU_INIT_POINTER(svc->pe, pe);
+	pe = NULL;
+
 	ip_vs_start_estimator(ipvs, &svc->stats);
 
 	/* Count only IPv4 services for old get/setsockopt interface */


