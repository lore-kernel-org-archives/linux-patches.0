Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9218730AD1D;
	Mon, 13 Oct 2025 15:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367727; cv=none; b=Db2IBuYL7wWaDTg1qO26dcApWrLoQPwsktSWbEV3tLgGDgeh3P4HXTSnW6MVUqOU8SjWOInJ8pygSA/9xzYL8WDOahIaCGw6NQni3ACTUxE5SxAaQTHX8fgeff7rotabAcdn51S/aYQVj8ZbPClE1MZY7Q1DZ/QToEZMgnNrmtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367727; c=relaxed/simple;
	bh=oEgTJ+7a4zALLhMjv3ND4fgYr/6DNy/k1Vr5+QnKxRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxOs15vTIBbGLatT13cS5IhRoMSFRhaE7ty+FktI9QTTKkKkrUSvxIdny1W21bqhMIV8OSrGYv6nDbrFHjoOtA5GVM7kLRHekWbE9X6pKzOuO+YAGovu4xzwUZsPcfm76Woijg2MKqVn+/NZwT2IcGCTpRaCNl3I936W3wmBHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lc0FZdrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lc0FZdrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A85C4CEE7;
	Mon, 13 Oct 2025 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367727;
	bh=oEgTJ+7a4zALLhMjv3ND4fgYr/6DNy/k1Vr5+QnKxRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc0FZdrDfvnZPDte1EFrqa1X4pDwI5PCWLNpSyxSl6IX8V5gOUQFDtKLQHyrQeBEM
	 iehzBh6bRgfhJ9QICHW/NJQme4s3JZv0rhIBi83m/84D/TrdigCmCMTCI5G9UCuas8
	 q9O+IDta1+whjNuJYE9IGNSyuVvaoby2/xBpUdME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/196] RDMA/cm: Rate limit destroy CM ID timeout error message
Date: Mon, 13 Oct 2025 16:45:04 +0200
Message-ID: <20251013144319.399515349@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 2bbe1255fcf19c5eb300efb6cb5ad98d66fdae2e ]

When the destroy CM ID timeout kicks in, you typically get a storm of
them which creates a log flooding. Hence, change pr_err() to
pr_err_ratelimited() in cm_destroy_id_wait_timeout().

Fixes: 96d9cbe2f2ff ("RDMA/cm: add timeout to cm_destroy_id wait")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Link: https://patch.msgid.link/20250912100525.531102-1-haakon.bugge@oracle.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index d45e3909dafe1..50bb3c43f40bf 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1032,8 +1032,8 @@ static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id,
 	struct cm_id_private *cm_id_priv;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
-	pr_err("%s: cm_id=%p timed out. state %d -> %d, refcnt=%d\n", __func__,
-	       cm_id, old_state, cm_id->state, refcount_read(&cm_id_priv->refcount));
+	pr_err_ratelimited("%s: cm_id=%p timed out. state %d -> %d, refcnt=%d\n", __func__,
+			   cm_id, old_state, cm_id->state, refcount_read(&cm_id_priv->refcount));
 }
 
 static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
-- 
2.51.0



