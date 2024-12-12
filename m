Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4F2054EF;
	Thu, 12 Dec 2024 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020122; cv=none; b=QSpFHY6bJ/DsYkZEZm+UPLEVx5GBoarf/4H9KC4B73nsy4VB+d2nFvv0JRThMax9yg/ve0Nb5Mt4lNXKVZInicI0FgFbIfpygxweE3a6eJHF77XmgbwbVY5SsAv6sLps2h4LMIeZed6s30T3roFCbCGwOV2wFhXxYQbjCjtalik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020122; c=relaxed/simple;
	bh=Q2AkjSM5kQqcdQJaNE7ZAv7HTBFjKpT/zaNHgcml0eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCwV6++7WSlq8buijS+9Ae9xd5JBjKePYA0cOUp/eN445JrNO6WyOYnhNENZEsE8GwQuOEm3WOo0o5mep1bu+x8bi1s8pMloNQAroovnWgfKe2la8UAMSDjDY6LJtTYommWWmX14DZhzvTEoLkAwjlPheCtRTIp5UfFNhRKzp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VidVY5uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VidVY5uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FE1C4CECE;
	Thu, 12 Dec 2024 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020119;
	bh=Q2AkjSM5kQqcdQJaNE7ZAv7HTBFjKpT/zaNHgcml0eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VidVY5uvZNDxRGWj0uOXA28fO6oLf+IJtjCYMOhFCEO0aQRYPuhQf9vbhDa+RZP5n
	 4D3SZEBjw6aW9XmGL79cXDFFkkPUAJkAMJFTStO45KKVLahgVZV6WVc1bzVcLrXN99
	 JrVAGpAl00/FYrtO1d29y8/Igcok8LD3EzuqFJCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Shadura <andrew.shadura@collabora.co.uk>,
	Nathan Chancellor <nathan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Aleksei Vetrov <vvvvvv@google.com>
Subject: [PATCH 6.1 382/772] Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()
Date: Thu, 12 Dec 2024 15:55:27 +0100
Message-ID: <20241212144405.690785882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrej Shadura <andrew.shadura@collabora.co.uk>

commit 5fe6caa62b07fd39cd6a28acc8f92ba2955e11a6 upstream.

Commit 9bf4e919ccad worked around an issue introduced after an innocuous
optimisation change in LLVM main:

> len is defined as an 'int' because it is assigned from
> '__user int *optlen'. However, it is clamped against the result of
> sizeof(), which has a type of 'size_t' ('unsigned long' for 64-bit
> platforms). This is done with min_t() because min() requires compatible
> types, which results in both len and the result of sizeof() being casted
> to 'unsigned int', meaning len changes signs and the result of sizeof()
> is truncated. From there, len is passed to copy_to_user(), which has a
> third parameter type of 'unsigned long', so it is widened and changes
> signs again. This excessive casting in combination with the KCSAN
> instrumentation causes LLVM to fail to eliminate the __bad_copy_from()
> call, failing the build.

The same issue occurs in rfcomm in functions rfcomm_sock_getsockopt and
rfcomm_sock_getsockopt_old.

Change the type of len to size_t in both rfcomm_sock_getsockopt and
rfcomm_sock_getsockopt_old and replace min_t() with min().

Cc: stable@vger.kernel.org
Co-authored-by: Aleksei Vetrov <vvvvvv@google.com>
Improves: 9bf4e919ccad ("Bluetooth: Fix type of len in {l2cap,sco}_sock_getsockopt_old()")
Link: https://github.com/ClangBuiltLinux/linux/issues/2007
Link: https://github.com/llvm/llvm-project/issues/85647
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -729,7 +729,8 @@ static int rfcomm_sock_getsockopt_old(st
 	struct sock *l2cap_sk;
 	struct l2cap_conn *conn;
 	struct rfcomm_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -783,7 +784,7 @@ static int rfcomm_sock_getsockopt_old(st
 		cinfo.hci_handle = conn->hcon->handle;
 		memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *) &cinfo, len))
 			err = -EFAULT;
 
@@ -802,7 +803,8 @@ static int rfcomm_sock_getsockopt(struct
 {
 	struct sock *sk = sock->sk;
 	struct bt_security sec;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 
 	BT_DBG("sk %p", sk);
 
@@ -827,7 +829,7 @@ static int rfcomm_sock_getsockopt(struct
 		sec.level = rfcomm_pi(sk)->sec_level;
 		sec.key_size = 0;
 
-		len = min_t(unsigned int, len, sizeof(sec));
+		len = min(len, sizeof(sec));
 		if (copy_to_user(optval, (char *) &sec, len))
 			err = -EFAULT;
 


