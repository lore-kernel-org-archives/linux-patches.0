Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E970C1C07F8;
	Tue, 15 Oct 2024 12:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996869; cv=none; b=hV8oP56s4/2Uu6GC8e6Sn8YP5rlmknw/aT3L4MarNWQD4WAsHFt6YqM/Nk9BSEOxc/SZmmz0uPd1zZ82e/Z7CpneXcbLgnpereSK/FiuCVuAIfNtC/d2KJdVR4Ia1GqQoUHQ/Uhfq9sgKNUYpVLGDgW5uyg48LPnS2Z3MQe66Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996869; c=relaxed/simple;
	bh=QmakVhObr0dZZhF7cE/CSQS0oNEtSXtuUzdS5gvzj8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7Caab5FC2J5q5W8cR2920Uo9pqbpYoulzacUE6/j1AWqsuLvixg0/lVKKbiUFfGHr/T2S2PWhIj6zLTmmRDK4fU61sJtn5Wne2f++iQFDS7+L5XLm4mut2v6WJnqYlvI3CRd2/V+pN6x8v+Vo6qANGP/Ur7WFoIAD2cAl3xVUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e15yUpgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e15yUpgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32708C4CED0;
	Tue, 15 Oct 2024 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996868;
	bh=QmakVhObr0dZZhF7cE/CSQS0oNEtSXtuUzdS5gvzj8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e15yUpghLR+YF+VelVNwBNM+9+USfnBSbqPLJGT2WdlEPnW9BpdwIkxI8aUbWGBrY
	 Ur6mPmBEVPV7VSIuN0FJqAH6y/hetX6Ot116UPQkhWkrpBiSe6Js8CiDQCH9VH5Hfp
	 dDT7s3SQqOG3eZBStnZM+F/EC0UT8YaZj6DBmxgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/518] fou: fix initialization of grc
Date: Tue, 15 Oct 2024 14:38:46 +0200
Message-ID: <20241015123917.855795529@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 4c8002277167125078e6b9b90137bdf443ebaa08 ]

The grc must be initialize first. There can be a condition where if
fou is NULL, goto out will be executed and grc would be used
uninitialized.

Fixes: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240906102839.202798-1-usama.anjum@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 135da756dd5a..1d67df4d8ed6 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -334,11 +334,11 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	struct gro_remcsum grc;
 	u8 proto;
 
+	skb_gro_remcsum_init(&grc);
+
 	if (!fou)
 		goto out;
 
-	skb_gro_remcsum_init(&grc);
-
 	off = skb_gro_offset(skb);
 	len = off + sizeof(*guehdr);
 
-- 
2.43.0



