Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22EC15B10D;
	Mon, 28 Oct 2024 06:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097137; cv=none; b=RZCgebcc2lJrgLLocKBNxJzcbJlaQE6IS7GzUx/cF0GcSUJUk+AYU+iRA/lgEhJ4cqn3/oVfjBWSR6/FBS2buhYI0ZwjLKrYq06cho/aFIsWqX7yg+zQEBmCBNis58OJxV+jzrLTSTHpul0rlNUQcTgBqDhpIrpRkxu4nfgPegI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097137; c=relaxed/simple;
	bh=00P6b4bql9zn1pHxMaDEa6uhkZLxbiPiCDEkZiDkNoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owQ9lEVWymdrADmlkvQPyV/3XhQRKSe2Q7y9wN5KGmneYKBTGYD2pJZUpt9bguL2rdQcPLv7OZi1bllI/ERmrycV3YVnwZXLCHjmk2pucB+Dlz7WbUPnkBvuRookHAGlotHIElemOwGPzMl87rw5nxeYlpsayxMy6+tyC4EH5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pr3w9TD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pr3w9TD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50114C4CEC7;
	Mon, 28 Oct 2024 06:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097137;
	bh=00P6b4bql9zn1pHxMaDEa6uhkZLxbiPiCDEkZiDkNoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pr3w9TD+4DmUhk//48aZjezBfujdvKAXSP/baSK8stuG8Ls2IWFHk3qkMqqmcb4SW
	 sl8n/o+Qz7FbTDmn14Rf141/DmyC7xyeBemCyQDpAnqMaPBWRCDjGmuyNtCUajh3Bw
	 uWNAid+AMVPm6Jq9S1Zne5oGxAIzdlnUS1bjioEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 72/80] openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)
Date: Mon, 28 Oct 2024 07:25:52 +0100
Message-ID: <20241028062254.609419406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

From: Aleksa Sarai <cyphar@cyphar.com>

commit f92f0a1b05698340836229d791b3ffecc71b265a upstream.

While we do currently return -EFAULT in this case, it seems prudent to
follow the behaviour of other syscalls like clone3. It seems quite
unlikely that anyone depends on this error code being EFAULT, but we can
always revert this if it turns out to be an issue.

Cc: stable@vger.kernel.org # v5.6+
Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20241010-extensible-structs-check_fields-v3-3-d2833dfe6edd@cyphar.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1296,6 +1296,8 @@ SYSCALL_DEFINE4(openat2, int, dfd, const
 
 	if (unlikely(usize < OPEN_HOW_SIZE_VER0))
 		return -EINVAL;
+	if (unlikely(usize > PAGE_SIZE))
+		return -E2BIG;
 
 	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
 	if (err)


