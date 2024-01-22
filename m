Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA33205;
	Tue, 23 Jan 2024 00:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968247; cv=none; b=r1gtRVwcdGmrJfIn5hxQ4KqRp0Ckr8oDxgu7BHFvgS+ipX+S0v5O+vha836ncXiYWF2KnJ4WqwDkW//qcJrPUDbwS46/S6qzJUhMfLBnjN2zFL1emttIoNNjCPeKZSZ1wxWld05RuOFahMabGiRHw1EZ96kaGvqKubu+EqueVbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968247; c=relaxed/simple;
	bh=VccSRJGDjsoiNrVXuORq4aOmdhwBYINX5Qy4HZmB3Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYTBEWKl2zcBeE9SNJ7mMGUjfoEIdBtIs0qrL9xRtYpTOhA0tSD3cN0jRHYIpzizu2ltjysb2TAjT3E3ofSSnpmNNpEN6IHs/n7zaP+QLIk9Nu7MsBqLZAM7MYKsX3lXicleIlNZ6aQkpVPaGBJL1rXnvderWL9DrUu7Dql0Gjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqhhPdv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqhhPdv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D26C433F1;
	Tue, 23 Jan 2024 00:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968246;
	bh=VccSRJGDjsoiNrVXuORq4aOmdhwBYINX5Qy4HZmB3Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqhhPdv/njv+TyZ2fpHsRHJlbEYQj93Vc2p0q+n18p3iaasM/HuC4j4+eyTTGRoK1
	 hPEv39TZDQ5E+AUyFzLFSpV+BMoi3kqmxdQ8pdoPaCWDlny/gi59/HtwGi0nXO8W3W
	 gQ9xzYGx28B6o3Fanq2hb9pe8dKVIzLhFDmJz86U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 4.19 023/148] binder: use EPOLLERR from eventpoll.h
Date: Mon, 22 Jan 2024 15:56:19 -0800
Message-ID: <20240122235713.366562646@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 6ac061db9c58ca5b9270b1b3940d2464fb3ff183 upstream.

Use EPOLLERR instead of POLLERR to make sure it is cast to the correct
__poll_t type. This fixes the following sparse issue:

  drivers/android/binder.c:5030:24: warning: incorrect type in return expression (different base types)
  drivers/android/binder.c:5030:24:    expected restricted __poll_t
  drivers/android/binder.c:5030:24:    got int

Fixes: f88982679f54 ("binder: check for binder_thread allocation failure in binder_poll()")
Cc: stable@vger.kernel.org
Cc: Eric Biggers <ebiggers@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4462,7 +4462,7 @@ static __poll_t binder_poll(struct file
 
 	thread = binder_get_thread(proc);
 	if (!thread)
-		return POLLERR;
+		return EPOLLERR;
 
 	binder_inner_proc_lock(thread->proc);
 	thread->looper |= BINDER_LOOPER_STATE_POLL;


