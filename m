Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2891A76B4;
	Tue, 30 Jul 2024 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360505; cv=none; b=MQUgtCxkJptetLsLbYJKiX5O/yYwOGpCvQiqULcmoDFhRNvUl+UfKWU6PEp1B3BoWlRWzpppiiuD3e4JxwpMkaisgyzCG0FAheImYotir7z4Bi7DTCr3NfV+2escLfbkTBdS5xt1Nl0y87M3TxVuyRVwREFm9UduMa38pHkhrds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360505; c=relaxed/simple;
	bh=12cZHpEVMTa6aQUh5Dg+SwQL01wOLkrmMPvzA3H1YBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXpASxXL3b0Wotytow0JO5dw/YxTmf8qJN9wtnbouu+CLfOWzLNCuf+jTpOJReIOBoC344XgnF9GUYn2t7B2c09aiL1SKuANLwUZwd8n4UFdCRVUJ5VFG9KDy7fc6mpNYDxJ0KcPiQ/dM+IfebDPHvDQPRP7LhNRWZWCff3h150=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZz151ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZz151ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0090C32782;
	Tue, 30 Jul 2024 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360505;
	bh=12cZHpEVMTa6aQUh5Dg+SwQL01wOLkrmMPvzA3H1YBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZz151ciB7ptoYbI/8XBbrorAVlLduJOg4n7bHbxOg+2qcIQsyHHhuafiBDn91HI+
	 9I53PVqt/DvaEVxZGWYqqJz+gA0WH8i8KioF9Ir3RLPwsDh3X0igg1JhuqilNKBu6p
	 gWVFt26uYO3TFtpCiqLt2hjEaCggRMNohYcS0dfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwenael Treuveur <gwenael.treuveur@foss.st.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.10 719/809] remoteproc: stm32_rproc: Fix mailbox interrupts queuing
Date: Tue, 30 Jul 2024 17:49:55 +0200
Message-ID: <20240730151753.338017693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,7 +294,7 @@ static void stm32_rproc_mb_vq_work(struc
 
 	mutex_lock(&rproc->lock);
 
-	if (rproc->state != RPROC_RUNNING)
+	if (rproc->state != RPROC_RUNNING && rproc->state != RPROC_ATTACHED)
 		goto unlock_mutex;
 
 	if (rproc_vq_interrupt(rproc, mb->vq_id) == IRQ_NONE)


