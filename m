Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E147A7C;
	Wed, 21 Feb 2024 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523311; cv=none; b=QF++8gyNA4YtaSoyIffut1jJO5hX2qhLmMuD6fSul4OlvLs2OKN+4+4GwHOotlQAig/Tsag62EMSELOtBLMwIQzIcBnS5T4ff1X6fcutbLnAmD7ggGRSrRyNVzuW32hIaq1dbR5p+o1WKFujmSaB+eMYxDKEsxnf5QzPHcNeSAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523311; c=relaxed/simple;
	bh=w/AH8CEczgCARr6SyUyA5wiJF71GAjcI+4LGqsY5x8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7luPOFSTrPyIk6gtXpoPzrG4QOpZQlArO5iPqRtxjFLuyLGN8UeB5aU5EV+Id6j3qdjgFIE/GxHq524kvzoztItWI75RIZvC0d810rjtbXWLR52xCB3iAXJKaPPJmrkKPdYCKSK4fxsxnpAYT/FDbMtY8p8RkGAB/lTbmisvQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmDk5co7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmDk5co7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B31EC433C7;
	Wed, 21 Feb 2024 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523311;
	bh=w/AH8CEczgCARr6SyUyA5wiJF71GAjcI+4LGqsY5x8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmDk5co7CtyjAL58zQjz36XhW1txhAiMKA0gHXnOEsiE8eT7xqeNtFLwi8pWCUB8e
	 2hv+gf93Zx+DPl56N0ksjEmaQOSfBk7bBfY2A7mBT8BIqfr+L11fhXfiwUr0NMnKqY
	 ePYbyzw4bGFNRaA7FVvmGr7uvB1NAtdRXy20M7iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 398/476] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Wed, 21 Feb 2024 14:07:29 +0100
Message-ID: <20240221130022.714321004@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1061,7 +1061,7 @@ __poll_t ring_buffer_poll_wait(struct tr
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


