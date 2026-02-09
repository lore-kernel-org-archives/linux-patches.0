Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF33E35CB6B;
	Mon,  9 Feb 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647257; cv=none; b=NX7oHYpBRY8s7ygPiQUvy+SX+R1TKzTZT3LPG/+WtGU+3DbzUMyp/MJz4B1vmba5PcGFEqzylawSJOT6BbsGcRlIk/34M7FWnaORtGhtqZ3rn9WkfHIoukeZ93RTPF1qhvkITM1UwGaNN84vdlDtVbiGRBuBvey+Ny7oXA83gRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647257; c=relaxed/simple;
	bh=xzP5bc3NP6VarLakrEdDgRI0e/wOAFEr0TlJNUgzZ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYt/KdFBddFfh3d8hoejo+JVDX/ynj5b2kpfOHkUMagoTAT4jPPEBELnIQQksmhNT6y2IqbEf61Z6vdy1f+OmcqFJgyMYK5FntD2gmNxUCQ43saO15JEuC3VDj+eDlypd6ffpp0lhbRiTQ99lgRypxhqpe+HnqyiXo6mrDPTMDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNy6ByPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNy6ByPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CD8C116C6;
	Mon,  9 Feb 2026 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647257;
	bh=xzP5bc3NP6VarLakrEdDgRI0e/wOAFEr0TlJNUgzZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNy6ByPdy7wliVJI0tqdE/4+uVmr9OVSHrLhDxptrZ0klDEbACi4HcV+xTOD1d5pv
	 Dc0L9j+3rQt8zWflx92tOirRyYr7N/gs6Q9c5qUxYjpaD5bBs9qQfzMoAFYcNKZtPL
	 rh2q38QrJRmVgEloAnhC43O4EuXTQD4U3cplu6xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Steven Moreland <smoreland@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 045/175] binder: fix BR_FROZEN_REPLY error log
Date: Mon,  9 Feb 2026 15:21:58 +0100
Message-ID: <20260209142322.093496884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 1769f90e5ba2a6d24bb46b85da33fe861c68f005 upstream.

The error logging for failed transactions is misleading as it always
reports "dead process or thread" even when the target is actually
frozen. Additionally, the pid and tid are reversed which can further
confuse debugging efforts. Fix both issues.

Cc: stable@kernel.org
Cc: Steven Moreland <smoreland@google.com>
Fixes: a15dac8b2286 ("binder: additional transaction error logs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260123175702.2154348-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3824,8 +3824,9 @@ static void binder_transaction(struct bi
 	return;
 
 err_dead_proc_or_thread:
-	binder_txn_error("%d:%d dead process or thread\n",
-		thread->pid, proc->pid);
+	binder_txn_error("%d:%d %s process or thread\n",
+			 proc->pid, thread->pid,
+			 return_error == BR_FROZEN_REPLY ? "frozen" : "dead");
 	return_error_line = __LINE__;
 	binder_dequeue_work(proc, tcomplete);
 err_translate_failed:


