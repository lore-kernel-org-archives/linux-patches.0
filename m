Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06F21078F;
	Tue, 30 Jul 2024 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358237; cv=none; b=acN2NcQ/0eRY+UdQvFbO042eyuNNkL6RMYaZE6XraXjFB3Ulbf/xZMeCQInorJtMkXFTIA566QVlaDs4qY5gXeq3xq0bb47RcoahQDyK+BUA60he+q7rI/05Pj/q5MS8pf9M7UKJTodWFZlLWKmkQDcpQjA6jZPHsVyllLLbBdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358237; c=relaxed/simple;
	bh=VqlJ5Ot0r8vVvSAKOGffXuNZbaSgE285zV0Y9/u7upw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwIO0oibQ6GiEjpYHTahrUzUJaeFiu/jidlhSqzg1OD1Ol4hrxDKIc961gFKYisorh6fN24mCHIblZ03Y9Aw7egfrFnPKYxhf6IOe7PGi8OSXlRAY6iNoNMVnR3GtX20/4y9byM2BjIpCf630/kUEBdh02j8zmbtvJm8j0/njwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0a4AIz7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0a4AIz7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F80C32782;
	Tue, 30 Jul 2024 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358237;
	bh=VqlJ5Ot0r8vVvSAKOGffXuNZbaSgE285zV0Y9/u7upw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0a4AIz7RspeDr0gOyx3JzXgatpSwQvzC698SiHCfjIZI3De62zHT17aHN/tpKV7ta
	 QL+xj53EZK5Wx12UWxN5+UpDnlyirJbcmY6uzSxcSEFYZOTpKCdbeQA3Iy7RqL3h3J
	 IpY+zDcAefRLLrIwin+OfeSKDn8J+wmfvyocYcQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwenael Treuveur <gwenael.treuveur@foss.st.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 369/440] remoteproc: stm32_rproc: Fix mailbox interrupts queuing
Date: Tue, 30 Jul 2024 17:50:02 +0200
Message-ID: <20240730151630.229681700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


