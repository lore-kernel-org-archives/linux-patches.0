Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B383B05A3;
	Sat, 17 Oct 2026 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255209; cv=none; b=EOeEOstPF+fObGYfo/x/4wNt9TWVGeEPNyN6HDjv6gIU043p9Dt3QV6kQHkWIqGeCBWNKFkB9Rt+38p45ZIb+zaaJyLYNA8BLgWx6hzOY/k6xdBgECr0oHKaOyK49l/QfTRkppym5ThgnyD3pyzjnbyjyJunL2TJqJsSFlqkgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255209; c=relaxed/simple;
	bh=wCEmUaoe3bub30UlC3A7UFiDWpq3YkyNW1ntUQgaOBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyC/vOC3Tr2gUWr22npaPWe34MvxlrEJUPdCo66+vYHRbHxnbVfZvlfVsFFUXE8auRa55FnT0SzJrM+ku5W4IEEJzrhute+DMP0mJ97Wmlt9XNC4RIw/Bu50I8CmEBAydvMll3dV0W3JviAdqGpTj16iR8FD/ekm8Q2oWhxkFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnKrlpKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnKrlpKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7941F000C4;
	Sat, 17 Oct 2026 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255206;
	bh=d4LTkG/MF2a8bvxSHKAOKcwmcCympV36jN5mLVEFRLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnKrlpKZcjtPvEYGqnx/atlJp8V8OVCceBhgvuA6QSrorPinzTQRMqVlmdZZHKc+L
	 mAfsnJhHMZDJHyidIP/YOAM8l7i818boI7gNKLb0/gZrJDVP2TUGj7JJcgrfnisCT4
	 QuUwoRuRRZ6oaptUtznCXlCQGPy4+RD6IppK2YbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 698/869] bpf: Zero queue and stack outputs on lock failure
Date: Sat, 17 Oct 2026 17:58:59 +0200
Message-ID: <20261017160054.864978424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7ac6e1ae41a09f1dd4baeeff1d028ae49ee01232 ]

Queue and stack pop/peek helpers accept an uninitialized output buffer
because the verifier expects the helper to initialize it. The empty-map
error path clears the buffer, but a failed lock acquisition returns
-EBUSY without writing it.

Clear the output before returning -EBUSY so BPF programs cannot observe
uninitialized stack contents after a failed helper call.

Fixes: a34a9f1a19af ("bpf: Avoid deadlock when using queue and stack maps from NMI")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260719125419.1782196-1-memxor@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index d869f51ea93a0..36384342d7d89 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -99,8 +99,10 @@ static long __queue_map_get(struct bpf_map *map, void *value, bool delete)
 	void *ptr;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
@@ -134,8 +136,10 @@ static long __stack_map_get(struct bpf_map *map, void *value, bool delete)
 	u32 index;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
-- 
2.53.0



