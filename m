Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC69822B5A1;
	Mon,  2 Jun 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874432; cv=none; b=n1jmFfZ8q7lLCI7KYqgdFWaNk/ageHO7SzrwGtNTnNx99YT6dJ3Cmg5+vKyQsNpOOcMFPYdrlO8qlKiJT1JDktdiKyOFBM4gX7U5s7OvSGPQb/zSnk+UM4CD5iAucIscU7Z0PL3vfzWsMlI7ppOzxP30dGHwg33w4pSk9V56sTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874432; c=relaxed/simple;
	bh=bT1rsEE6O8B3Kfo39GfgW1zfB7cvnfwkGGVCjdJmT/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqDetPdHyEs7CqgAVzG4SndaJIDrbNS92dTJRErBX2s/Ss9iQAC2JhFfVWaSrhJnENl3o97LLOBQOR0n1D4sVT+SVwWA4HFu89ZU0kwCDq6CDa1GhZAsNi1ynLgFnaRkt2s19Weu/zphprW1HkgBzRpsFbJO8SFpq87nbcXBvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2I2Nx0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2I2Nx0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45677C4CEEB;
	Mon,  2 Jun 2025 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874431;
	bh=bT1rsEE6O8B3Kfo39GfgW1zfB7cvnfwkGGVCjdJmT/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2I2Nx0uDWsB7rN9Un/0q2dsIPUq4egUj56POi1D6WhGNqsixRdCRWjXEiS0II735
	 89XVak3qxTYkowmRAMZ6jbyF7BVc4NGaoY/eRoXY7Wtx7nhRvAE2EbDMIAAuJY40ot
	 J+XzpmSV2kflKWGdSeCXaN8k9PiAq9E9K0w4mlcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 022/204] sch_htb: make htb_qlen_notify() idempotent
Date: Mon,  2 Jun 2025 15:45:55 +0200
Message-ID: <20250602134256.555884083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 5ba8b837b522d7051ef81bacf3d95383ff8edce5 upstream.

htb_qlen_notify() always deactivates the HTB class and in fact could
trigger a warning if it is already deactivated. Therefore, it is not
idempotent and not friendly to its callers, like fq_codel_dequeue().

Let's make it idempotent to ease qdisc_tree_reduce_backlog() callers'
life.

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211033.166059-2-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_htb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1173,6 +1173,8 @@ static void htb_qlen_notify(struct Qdisc
 {
 	struct htb_class *cl = (struct htb_class *)arg;
 
+	if (!cl->prio_activity)
+		return;
 	htb_deactivate(qdisc_priv(sch), cl);
 }
 


