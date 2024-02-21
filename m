Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8B07A708;
	Wed, 21 Feb 2024 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525779; cv=none; b=bcuIK3rJWX6buf67ybjbJVV8mft18fEIOB5a+p1EhE2kTN9wy23lhqPabELBog27pelxXPwbG1s6Rkaj6BMQdTcAhdBu1GHM/T2/3DLRdbRQy5WchJFifdWVrc1wXA18HuNeZbNO49noHl+MFOjI5N8H+RJW+OgwztSnVfBGAzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525779; c=relaxed/simple;
	bh=JubmUaFeXSbVmJgoho3HeZdaCMGYUy1tqMQ3LAyoS58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYf9tPh8MdaV/gSG4FUjmdDPmuOj673vzUPPM291eihpjL+Ow+nEXyg5LksDsm+MZy6+9tqpacc75JciZC2UNPIaupCKQHzqxa1rjBvuMtsBjvciF5sd60RyzWlHMaonVGBDxJ2WoXo+vHgiGGfT4F9giFVHYZkSn4bfksFQxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGJVFLUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGJVFLUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2879C433F1;
	Wed, 21 Feb 2024 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525779;
	bh=JubmUaFeXSbVmJgoho3HeZdaCMGYUy1tqMQ3LAyoS58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGJVFLUu/gOLDJvyUOzomTz37Xfij0wKERE2ss0tyr1HpyBOOsyYC0qZgKHgwoCza
	 4R3EoTXVMtxwiTcDLRoWNlHk5O1YLoDOLDbuPeoupzBngide8haMdjLCxEEMXUkmBZ
	 lOAiTyzp1arZEsyhCbWBjRnJn+vagIrPS4FM9PC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 233/267] ring-buffer: Clean ring_buffer_poll_wait() error return
Date: Wed, 21 Feb 2024 14:09:34 +0100
Message-ID: <20240221125947.564068988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -738,7 +738,7 @@ __poll_t ring_buffer_poll_wait(struct ri
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -EINVAL;
+			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;


