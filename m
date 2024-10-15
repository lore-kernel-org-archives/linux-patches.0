Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193E313F435;
	Tue, 15 Oct 2024 11:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992314; cv=none; b=J6AR20cTcSiMhgVK8IM9EKb71PsphNqaVi9cYsoJlUslL3Pu2gMtp1O65r8uf2kuitPlXT2qdwO6cGqvq/if4MU9Uy0KM9P+yoNopeMxl+dbjeMfD4pNROdzoY4Z/Rth2gyHGYhYGBfpNxM6TwXgJG/zrb5Fn99JehKHce3VoNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992314; c=relaxed/simple;
	bh=hi2NNBgT94HqMTASBjz9QrUBhb069Yjh2Mv7b8VtLqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOh1vslQD6DgqmOYmtwYirDFBGKp88s+oN936WctzeCqB1d1VdBj/YQnIYst50Nbt+/Zy99F+wCcrYOzTVnW5GETzf4EFndd1wvgVaZ5amq9PhjZF86t9cRl8NaHe4RC+liAERcQ/RIeVG58HKigx3O7CfvgFJlqpolMVWbw18M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfoKYklP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfoKYklP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F068C4CEC6;
	Tue, 15 Oct 2024 11:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992313;
	bh=hi2NNBgT94HqMTASBjz9QrUBhb069Yjh2Mv7b8VtLqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfoKYklPPCR89ssc3TNzNh5v0tPcaQ6ymcPEupGtxLm5ftvNJDTUhAkK6a1Uxfkek
	 ShCEcpcfUVNGwI2Q8iGuFfqzTZ5majbnM2MnQDKCseBeruHh9t3Kul7Da6GwOFpYzo
	 eKPXmIhNvHo2iG7PiyFy1dnCzrRiCf4Ujjpq8QP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/691] fou: fix initialization of grc
Date: Tue, 15 Oct 2024 13:19:57 +0200
Message-ID: <20241015112442.292725361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



