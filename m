Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E82505A9;
	Tue, 20 May 2025 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750309; cv=none; b=tgOWTjuyy1jNZsNzE9xSvBywBlxXMWxWJDDg2K3lGki2VB0mpY4U4BQOpDDU31AIMkMPlOJDT7k2Z4LQRCrumZjcSwflGjORipmge9KchdzBgzxJfbs9uziHpa65HrInxOAUHi9xnP/ipiaEwFXksSL4QgHuNVBqUpEdX0nyGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750309; c=relaxed/simple;
	bh=yRssfUquttrLNr9CSC/t1q9st3M3aLhuDPcVvHnaKHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWopGfLbzYKwxlQQogr3Bjg4S6WN9nLVnkQgV7DBVjZguzNEPThstvsCBuE3d7CRhJQtokqNKxrOgJy9psdmJi7JweFqRp2XST9cwpwRnRY4YurWajvfZ80vEjYPHJNafV1oBg3Uxmq5iFdw0mL0plKgPjeV7OtA7MnnchDyrr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ax9dIF31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ax9dIF31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B91C4CEEA;
	Tue, 20 May 2025 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750309;
	bh=yRssfUquttrLNr9CSC/t1q9st3M3aLhuDPcVvHnaKHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ax9dIF31HneZSNsn4icBCugq/vG2nCQU3rOnKvh5rL4ETYGPsxUrFuvm4dgd0gvUi
	 VNgMRFZo893YftN5jiduj4AnQjzBDuLNtNjETv1CcluKR8OfwsIMcOze78Kl0/nmEx
	 mrumloMckRLfYb0vikM6IIml5WtbtQmgOs9Dy+60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 6.12 070/143] sched_ext: bpf_iter_scx_dsq_new() should always initialize iterator
Date: Tue, 20 May 2025 15:50:25 +0200
Message-ID: <20250520125812.819841965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 428dc9fc0873989d73918d4a9cc22745b7bbc799 upstream.

BPF programs may call next() and destroy() on BPF iterators even after new()
returns an error value (e.g. bpf_for_each() macro ignores error returns from
new()). bpf_iter_scx_dsq_new() could leave the iterator in an uninitialized
state after an error return causing bpf_iter_scx_dsq_next() to dereference
garbage data. Make bpf_iter_scx_dsq_new() always clear $kit->dsq so that
next() and destroy() become noops.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 650ba21b131e ("sched_ext: Implement DSQ iterator")
Cc: stable@vger.kernel.org # v6.12+
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6731,6 +6731,12 @@ __bpf_kfunc int bpf_iter_scx_dsq_new(str
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_scx_dsq_kern) !=
 		     __alignof__(struct bpf_iter_scx_dsq));
 
+	/*
+	 * next() and destroy() will be called regardless of the return value.
+	 * Always clear $kit->dsq.
+	 */
+	kit->dsq = NULL;
+
 	if (flags & ~__SCX_DSQ_ITER_USER_FLAGS)
 		return -EINVAL;
 


