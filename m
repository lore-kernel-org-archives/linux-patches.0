Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C97E151CC8;
	Tue, 20 Feb 2024 21:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462803; cv=none; b=ULU849tAizHVIZZhZrkd7IGIcTrv+LvEzxBGCNQ6d6yqrz01keZmfzeXIn37TDyYQPyiTj52LjYdgbfn0VsPxxUhkQ5e7CzEzbJBDw2zXlX9RGYibvAUXBbWLgT6UA8jWM6MBJzng7GFmUR87yTgo43st5akBDqjCTohYTQG9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462803; c=relaxed/simple;
	bh=wKAr7b06lzenJiSnKWAiRe5vTFMT3IrSVOIcQLEyVLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgTgreTmrqI3gZqyU/qXiT+3gAVc7Ae2Ojek1zpZyJEJBSjwUdL+AWFsuTeUr5EckGF4Tql+yfOWQgl1kAdkB5t2Cct0n9Rm1v9OhxoOy96HPp/kMkRG4GL6nAwgZDt/4HilLdndWZriTBAt60yKGF9tHmeTBIJfLgSf3Bb8HbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPXSDVKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPXSDVKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FC1C433C7;
	Tue, 20 Feb 2024 21:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462803;
	bh=wKAr7b06lzenJiSnKWAiRe5vTFMT3IrSVOIcQLEyVLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPXSDVKAXvHcNvflOfAil41Q06SVLN9w7zUxuZ9IDIaV/GHSXBcCjRnYNa+Wl+QaM
	 /q1/Jx5rqhfAhnMv9czUs6EMFfP2Ggxg8ROagynWOlpNnkUrd1BGnL46vKX56C6bBH
	 xAumSCx45to1Bk+fGotJ0s0kTaOkmXZBCdBL1MF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.1 012/197] driver core: Fix device_link_flag_is_sync_state_only()
Date: Tue, 20 Feb 2024 21:49:31 +0100
Message-ID: <20240220204841.451519912@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

commit 7fddac12c38237252431d5b8af7b6d5771b6d125 upstream.

device_link_flag_is_sync_state_only() correctly returns true on the flags
of an existing device link that only implements sync_state() functionality.
However, it incorrectly and confusingly returns false if it's called with
DL_FLAG_SYNC_STATE_ONLY.

This bug doesn't manifest in any of the existing calls to this function,
but fix this confusing behavior to avoid future bugs.

Fixes: 67cad5c67019 ("driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -337,10 +337,12 @@ static bool device_is_ancestor(struct de
 	return false;
 }
 
+#define DL_MARKER_FLAGS		(DL_FLAG_INFERRED | \
+				 DL_FLAG_CYCLE | \
+				 DL_FLAG_MANAGED)
 static inline bool device_link_flag_is_sync_state_only(u32 flags)
 {
-	return (flags & ~(DL_FLAG_INFERRED | DL_FLAG_CYCLE)) ==
-		(DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED);
+	return (flags & ~DL_MARKER_FLAGS) == DL_FLAG_SYNC_STATE_ONLY;
 }
 
 /**


