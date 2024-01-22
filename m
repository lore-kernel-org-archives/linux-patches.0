Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F1013E224;
	Tue, 23 Jan 2024 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971998; cv=none; b=Yn3m/gapdV9ZMoNMn9yVKlTJWXGddxusETjtNJJbyyZroSpUW/P/UnRlL1BB4tBJ9ttIVeXM/zjZq5NzF7d/Yzsud/sBK+m2JLrRydR896vfhTG76W8xQhreJK0XnPh3hnj5dEMzhbcxswBpgx5W4JCEmL2wLPA9ehuu/fX9oLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971998; c=relaxed/simple;
	bh=9qUwHSu+ptr9WUP1vPD1vchIwkPzJFhYnm/wpJXoMbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvl6Oy6FFI9xhKidFiXYSp9ApYOJ4i6btPcnSkbAo33scSxH5iS+HeF0cEXnVLTO7RRKTT2mszBNZ3noFz1YXgLZ8mvS3PaCh0qjRXGC28KcAUrMS9v1yvHALWRld20b68zlOCfGHgvganlWX0qhEwQQQGE+IBPQf1KxfOq9k5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNZuFIq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNZuFIq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C1BC433C7;
	Tue, 23 Jan 2024 01:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971997;
	bh=9qUwHSu+ptr9WUP1vPD1vchIwkPzJFhYnm/wpJXoMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNZuFIq6Bvt5YcRtOOrlTTQ4DUZLCooPrQtxIoHTPTfN0NVrDBsd+YTYE4+stNddd
	 5spCs9ZLkjD6uY7Fma7T14ThlS+FOc2+RSUwh0a0WImY1XpQ5u+X6gc7PwDyBpkXog
	 cKDDSMVrgEjR8h9bDtO4CLF/8GvMiC8W00U40bD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/286] netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description
Date: Mon, 22 Jan 2024 15:59:39 -0800
Message-ID: <20240122235742.564882086@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 113661e07460a6604aacc8ae1b23695a89e7d4b3 ]

It is still possible to set on the NFT_SET_CONCAT flag by specifying a
set size and no field description, report EINVAL in such case.

Fixes: 1b6345d4160e ("netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7a1a21cde760..fca8f9a36063 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4466,8 +4466,12 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		if (err < 0)
 			return err;
 
-		if (desc.field_count > 1 && !(flags & NFT_SET_CONCAT))
+		if (desc.field_count > 1) {
+			if (!(flags & NFT_SET_CONCAT))
+				return -EINVAL;
+		} else if (flags & NFT_SET_CONCAT) {
 			return -EINVAL;
+		}
 	} else if (flags & NFT_SET_CONCAT) {
 		return -EINVAL;
 	}
-- 
2.43.0



