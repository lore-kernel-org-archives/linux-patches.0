Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12FF146A79;
	Mon, 16 Sep 2024 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488658; cv=none; b=QHtZ4LsKR3bydHnx5JTN5rHwnC4DeEgdCnwm0qVH3D9ugL8jzCzc/9i9oc4jhLvXtwHEH3pK/Ltwzch1JBePj2i3G7S/RqXPpwlsdM+xM7BZw3nmR9eB0EtQ65WtmwBDRsP2QjNiINKaxPuKeGTtBEQOvuSCslfA/m9NOpyRME8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488658; c=relaxed/simple;
	bh=9I97LpS1UFKVXaER1kTgBY5ZHL1A8X3eu6nBaF/TEcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKK9QuG8xZk5Wh3fQfse2urq9+YSzuRDiJBlZWCfCmGycwaYY3q2FJq4fICNa58xmvzr4vQpbiLH3GEMZ371tqR35gjVJeiWTu668sfjzXh77AZ5WJUb4uGdS1js/MR6Hz+20SzhSsmGKyPRZRHzPvjOkqvcDbAdGNzqXvwEv0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUgF8nGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUgF8nGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D2C4CEC4;
	Mon, 16 Sep 2024 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488658;
	bh=9I97LpS1UFKVXaER1kTgBY5ZHL1A8X3eu6nBaF/TEcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUgF8nGFzEuUnbzHyQrFc3xKFdkiDzOmdn8F6p84GL+HGAr0nL8mcH8LS6OuJwfZA
	 mZIO9Cp9ydK/RHdYxbx4w2A8lYiFVwjrr2XCL7ljaZYvnOdFvLj+7kRmnv6KNH5n+d
	 E7fYPARQ9KCsktgMlv/Ebb1Z/H2J7hRbyRNH7Meo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 68/91] fou: fix initialization of grc
Date: Mon, 16 Sep 2024 13:44:44 +0200
Message-ID: <20240916114226.726715048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv4/fou_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index e0b8d6b17a34..4e0a7d038e21 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -336,11 +336,11 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
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



