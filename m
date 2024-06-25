Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA89513C90B;
	Tue, 25 Jun 2024 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308403; cv=none; b=XuVKDYEKgD7vP2Mk76FXABPtZ4BVf/2rNqjbM8TuWLbe6qvRG0kozraZizui6gQ6w6SXmZE8qManwni/idvWQ2k1MUTCSujbjhQe6sw6F/BRDABr0e0LohajW8YZ/S/ldRIOnT7nVSGQnqNuss2vKfyM7KR/cpcxNzQxmJFXtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308403; c=relaxed/simple;
	bh=A7xHglEbJe6DfhQUvW9lakRkfqilkjQ/Fr+4rktcWYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1TxwbYLR6P4T2yBOs95jUrCiubX0um9ECO4WmKSeKap7os10XgPCBAvqqWVgL/XUug2gH6YeW9Pi5W9jWk+A12FxplXlD3OPbFq0tAZmJYHp38P9za9LDtGY3Y5XkU22Xoe660tDocVZdqc6RXbb+hn9FuUdh9FEsPdZrnyWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGT/4unC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGT/4unC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576D0C32781;
	Tue, 25 Jun 2024 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308403;
	bh=A7xHglEbJe6DfhQUvW9lakRkfqilkjQ/Fr+4rktcWYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGT/4unC830or89PHE4icvA0qhPTkw7WSprbIArM4oWtG9tOsGUlC4B5aY+j2fFfj
	 0NIDTOvqbq3CVcirL08Uo3wg+yB5WJ+3thUSh7fdgvjcFg9blV0R5Lk34JUBV3LxCf
	 G9B3l9vyVC4+gAnPXXSo5kOuIPJ57JrBLVAF9pKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 110/250] cipso: fix total option length computation
Date: Tue, 25 Jun 2024 11:31:08 +0200
Message-ID: <20240625085552.295238656@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 9f36169912331fa035d7b73a91252d7c2512eb1a ]

As evident from the definition of ip_options_get(), the IP option
IPOPT_END is used to pad the IP option data array, not IPOPT_NOP. Yet
the loop that walks the IP options to determine the total IP options
length in cipso_v4_delopt() doesn't take IPOPT_END into account.

Fix it by recognizing the IPOPT_END value as the end of actual options.

Fixes: 014ab19a69c3 ("selinux: Set socket NetLabel based on connection endpoint")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 8b17d83e5fde4..1eb98440c01ea 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2012,12 +2012,16 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 		 * from there we can determine the new total option length */
 		iter = 0;
 		optlen_new = 0;
-		while (iter < opt->opt.optlen)
-			if (opt->opt.__data[iter] != IPOPT_NOP) {
+		while (iter < opt->opt.optlen) {
+			if (opt->opt.__data[iter] == IPOPT_END) {
+				break;
+			} else if (opt->opt.__data[iter] == IPOPT_NOP) {
+				iter++;
+			} else {
 				iter += opt->opt.__data[iter + 1];
 				optlen_new = iter;
-			} else
-				iter++;
+			}
+		}
 		hdr_delta = opt->opt.optlen;
 		opt->opt.optlen = (optlen_new + 3) & ~3;
 		hdr_delta -= opt->opt.optlen;
-- 
2.43.0



