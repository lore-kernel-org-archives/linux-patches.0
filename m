Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B391DE899;
	Wed, 19 Mar 2025 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395175; cv=none; b=f48EHTp3f5mbySRsj6/YWhym0iLbBSLDfMEfgH5R9F1S1IcfD6Fq8dNHqj7mvl1jZ0A8wkrNLpcCPTg1BKk+s4hBMvOu49eA02tFJUSYeq6HEV6GiurhpatC6mASZlcUrDzwC/r2tyND99DUCYBITiD8h1hD3xUWrQwAxlkFpDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395175; c=relaxed/simple;
	bh=3/SitdCYhoWCs+ioEioUh0JFWg0gY4nCxbMnVf8yeGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv2q/Et4PFG913wEX9hdqF+makIGpUCqjPWTu52jk3PW57Q20rj1c4I3CtgyeJDq1/AGelHaEuXTewqq3iQA53gvMc7lhQ4cvvUfjr/w8RPnbi5olsrmKRClsgOt8VjztdDh5aWSMPG9H7N0CBmgIaXnREHdbxydQUeviSw75W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmSgWMBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmSgWMBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D54C4CEE4;
	Wed, 19 Mar 2025 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395175;
	bh=3/SitdCYhoWCs+ioEioUh0JFWg0gY4nCxbMnVf8yeGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmSgWMBVE3i4AUMPK/VXBP0T5hruwXGN0XAuyXQLgwfuvF29d2uBTHZzszblBtLqv
	 a9THRMpm48lnBpLnBnyK/e/8wNYL3iIkmu06SWGJz7sff1ZICDHbTmF+qzAT/TzjdO
	 v0z8ROaK8RGV7Nr1IgnflOEPJfaXrTkXCK49S5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/166] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Date: Wed, 19 Mar 2025 07:29:59 -0700
Message-ID: <20250319143020.747473697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 80b78c39eb86e6b55f56363b709eb817527da5aa ]

The get->num_services variable is an unsigned int which is controlled by
the user.  The struct_size() function ensures that the size calculation
does not overflow an unsigned long, however, we are saving the result to
an int so the calculation can overflow.

Both "len" and "get->num_services" come from the user.  This check is
just a sanity check to help the user and ensure they are using the API
correctly.  An integer overflow here is not a big deal.  This has no
security impact.

Save the result from struct_size() type size_t to fix this integer
overflow bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index dec5309d9f1f5..ae76542de3e98 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3091,12 +3091,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_SERVICES:
 	{
 		struct ip_vs_get_services *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_services *)arg;
 		size = struct_size(get, entrytable, get->num_services);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3132,12 +3132,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_DESTS:
 	{
 		struct ip_vs_get_dests *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_dests *)arg;
 		size = struct_size(get, entrytable, get->num_dests);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.5



