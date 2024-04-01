Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48430C129;
	Mon,  1 Apr 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988604; cv=none; b=APrjMOvnsjkDOw+GbWk0HR0BmevObu17X8OqKeII4pa4AUvncIwpmXWarActzn8xVT3IJPfomw/zbPHyAA6i34JHO2ponrP/ggvvX/Z6p4vLXSkhbq6+rjFbsqqG4lLzxNjKUZZWKaZY6Uco/4YIWNyxG5LrJ19iM2M5UdeA3p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988604; c=relaxed/simple;
	bh=rzzbD7FvATK2uFkf3w6SXyAE2CZb6uYHP9lddivl7WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eU7bp2NWXQgnZxef1eE+EZt8rwwhibbcaInmyXBrvRhe3a6rNcSRAyQr59vPdTdyIpwTnG+Gy/OIdKhaGj55NzX4+jOH+M8ihmHwK0vP0i2MsQB6/Q8EzY5SSo8HvSsRj7/w4ONQp6m2dpG+SRimzX8fSuDWTjDGYfeqhw9V6n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wHOMl8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wHOMl8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A084FC433F1;
	Mon,  1 Apr 2024 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988604;
	bh=rzzbD7FvATK2uFkf3w6SXyAE2CZb6uYHP9lddivl7WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wHOMl8I4t1mztiWBvVjy5qlVL7cOkxB3CKYXvHL/tMI8VZwXUxrW0T9Z1iKE6g6L
	 MQpfBA6TZTcENb2HABjEVzDp4AQomNDFcXvFlrb9oWZh79BcnNk4lsk055LeOesiSf
	 zDCIn5pOZHzCkODkkJCgRzpLVTwtEOc35DQbCsGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 235/432] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Mon,  1 Apr 2024 17:43:42 +0200
Message-ID: <20240401152600.144772596@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 16603605b667b70da974bea8216c93e7db043bf1 upstream.

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5000,6 +5000,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


