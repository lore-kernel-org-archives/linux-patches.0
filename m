Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572E763F6;
	Wed, 21 Feb 2024 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521718; cv=none; b=ZvqZdNBsfpzfhHZgzOfexL8CR02JDKhxK2Ns+lfxWrelK1bSbMED7fm/5AQVFPLbxvqyoNuH+T68VtNIt5ygIvVV3DnPMKW2Hl4+01UcC3LLXghyG9KaxGafE2LE8zs/K5XrnmzwuFlrXm/vk/2SXaxT1hUhSO5HWDgr5gvtYVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521718; c=relaxed/simple;
	bh=5Ah1NTqH80hvILYxu/r6F1TX1zzwhiBx4x34jxJlPI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVYzclfBMBW5E/eTaAz+g4z2MenrGLPCRDhzgQPdI3S8k3WXcy7k52un5uTK2c2nVqWLijW9MzCf8cn9NkvNVVQPdibjRoCKVR7yYo4031384mxMGOus730VJT9/WcHyauSqqzT35q47ishV2QMesTihXWF4cV02CmIyiLBSll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOcdP537; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOcdP537"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4899C433F1;
	Wed, 21 Feb 2024 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521718;
	bh=5Ah1NTqH80hvILYxu/r6F1TX1zzwhiBx4x34jxJlPI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOcdP537zrmKtEvRnpSr9ZmIfLz6h+4mHdj16j/t0nwjVGn7iQze4oSi6JrX3YsCG
	 /P9L0gWd5h4SGdVWlygnJk3Lzu3uom7A6C/J1xZpq5MooxMTbq/erc8SGoKTWGxms3
	 ttuWL0Ct7fdKnBx8ZCTXI5Iooki4Gom0Hban50JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 186/202] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Wed, 21 Feb 2024 14:08:07 +0100
Message-ID: <20240221125937.821512649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
@@ -676,7 +676,7 @@ __poll_t ring_buffer_poll_wait(struct ri
 		work = &buffer->irq_work;
 	else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


