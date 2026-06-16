Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6244CF40;
	Tue, 16 Jun 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625968; cv=none; b=tlHlsx6rfDD5aIVNopVY91BITAgwqkrFyGEQFD+EpNx4rT5qm+4Xy6JjKp6jY5F1X6YFSWaEMKMrPdXbCzslN0bwTUDojctUfRpxEfLbm9TZXkn3WAqc5vMaKwyylPIXNeUJ6WsIW284pL9UFo4TFpGYk7dY1pSGBvtSKm8tPWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625968; c=relaxed/simple;
	bh=ds81sy/sYEBqnaWpwsAQSZaoXb3myyOgLCkefXw/+To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCBpSvh0YJc3eAKQAnsWfp6EIyNKk8RZ7ui8Xn+x5WyKWHKrVdgLP3bsOu+t955YMTtovIpKj5eH1YkoT70HMJkTEhkUcrcTNYm43ZC4dWva48upleyKeMWlKeosAxZucACX8aDDpSz6M8SwXrVtIjqD+ZgEdtQVvhudKj4DDfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgIXRpHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgIXRpHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1171F000E9;
	Tue, 16 Jun 2026 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625967;
	bh=Y9aWdw/qaakTSDX8Q12wOl53fNdh7mpIug8TJqNXWGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgIXRpHCd0ASVgv9AJDsj7Y1lyOR4/t5EegV/6XEJcNuq7JPrFNB2wlC+aPua6k5m
	 MzNIiSss2ngd610er4emtIMStdZqd7fLGHSVyqk55ApLBbH2P8dSoXuxrkgsCDK4ID
	 FXGVkPYvyPA7RZt7LHvurYspZ57ksSTrfJdw+lvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Kalluri <santosh.kalluri129@gmail.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 240/325] net: phonet: free phonet_device after RCU grace period
Date: Tue, 16 Jun 2026 20:30:36 +0530
Message-ID: <20260616145110.410120616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Kalluri <santosh.kalluri129@gmail.com>

commit 71de0177b28da751f407581a4515cf4d762f6296 upstream.

phonet_device_destroy() removes a phonet_device from the per-net device
list with list_del_rcu(), but frees it immediately. RCU readers walking
the same list can still hold a pointer to the object after it has been
removed, leading to a slab-use-after-free.

Use kfree_rcu(), matching the lifetime rule already used by
phonet_address_del() for the same object type.

Fixes: eeb74a9d45f7 ("Phonet: convert devices list to RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Santosh Kalluri <santosh.kalluri129@gmail.com>
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pn_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -108,7 +108,7 @@ static void phonet_device_destroy(struct
 		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(net, RTM_DELADDR, ifindex, addr);
 
-		kfree(pnd);
+		kfree_rcu(pnd, rcu);
 	}
 }
 


