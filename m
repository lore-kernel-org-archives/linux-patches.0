Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EC846EF8D;
	Wed, 30 Sep 2026 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793527; cv=none; b=lBp6f3Wy/fB2Q23re0HvpT+UZshJNUO/aGNJVcBLmv1+WzYHEhEPe75ptNhjs8KUIp4grUqEfCHzQX9BRyMlhb/VkLlPEX4GUY52ZPT+y45anGtKzLciEysoRv+xTlk3NlVmtCURn/7Q8wGv9yOyijzyFS6rE1jmO2xeCPXfd7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793527; c=relaxed/simple;
	bh=0hVzZW1ngyAqSJHGdztx35lyLVkWpMQ6VPbiIuZTwjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl2pn8Ky4BmB4xWV2qLsXkRVAZGTWfFsayBomfL4iPoPRUzqynSBOJTpI3qVKCAoaiXGyHv23U2h4cCrz69mvbsnOjg2RI6ssz+V2xlyXXWyeeVECzO8S33SayumrZHmPTdPiI3O3sW+5g7qT/ipf/ZbcRm6WC00cftM9DaAKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PesuaeRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PesuaeRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1EB1F000FF;
	Wed, 30 Sep 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793526;
	bh=5yTOwbrAPSugGfzZDJO81T4PKliuelQzPcX1AZkxtTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PesuaeRVIl/sSzfjY23KS2z6EbgPdJSQajt5Gd5KW+6qp8wZaUKP1Ujy/+CRLk4ca
	 u84oeXBFu7R3S4Cz7Lkk1bwKtMlnWiTGXGb5v08AcO9ciURhWZH3f9E0H9pD9BEsc3
	 hBrQUVZ+vwgAs2f0RUgQrWJxE2ufkZhA0/Ro5RqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 286/395] net: phy: micrel: Advance register data pointer in write loop
Date: Wed, 30 Sep 2026 17:29:08 +0200
Message-ID: <20260930152346.864903387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>

commit 95c4d54ed02283e9a09e8cd7360e384daa67a741 upstream.

lanphy_write_reg_data() does not advance the data pointer while iterating
over the register table. As a result, it writes the first entry num times
and leaves the remaining errata registers unconfigured.

Single-entry tables are unaffected, but tables with multiple entries
leave every entry after the first unapplied.

Advance the data pointer after each successful write so every table entry
is applied in order.

Fixes: c8732e933925 ("net: phy: micrel: lan8842 errata")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Ojha <abhishek.ojha@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260916231928.1336305-1-abhishek.ojha@savoirfairelinux.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -6034,6 +6034,7 @@ static int lanphy_write_reg_data(struct
 					    data->val);
 		if (ret)
 			break;
+		data++;
 	}
 
 	return ret;


