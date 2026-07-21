Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080873FFAD1;
	Tue, 21 Jul 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655772; cv=none; b=tf0yQzUHOAVAjUsFa8AZKr34vpl2LusRgg+LpZ7UcWnlbaQ6FBlnIt0d/W9EBqzT/xtt0MiHG63MfkEZM/XAZtQB58FJdx/+yvDYgQe6/XoYSbk5r+znJrqPfifYI4T9R3aIktS1/UZsNQZyVbeSJrt2BPwuiBAZjufbu0dYM7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655772; c=relaxed/simple;
	bh=uX1TFoFmHp3s41wK4xd0cVaSj/v4V7louZzn5RsQkYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LERdSnuCltnqQwkwt8szHYCdKEQJcm1LFpzE4DPzj3l3GtClqNhQyAxVUhlq0Atzb3GWaLnO5jMxHjjHZ6KwG24l2ybIVztYkX3gTnjuKLNCskm61SZ8DE+J/TKifPvneHW515cCgWGPw+8fw8oFjCvGF0mafD9kCcjRdZr6ZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSv4mG9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSv4mG9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F11F00A3A;
	Tue, 21 Jul 2026 17:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655770;
	bh=Qs5Gg6NQG5qgry7TO0mMYwc3Oul0GiK8K1O+spC+UyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSv4mG9mUQFAr5sS/AzRS6t9dXPzY9H/n8zXRKtdkGYE4Ksh60nZTc5xy9A/SPIX+
	 SYW0ctYaAKjtcTRgVcJKxY5jgWZj9zNk6NYnMMVhicuxgcOfQL9jiHAHm107ZDCi2r
	 o0ndpjhedyCgrWAV4sQaWaudG31mWVGpGPiYwxIw=
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
Subject: [PATCH 6.18 0134/1611] uaccess: fix ignored_trailing logic in copy_struct_to_user()
Date: Tue, 21 Jul 2026 17:04:10 +0200
Message-ID: <20260721152517.888258701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 4911de3145a797389577abfdf9a5185d36cc18d7 ]

Currently all callers pass ignored_trailing=NULL, but I have
code that will make use of.

Now it actually behaves like documented:

* If @usize < @ksize, then the kernel is trying to pass userspace a newer
  struct than it supports. Thus we only copy the interoperable portions
  (@usize) and ignore the rest (but @ignored_trailing is set to %true if
  any of the trailing (@ksize - @usize) bytes are non-zero).

Fixes: 424a55a4a908 ("uaccess: add copy_struct_to_user helper")
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
Link: https://patch.msgid.link/71f69442410c1186ed8ce6d5b4b9d4a5a70edbad.1775576651.git.metze@samba.org
Reviewed-by: Aleksa Sarai <aleksa@amutable.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 7657904c8db9c8..6973fee49f091c 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -499,7 +499,7 @@ copy_struct_to_user(void __user *dst, size_t usize, const void *src,
 			return -EFAULT;
 	}
 	if (ignored_trailing)
-		*ignored_trailing = ksize < usize &&
+		*ignored_trailing = usize < ksize &&
 			memchr_inv(src + size, 0, rest) != NULL;
 	/* Copy the interoperable parts of the struct. */
 	if (copy_to_user(dst, src, size))
-- 
2.53.0



