Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B051E264A70;
	Tue,  8 Apr 2025 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112288; cv=none; b=mIz01ruaw2Ggv+3umcd88kn4w8gKB+fCc00Gwm6z4OybUmF1S+l6SLxUsi7tsXfSEQJxz6wa3nW6viLO3MEZFnP8O60r+SCCdLEmps+kf/BhyzQTb/VUu1eU+1RycIf/AxDNGyQqNxpgLGbNgMfEgl3uJ/NQTQSEZ0/0xrvsvNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112288; c=relaxed/simple;
	bh=AK7WGIMG84pBzPd9CHt/pramHpXqvOXQGZArC/YnXO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPVkM7wRSLsozP6GMA86QGQqBQrj2GfkoelAg+fWARyXndf+dmtYGWEpLOUcSRT4QWi4vvl/rMOwg2Ry571n+KYb4dJGo7h7zPdZFLsw+vHY0eZUntMLaU9wBY3/qEFp0h+8rkv4t9X0kXln/G7Bvktqzfh5w59tyCC72b15WAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv5DF6LS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv5DF6LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4238AC4CEE5;
	Tue,  8 Apr 2025 11:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112288;
	bh=AK7WGIMG84pBzPd9CHt/pramHpXqvOXQGZArC/YnXO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv5DF6LSlgMoAtHyS6EGxpbLd7hq6BALCHchmVkc6F3WCYnm3YjH2Wh+GMIcHMnJn
	 PjfEZFuqVeOMXXfO4vanNU9CFpNub9BOzoNtRzTPuejiM7aGaEDyg+lXKWlqZYcAqx
	 IneYHUiaNFVZFukDxTGpzHIByso2sgcyARMC9X1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/279] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Date: Tue,  8 Apr 2025 12:46:37 +0200
Message-ID: <20250408104826.766050715@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0b64c36471d5..fb9f1badeddbf 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2852,12 +2852,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
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
@@ -2893,12 +2893,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
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



