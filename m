Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFAA7E787;
	Wed, 21 Feb 2024 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524717; cv=none; b=ottPEBnrF8K804QvCEW8/26zuboHsYU0AER5uDAoQ/BEPKs/FXYolO10/2QulxAxAqOh0l2egai7CEMw43+JI4hkyhd9swV6N70eHItIbhoKhaONnXwIWSNkhUJMkdzUNL6Mq0gW81+pNH7OYlq0lwM30aBHquT9zf2vA19UETU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524717; c=relaxed/simple;
	bh=fX0XDcRwomZXHUDi5TXnkd3YX3J0GnfrpPdnFkAKNPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYX27v8iqSM6YJi8dOjo7RscmJBRgHyoJYSFtZbgeugAAi0PQ3SsjckteNyIXVV131MIKpjgEB/SPioTaujDF7pKd3olU1GLcMrj0ZTgm/BZidZ3wfpLYQuCf/3thVzOLN/T5h73HcE0mzOTmY5Pcph3pfdjIbY1YzR4e4zXJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iV+AV9GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iV+AV9GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AF3C433F1;
	Wed, 21 Feb 2024 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524717;
	bh=fX0XDcRwomZXHUDi5TXnkd3YX3J0GnfrpPdnFkAKNPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iV+AV9GPcMmD49dhMRSRuyJ8GNW/3UH0Djw4uMvKJORcXU/owOHQQv8RfeNPnmCBe
	 T1rEQoTe9GYbE5HRsdWqrhBCjx50elcYHbYNPXLtIShixENEvhkbXGrHiV5/BjWT17
	 crcMjvInYoYAGeL6PLLgm3/zpv8sX39Lmf4gQ+FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 328/379] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Wed, 21 Feb 2024 14:08:27 +0100
Message-ID: <20240221130004.666261362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1008,7 +1008,7 @@ __poll_t ring_buffer_poll_wait(struct tr
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


