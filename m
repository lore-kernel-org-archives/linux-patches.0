Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF5352027;
	Sat, 30 May 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163845; cv=none; b=iW0Bth6tk2Un97gEc7bhOm4+xW6gq3YbXlJV7rPM4ZW5nJ7qcAaKEQ7uv5xCHB/9pYLS4yDaiWqNJzlYrSJSPR3zi4NA4hvyAVdxwkf1PSMPdm89TV1NAJyuzKqyOOm+FwE2+2HKIkc7pG8a68v7HtL9qY1YLO1UfolBPXeenNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163845; c=relaxed/simple;
	bh=60kPNovVwQEnCAI5jbRNHixt9cPUEPlYhe6FBgEr96A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ksq/XucuQfCg6p5erfM7wTKPT/DEY1M2TumSE+tjg3bACyzpucSAcO9skQra59C89jz47ZkHj3wO5FYjAw6JBRq9RmruP4CImjWfqbq/txifGHDbo8VMhhWUB41jwd2hcRJ1RS5dgX/LRsVPxuEVFyUqTIYDgJdjplm+ehuWx8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JHXW4n7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JHXW4n7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F86D1F00893;
	Sat, 30 May 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163844;
	bh=E4YC+nIBGWpO6uPFY2wNVxjzyDtAXqseyZpN/KjKFcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2JHXW4n7mELEzJPEfSk+cC16lqzZFLZKK9UoFZxKrzKdFztxQiW//BtRyIFxPPvNo
	 QuqvZ5qYYSwzEcSF3rbCkWopelyFRxKB51pT9ho+p46deAnS91rmNMlI6hWIU8oBi9
	 hTteZnLzsCpFwDe67dSifnwnQCbk+ivfWVgJzpYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 379/776] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Sat, 30 May 2026 18:01:33 +0200
Message-ID: <20260530160250.317756239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ba9d20ee9076dac32c371116bacbe72480eb356c upstream.

When batadv_bla_add_claim() fails to insert a new claim into the hash, it
leaked a reference to the backbone_gw for which the claim was intended.
Call batadv_backbone_gw_put() on the error path to release the reference
and avoid leaking the backbone_gw object.

Cc: stable@kernel.org
Fixes: 3db0decf1185 ("batman-adv: Fix non-atomic bla_claim::backbone_gw access")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -722,6 +722,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


