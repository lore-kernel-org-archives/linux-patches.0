Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858EE23371B;
	Mon, 10 Mar 2025 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627651; cv=none; b=oyMSrQUpq59qd6hJuRyPEKWLR74Ijf7Xc0MDiivm217pXmfA9p4GTUV0QUMCphmWPiQ3Ez3+lWJ0bT/wHrQEfJ1bke0kwCd+9R0fCRAwS8DcYIfnv8H5OJ+1UteClgGqBpgqGf/wSx1Z3uQT2CoGSXPw8SzSsEzGTKQFe4ezyTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627651; c=relaxed/simple;
	bh=StUu9pCOY+LbZ+RS3YvuEVK/7/Yw0CHo0CJo6LjQDmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQy7UcQtCIjrUfpAtkKUDkoDXLD8d2vXpJG3lmXGq4y8xisexagL1H/K7TCs+ybliT4b5Ix9R4mUQqu3KyjQi+VAHoWIlweER6pcElfAmU+TMLLWr9SiXJMRhLHPiZffh8qkLdIUuOT6dB8KCJCFi0QGVRtN4COLYBWute5SSMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoxgeWYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoxgeWYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22F4C4CEE5;
	Mon, 10 Mar 2025 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627651;
	bh=StUu9pCOY+LbZ+RS3YvuEVK/7/Yw0CHo0CJo6LjQDmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoxgeWYS3CVCn+ok8OxH4P5j/dZZ3O0iZxErjGjFibPH4HPzJdu92iC5DqdACr8Qu
	 jQheQotN1m/rtAThbM5wKq+C0etnn7Q+tC+AMuS1ET6822vCht5PJkpBQSNnjeLJOJ
	 JFcVQVE0Z+YkF5/kZlngKlWcHlUuYtzG1eeyYpA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/269] mctp i3c: handle NULL header address
Date: Mon, 10 Mar 2025 18:05:55 +0100
Message-ID: <20250310170505.746067879@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit cf7ee25e70c6edfac4553d6b671e8b19db1d9573 ]

daddr can be NULL if there is no neighbour table entry present,
in that case the tx packet should be dropped.

saddr will usually be set by MCTP core, but check for NULL in case a
packet is transmitted by a different protocol.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Link: https://patch.msgid.link/20250304-mctp-i3c-null-v1-1-4416bbd56540@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index ee9d562f0817c..a2b15cddf46e6 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -507,6 +507,9 @@ static int mctp_i3c_header_create(struct sk_buff *skb, struct net_device *dev,
 {
 	struct mctp_i3c_internal_hdr *ihdr;
 
+	if (!daddr || !saddr)
+		return -EINVAL;
+
 	skb_push(skb, sizeof(struct mctp_i3c_internal_hdr));
 	skb_reset_mac_header(skb);
 	ihdr = (void *)skb_mac_header(skb);
-- 
2.39.5



