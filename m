Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1C446C9;
	Tue, 20 Feb 2024 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465038; cv=none; b=ML6CKK25ZzTPNGJ/PUC7uC0qx75YKXh+p9ORzM654y2MA9fMw/OkpVrYALhPVuCEHPsZx5hfQTWMeRbv8p84PT3FDV5chhWBirjxYjMlgnI5z24kEQFaMDtM/+puem+Lnl5xOhkzrCpVo4BvTSAQyG10ZUIVYJOASMuIkShjyaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465038; c=relaxed/simple;
	bh=FYa3tFTEYjn15NvlaLvIbyvYLsXWolBBa4A4AfXY8+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5ge1q36DDJtGj1nljCPwUJ1bWHbM252qS09dQ9J+4s5I9nNPHVY1N4OGFvycdvgSmxoRe6PVOjB4Dp1i9QTET5dFuoT6U2qVhMFpgyWxgh4wKVsJB6pbKaFQIoqEyEuQ9F5b1YHn6wJgZdOhbeLe/wrZ3oUSn6qlwRTGnn5o28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTMbyPw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTMbyPw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E9C433F1;
	Tue, 20 Feb 2024 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465038;
	bh=FYa3tFTEYjn15NvlaLvIbyvYLsXWolBBa4A4AfXY8+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTMbyPw8jABul/k7z935WK44ECoyPmKkQdh+387lW3NRL2ylpU9wkEkKMf3pb7eg8
	 y1jc9grEG4sgwoXONMbeYHZRQ756h0dJFf85HngTIR+TIdRoR67OAz8XACGDG9N01r
	 +Ex4e8E2snnPOzuFunGB7bvN+sA81wryZrAX7hL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.7 216/309] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Tue, 20 Feb 2024 21:56:15 +0100
Message-ID: <20240220205639.927475313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit 66bbea9ed6446b8471d365a22734dc00556c4785 upstream.

The return type for ring_buffer_poll_wait() is __poll_t. This is behind
the scenes an unsigned where we can set event bits. In case of a
non-allocated CPU, we do return instead -EINVAL (0xffffffea). Lucky us,
this ends up setting few error bits (EPOLLERR | EPOLLHUP | EPOLLNVAL), so
user-space at least is aware something went wrong.

Nonetheless, this is an incorrect code. Replace that -EINVAL with a
proper EPOLLERR to clean that output. As this doesn't change the
behaviour, there's no need to treat this change as a bug fix.

Link: https://lore.kernel.org/linux-trace-kernel/20240131140955.3322792-1-vdonnefort@google.com

Cc: stable@vger.kernel.org
Fixes: 6721cb6002262 ("ring-buffer: Do not poll non allocated cpu buffers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1091,7 +1091,7 @@ __poll_t ring_buffer_poll_wait(struct tr
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


