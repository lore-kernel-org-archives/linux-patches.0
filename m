Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583431D07BC;
	Wed,  2 Oct 2024 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878929; cv=none; b=T6m3IVtBvj3xeHp2Mv+J7+W+aBapb6k4e65azvgeOLG8KS8bSJ4SebZ9KCoQw8SW+Cf8+uelx7R6cC66OvhZLdA+5usczSN30aSPcAGenZNZ0aPHquWi47A/kqjnsTAzFl+2yaLl1mPM9GLdYERUEgiaIHVUoW0I+OOlBaUr1yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878929; c=relaxed/simple;
	bh=8K+sl8h0yWRTy8U/t4iCP7//WBbRT+HVRTXpOxjFDLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aq3GNuzos6EJ1QA34JIgQBxzO0W8t+N6auYsKs8nphTk8GrxWx35+ZSDc0Beuf/egnt/sztkS8ppOQcPW9G5H2tpFpzckQVb/htuHI5xi9nY+j2bjllb684C3O5oHA8Avlo2sxONAXJyEZlQW3BBZWKJ0RLRjSYsdePD/D3UtRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/VtM1D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/VtM1D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71A5C4CEC2;
	Wed,  2 Oct 2024 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878929;
	bh=8K+sl8h0yWRTy8U/t4iCP7//WBbRT+HVRTXpOxjFDLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/VtM1D5RV45/XJP6XIFKp7K7PM3gY3gB40Xsu0a//gzG7lrx2TPJNWJdt4x3f04h
	 3L+mBPTbUjylfH+l3dmyIak2IDFt1Mz8TGxE0d3kxRdscx8hW4Z9sKr8vuMh9BMTiP
	 RDeg+DlZRI7J0P95Gmio8lLeWKWu3c5nTOtiwjt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Joe Damato <jdamato@fastly.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 581/634] eventpoll: Annotate data-race of busy_poll_usecs
Date: Wed,  2 Oct 2024 15:01:21 +0200
Message-ID: <20241002125834.049870160@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Martin Karsten <mkarsten@uwaterloo.ca>

commit b9ca079dd6b09e08863aa998edf5c47597806c05 upstream.

A struct eventpoll's busy_poll_usecs field can be modified via a user
ioctl at any time. All reads of this field should be annotated with
READ_ONCE.

Fixes: 85455c795c07 ("eventpoll: support busy poll per epoll instance")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Karsten <mkarsten@uwaterloo.ca>
Link: https://lore.kernel.org/r/20240806123301.167557-1-jdamato@fastly.com
Reviewed-by: Joe Damato <jdamato@fastly.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6c0a1e9715ea..145f5349c612 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -420,7 +420,7 @@ static bool busy_loop_ep_timeout(unsigned long start_time,
 
 static bool ep_busy_loop_on(struct eventpoll *ep)
 {
-	return !!ep->busy_poll_usecs || net_busy_loop_on();
+	return !!READ_ONCE(ep->busy_poll_usecs) || net_busy_loop_on();
 }
 
 static bool ep_busy_loop_end(void *p, unsigned long start_time)
-- 
2.46.2



