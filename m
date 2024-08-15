Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220881494C5;
	Thu, 15 Aug 2024 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729904; cv=none; b=cBvGZwYoAWbl/N3N6KgInIaj7EnvAuddExAHelnlPwHu+8nkCm68aGjy8JGynZXjTmlByv8Y0IAKu9cUkw7L7+XhYYAR3NdIxtVy+J6EivkhjSIfUOFtQ3V/le8fn6iMcEltNbDKlnA6GrGry/MZLVxSZ/WqpfRVlhSd8q+6B0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729904; c=relaxed/simple;
	bh=iWs4yPooq4A4c1qSP7NiD4Am+BhBruRuv0hJmfSz4ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR8m9h8UG8tGkxSxlova4fn7tYEWTX20w6bAbhorKDTf+CA3FgGlo27oE18Csk0j7yIaxFndaeoasMrjIuY/OrP+tTmAfseXoWhS7UHTsJT14V78EiZzdRMdcVaGGnE5Pscgv917Rfehv+HKiUs97UqCU3sU2ltyCAv+R/bBYxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8L4Vdyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8L4Vdyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA40C32786;
	Thu, 15 Aug 2024 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729904;
	bh=iWs4yPooq4A4c1qSP7NiD4Am+BhBruRuv0hJmfSz4ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8L4Vdywv6dbUDE1Brb4kc4D7aJcKVr4TxZ5LIiICG1ZD88cPE3LwisdCQGBSwd7u
	 t9VvBXwJ6tlmiOpNEHiBN4xlxxIMjHw2G13IHaaDnxjUwrhFTQ4dfRWjYTFdRF1Uus
	 wUocgF3iCP0kFNWb8nx70h82F74JYLQk5cuLHoB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwenael Treuveur <gwenael.treuveur@foss.st.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 244/484] remoteproc: stm32_rproc: Fix mailbox interrupts queuing
Date: Thu, 15 Aug 2024 15:21:42 +0200
Message-ID: <20240815131950.827457375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Gwenael Treuveur <gwenael.treuveur@foss.st.com>

commit c3281abea67c9c0dc6219bbc41d1feae05a16da3 upstream.

Manage interrupt coming from coprocessor also when state is
ATTACHED.

Fixes: 35bdafda40cc ("remoteproc: stm32_rproc: Add mutex protection for workqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Gwenael Treuveur <gwenael.treuveur@foss.st.com>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20240521162316.156259-1-gwenael.treuveur@foss.st.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/stm32_rproc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/stm32_rproc.c
+++ b/drivers/remoteproc/stm32_rproc.c
@@ -293,7 +293,7 @@ static void stm32_rproc_mb_vq_work(struc
 
 	mutex_lock(&rproc->lock);
 
-	if (rproc->state != RPROC_RUNNING)
+	if (rproc->state != RPROC_RUNNING && rproc->state != RPROC_ATTACHED)
 		goto unlock_mutex;
 
 	if (rproc_vq_interrupt(rproc, mb->vq_id) == IRQ_NONE)


