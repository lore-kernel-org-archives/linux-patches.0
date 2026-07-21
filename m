Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E209446AA93;
	Tue, 21 Jul 2026 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648398; cv=none; b=J1R3W/yANAG6/PycjsUvMiNJuk2nOZwZLZZwH7GkRjrZEGjXZuEmfWFerQRLyJ5Sy+4V+nFPyGiHrZ9/8eFXTHY5zemqIyQVAkp6IlJQcB6cnBKIgTn0ysTvDwefo8c4667vjNorzsxkzyfN1yi1M+WvKWbAILrFUeFWtPC19BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648398; c=relaxed/simple;
	bh=yetQ53dELWRJINn29v7eetvLe1tM/VWTfka+ZAVmpDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClL20CVj6PMWQof69H4KMSrb5I8xzmnnUNH3XLr/aYr+W9EiFsD/hUmF6ORXbcikNGxgfduAK5sAdGKW+apsyWYeZrLbC6KVaRzVwj1+5DKiPPrvagrByd2JgsjxSHwP9XlFaQKdXlWry1MNdKK8Otcl4VXGCQZMHsAeNhkD1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT22enfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT22enfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5238C1F000E9;
	Tue, 21 Jul 2026 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648396;
	bh=PDbcKYJ2dts9E8rmBpMaJS2oKdH/H1ecsS872g4HAMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gT22enfOzixYhiVY9rvl+GbZP0du3BnZesIKu/dYNInWsHP8/T+4eZwQuZ5w3HXHt
	 /781bTcXBnGa7L7bwScCeDXk8FHiJG9lV+LTvMCR5/JngGfsKlTldTBgyvKwsILM5b
	 j1euTEw8QK1g2xCkru2QTdPTWYL39kGQAFimMDGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Dmitry Safonov <dima@arista.com>,
	Francesco Ruggeri <fruggeri@arista.com>,
	Salam Noureddine <noureddine@arista.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Luczaj <mhal@rbox.co>,
	David Wei <dw@davidwei.uk>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Xin Long <lucien.xin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	netdev@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Aleksa Sarai <aleksa@amutable.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0185/2077] sockptr: fix usize check in copy_struct_from_sockptr() for user pointers
Date: Tue, 21 Jul 2026 16:57:38 +0200
Message-ID: <20260721152557.048001055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit db0493512931fe1e5a71612e6a358df1aa22d80c ]

copy_struct_from_user will never hit the check_zeroed_user() call
and will never return -E2BIG if new userspace passed new bits in a
larger structure than the current kernel structure.

As far as I can there are no critical/related uapi changes in

- include/net/bluetooth/bluetooth.h and net/bluetooth/sco.c
  after the use of copy_struct_from_sockptr in v6.13-rc3
- include/uapi/linux/tcp.h and net/ipv4/tcp_ao.c
  after the use of copy_struct_from_sockptr in v6.6-rc1

So that new callers will get the correct behavior from the start.

Fixes: 4954f17ddefc ("net/tcp: Introduce TCP_AO setsockopt()s")
Fixes: ef84703a911f ("net/tcp: Add TCP-AO getsockopt()s")
Fixes: faadfaba5e01 ("net/tcp: Add TCP_AO_REPAIR")
Fixes: 3e643e4efa1e ("Bluetooth: Improve setsockopt() handling of malformed user input")
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Michal Luczaj <mhal@rbox.co>
Cc: David Wei <dw@davidwei.uk>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
CC: Kees Cook <keescook@chromium.org>
Cc: netdev@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Link: https://patch.msgid.link/cfaedbc33ae9d36adaabf04fa79424f30ff1efdd.1775576651.git.metze@samba.org
Reviewed-by: Aleksa Sarai <aleksa@amutable.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sockptr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index 3e6c8e9d67aef6..ba88f4d78c1b16 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -91,7 +91,7 @@ static inline int copy_struct_from_sockptr(void *dst, size_t ksize,
 	size_t rest = max(ksize, usize) - size;
 
 	if (!sockptr_is_kernel(src))
-		return copy_struct_from_user(dst, ksize, src.user, size);
+		return copy_struct_from_user(dst, ksize, src.user, usize);
 
 	if (usize < ksize) {
 		memset(dst + size, 0, rest);
-- 
2.53.0



