Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA961A76A0;
	Tue, 30 Jul 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359641; cv=none; b=Loi0LdecvPLZddjd6Epqs7o7vvOUdvzECHxfFv8CSES8UKEj06PZwuAGzUIhDoibDgUa3pnD7Hq3c7uOVhACTPV1fliYoah9Q2WIONm1lJVUy73VnZuGHdTNS12N64rwFIh4xxSY9rI7Sn1qTedX2uQbKq4maGQg9beG559csNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359641; c=relaxed/simple;
	bh=K5KViGFPpT8zozcFrP0fHxm44FahVRRB6BCqNv5jxHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBag+wC14XIETs3Q3Sx79BPnk+L1/8stdugs/A3re7PDlPQV1D0R8ryjzLjvJj2B/QZRAv297QWM3rstpq/HbC0kcFdggjPbcYzp5WIFA9R1vEOFcWU8yI1KHWJ0Ll7ovdJp+DuT0EEheBQ+DpM8F4KCJq5yaqRn1Q2dzyhk11w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QiVw+LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QiVw+LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A13C32782;
	Tue, 30 Jul 2024 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359641;
	bh=K5KViGFPpT8zozcFrP0fHxm44FahVRRB6BCqNv5jxHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QiVw+LBslxKWhPf2W1Z9i5o0C3nN6e3WNI8Y8g30PGZDAYYBPbEAnJLYHYjnkL4z
	 AYM4dUH8y9tHMTF4Emac3t7HxPn7NT4n9htnS0nrLY0EIdkxeK69tDF3Qm7LyefFwn
	 ogfdssmFTl73fgJic3uJrd+uF8/Cch+aOrW1lc5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwenael Treuveur <gwenael.treuveur@foss.st.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 490/568] remoteproc: stm32_rproc: Fix mailbox interrupts queuing
Date: Tue, 30 Jul 2024 17:49:57 +0200
Message-ID: <20240730151659.181965524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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


