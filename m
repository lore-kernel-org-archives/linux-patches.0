Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3EF3ED5B2;
	Tue, 17 Mar 2026 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765710; cv=none; b=GMEmTuXUgz1qlOCLpE+9IENIqPR0JTSG4Wdk/k6Ae/TgyCxsm5v6nwlVX7jHvukjqf1cYnAfY6KF3hXIPBKH1fqUFKEYxdk00rUzQ+0e9WDQQ9wZW0WlgXxmQvv7qxsuYQVfEGjx9Ji7yIQZYJe43kYfDxfRYJpnhz5uLUKiidg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765710; c=relaxed/simple;
	bh=LAKvINm1GUIYht6d9gb3IZ5ooI1Zg3mQLu5Oz15tsfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYm0lHEH8QjWKQGJOYic/GDdwuVvw+pAQtVsAoHeAAfUwHFPy4bwenJyiBkj4HwWm/gKbVPNc0N5hgBYjnqWt3tdMdMi7YZdj5HMHgGkKlaJIbeai0+vdbzMX8W/6sadP2rty/hxxAK7C9tv3S74I3AryOyFnopXU+JxKJW15oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd3TK6cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd3TK6cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE94C4CEF7;
	Tue, 17 Mar 2026 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765710;
	bh=LAKvINm1GUIYht6d9gb3IZ5ooI1Zg3mQLu5Oz15tsfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd3TK6cQL+XoQd3zT6AlziO28b81yuq4rvlJkfC5KRAmDq1ke5VtiVPS15BZ7HRWo
	 I57j0r4+RDYhtoZUtSXWGPOL6ittFAH5wIhX8Uzl16GEzXTVedMKEVJS62jysDI9sh
	 nrfUtKG3YqrBayNSlTW9/bYKycHCJR5LOjgAf6QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Dull <monderasdor@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 077/378] netfilter: x_tables: guard option walkers against 1-byte tail reads
Date: Tue, 17 Mar 2026 17:30:34 +0100
Message-ID: <20260317163009.850950935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dull <monderasdor@gmail.com>

[ Upstream commit cfe770220ac2dbd3e104c6b45094037455da81d4 ]

When the last byte of options is a non-single-byte option kind, walkers
that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
of the option area.

Add an explicit i == optlen - 1 check before dereferencing op[i + 1]
in xt_tcpudp and xt_dccp option walkers.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
Signed-off-by: David Dull <monderasdor@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_dccp.c   | 4 ++--
 net/netfilter/xt_tcpudp.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index e5a13ecbe67a0..037ab93e25d0a 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,10 +62,10 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
-			i += op[i+1]?:1;
+			i += op[i + 1] ? : 1;
 	}
 
 	spin_unlock_bh(&dccp_buflock);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index e8991130a3de0..f76cf18f1a244 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -59,8 +59,10 @@ tcp_find_option(u_int8_t option,
 
 	for (i = 0; i < optlen; ) {
 		if (op[i] == option) return !invert;
-		if (op[i] < 2) i++;
-		else i += op[i+1]?:1;
+		if (op[i] < 2 || i == optlen - 1)
+			i++;
+		else
+			i += op[i + 1] ? : 1;
 	}
 
 	return invert;
-- 
2.51.0



