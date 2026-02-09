Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB536828A;
	Mon,  9 Feb 2026 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648217; cv=none; b=Cwgm8hOsLys1ThEbEpNpnz7iDjPuxHznVGNpotxJ1jEIRg6m7AiU0EuxusX/6PN0uNO4sCozUn301Oodetucv0KYWoOjqO5ntQausNp+WYYHncg0xSDG4AUZOwdlvX+o4Dn1SqJlVARO+3bzjfsZnfR56eaXqUn8Y9ogCzvPur4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648217; c=relaxed/simple;
	bh=HjOygMWFhjTZWzU2k8Gudli/v9f5/Rwknvd10d0WUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaE7YTsixVIXTLwKbgkVyq4oV89W3+d11MYjioVVufkVUHDG6cSW9JT1OE+voIxTii9u+rUZ9vPxMzwZ8NqI6S+eO4RKtDPn8WuI/SN7uSt92/ubPhLlqq2gi8w/fNQovpQ8CIsQ18LNRNgB6o9C/uv1fdDpy8DM2r8e9wxyopE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vND6z1N6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vND6z1N6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE8DC116C6;
	Mon,  9 Feb 2026 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648216;
	bh=HjOygMWFhjTZWzU2k8Gudli/v9f5/Rwknvd10d0WUvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vND6z1N6y9JxkwaojDUCqGcDM6AiJOXhA2P5GEdaZziq7UFYfE66Rnl6NxlVSbHjO
	 cNeXoU6ZIDvpSnoS4HY4cPScMbZCuC9Xt1feefrjqxh+v29oEwHY7CJaEZwO/idsTZ
	 MspM4N8S1aoJNIkj6XFJaM49hFp3ESpGAa+ldWKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Steven Moreland <smoreland@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.1 09/69] binder: fix BR_FROZEN_REPLY error log
Date: Mon,  9 Feb 2026 15:23:37 +0100
Message-ID: <20260209142302.252780708@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3642,8 +3642,9 @@ static void binder_transaction(struct bi
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


