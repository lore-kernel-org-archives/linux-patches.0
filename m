Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35D4FE2CC;
	Thu, 17 Sep 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667273; cv=none; b=qpwZUi9qs8ADv4YcfiHqbSdUFEGVrMFDaLDbal4BV6D4XmowOpAgQ6myqQfDL0B6ywMzrgw+hL2vh6hWLH+1OQX6wbLTpCshdB+3Afu15d5M1rUIqnD+IxifcT1sNbo4dEZ0VzaXxTqenuhldLjsxnab/gXafhR+6ZDMPneKYN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667273; c=relaxed/simple;
	bh=PYLCWmxoghLPjQb5QNOMph4ipgCTQxMXLreyvQJcq2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmUEt3rt6CiyhHKXyazPLcvUpglJmxnnl0J7DygjgYRrsIHuPzYJJlb6XOQSAcT5O2YWi1NzFL6w8NZG9U4nNE0/R1MtOr5pD+mr6kn4McVNRUxaFatUqTh+nSTc0a1WBMRqmHoTlCZQRGAR/nEXEtw0KDtfhU4Y58MoBOvxnrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZeXVrWT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZeXVrWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330BA1F000FF;
	Thu, 17 Sep 2026 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667271;
	bh=rok1M17Z7WD57fqITr+mFCYHnyMx20jWvVerd4huOWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZeXVrWTpeqoOWcKrX78EAooSJv5CkoiTftt4O31Cw6mhI+ZzJpCHrkWIAMp9jijn
	 JeDqn82NZLJvG6M/9aJdtf9I4al1nGQiZV95qYHB8phYniFuEZSIa7SwQgAiptCWZZ
	 WovbJuLO694CqfENP5Yaf/MMWiyztuhF2L34qI58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0036/1102] thunderbolt: Dont disable lane adapter if XDomain lane bonding isnt possible
Date: Thu, 17 Sep 2026 15:59:39 +0100
Message-ID: <20260917151540.350252041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 7c7345bcde6c611fa8fa13e624207c6005798aa8 ]

This happens when firmware connection manager is being used. It will
deal with disabling the lane 1 adapter after the tunnel has been
established and re-enabling it afterwards. For this reason only do this
when we know that lane bonding is possible (e.g running software
connection manager).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index ffe7ce0737491..7afe15d53ddcc 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1947,7 +1947,13 @@ static void tb_xdomain_link_exit(struct tb_xdomain *xd)
 	if (tb_port_get_link_generation(down) >= 4) {
 		down->bonded = false;
 		down->dual_link_port->bonded = false;
-	} else if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
+		return;
+	}
+
+	if (!xd->bonding_possible)
+		return;
+
+	if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
 		/*
 		 * Just return port structures back to way they were and
 		 * update credits. No need to update userspace because
-- 
2.53.0



