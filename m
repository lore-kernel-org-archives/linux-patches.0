Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F692DC350;
	Tue, 11 Nov 2025 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823671; cv=none; b=UYE2BVzWQvleeFPKkCNPDOxJOpaDkn+ca9EQGKJO36b8fdek7rAcklvWL5/9wQuMVLmrJQ4E5+dhaqbfy44GP2zyu8MAXbG9r5rgEiCjnzrM9dekPYjvY2aYS+cC706846hZMZNRjraQzp6QFosmIOHti43h46RoZOLfszPu9Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823671; c=relaxed/simple;
	bh=ujdZTUm5jo0pOUDD9+R5MoysribfuDUfFOyWAfg89KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn4G1hQQ2+2TmufYfS66G+30ONm5jKOFc/ITPO2X8AoR3ujxyLTHISwpiemusMWfWCZGJsGIfa8+HlEHaaHfAZUxxs3pVXgAfImwG3K5uJWkEaGO7dXTlSWD1yC7h6fyFVcWVOagJiEboW75CNwPf1CYwkSs8llnb3rB5V5I6x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIx1xGnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIx1xGnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B8C2BC87;
	Tue, 11 Nov 2025 01:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823671;
	bh=ujdZTUm5jo0pOUDD9+R5MoysribfuDUfFOyWAfg89KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIx1xGnBQgK3N/x8CNoqeUHfavh4xZV2qN44LVPDBUJp3xsK93DNwpOXVhUfyyyMQ
	 kT8K6ipexcStm+7PnTmF/wG4ffEptopklXBd01hroUYTp2b7lT6m4N+x+JnwozD7GR
	 FEuCV3pUmeOSd8sa2DR7BQ0FOxXC6Z5EXLMhEk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 347/849] rds: Fix endianness annotation for RDS_MPATH_HASH
Date: Tue, 11 Nov 2025 09:38:37 +0900
Message-ID: <20251111004544.808625708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ujwal Kundur <ujwal.kundur@gmail.com>

[ Upstream commit 77907a068717fbefb25faf01fecca553aca6ccaa ]

jhash_1word accepts host endian inputs while rs_bound_port is a be16
value (sockaddr_in6.sin6_port). Use ntohs() for consistency.

Flagged by Sparse.

Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://patch.msgid.link/20250820175550.498-4-ujwal.kundur@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/rds.h b/net/rds/rds.h
index dc360252c5157..5b1c072e2e7ff 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -93,7 +93,7 @@ enum {
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
-#define	RDS_MPATH_HASH(rs, n) (jhash_1word((rs)->rs_bound_port, \
+#define	RDS_MPATH_HASH(rs, n) (jhash_1word(ntohs((rs)->rs_bound_port), \
 			       (rs)->rs_hash_initval) & ((n) - 1))
 
 #define IS_CANONICAL(laddr, faddr) (htonl(laddr) < htonl(faddr))
-- 
2.51.0



