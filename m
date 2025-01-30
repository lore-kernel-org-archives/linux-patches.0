Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E4F1E6DCF;
	Thu, 30 Jan 2025 14:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247323; cv=none; b=RHTuX6T6FL8DMwEn4sSidMj62zBDwGEvtIEuvbVcHVYycegr6Mb6RqylWnwSm0ogq6RZ3DNyXL3dJbWIqwfiichBuukouvmdthfxh1w4TFM+tuN63h9uCmzPZrtrCYaYMGJgGIQt5tUYkrI2nB9jOmIysEF923V8AV04HXEkXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247323; c=relaxed/simple;
	bh=gcrHXgZTxc6rfvOfymDI4fj0t025jiH83e+583B5lLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm5P7Dlcl81peQDOCs0Ibhpch2am25+9G+DwssahN5OuZmQqVjUjEkAzbxpzOI+t1XSRJvroJM7moypteUkE/OLRazCtXQjfsdRdatlnR17KZ35MjvAXaRA3EeXZ54YIeib5xrrMqHqbucZzUI7efuXz1UCCVs29mIZdnAand20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atFaF6in; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atFaF6in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A0C4CED2;
	Thu, 30 Jan 2025 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247323;
	bh=gcrHXgZTxc6rfvOfymDI4fj0t025jiH83e+583B5lLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atFaF6inLAUubtBEZvAmRHc6x2xH6CTbi3NxLTUjxEQtBCGgIdu1+1EhQmT0EXh2B
	 v4ggJX7xnyxEf70ad6Z70Yb1Z4XU8DZyxeQmeRvn33cWHvtMh5aYKrlLYGGu0lcgGV
	 5tg1beToatOwH3oUPvmuN0HU26E+WVzlNwDCEAA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.15 12/24] Bluetooth: SCO: Fix not validating setsockopt user input
Date: Thu, 30 Jan 2025 15:02:04 +0100
Message-ID: <20250130140127.790745686@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 51eda36d33e43201e7a4fd35232e069b2c850b01 upstream.

syzbot reported sco_sock_setsockopt() is copying data without
checking user input length.

BUG: KASAN: slab-out-of-bounds in copy_from_sockptr_offset
include/linux/sockptr.h:49 [inline]
BUG: KASAN: slab-out-of-bounds in copy_from_sockptr
include/linux/sockptr.h:55 [inline]
BUG: KASAN: slab-out-of-bounds in sco_sock_setsockopt+0xc0b/0xf90
net/bluetooth/sco.c:893
Read of size 4 at addr ffff88805f7b15a3 by task syz-executor.5/12578

Fixes: ad10b1a48754 ("Bluetooth: Add Bluetooth socket voice option")
Fixes: b96e9c671b05 ("Bluetooth: Add BT_DEFER_SETUP option to sco socket")
Fixes: 00398e1d5183 ("Bluetooth: Add support for BT_PKT_STATUS CMSG data for SCO connections")
Fixes: f6873401a608 ("Bluetooth: Allow setting of codec for HFP offload use case")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |    9 +++++++++
 net/bluetooth/sco.c               |   19 ++++++++-----------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -487,6 +487,15 @@ static inline struct sk_buff *bt_skb_sen
 	return skb;
 }
 
+static inline int bt_copy_from_sockptr(void *dst, size_t dst_size,
+				       sockptr_t src, size_t src_size)
+{
+	if (dst_size > src_size)
+		return -EINVAL;
+
+	return copy_from_sockptr(dst, src, dst_size);
+}
+
 int bt_to_errno(u16 code);
 
 void hci_sock_set_flag(struct sock *sk, int nr);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -829,7 +829,7 @@ static int sco_sock_setsockopt(struct so
 			       sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
-	int len, err = 0;
+	int err = 0;
 	struct bt_voice voice;
 	u32 opt;
 
@@ -845,10 +845,9 @@ static int sco_sock_setsockopt(struct so
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
@@ -865,11 +864,10 @@ static int sco_sock_setsockopt(struct so
 
 		voice.setting = sco_pi(sk)->setting;
 
-		len = min_t(unsigned int, sizeof(voice), optlen);
-		if (copy_from_sockptr(&voice, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&voice, sizeof(voice), optval,
+					   optlen);
+		if (err)
 			break;
-		}
 
 		/* Explicitly check for these values */
 		if (voice.setting != BT_VOICE_TRANSPARENT &&
@@ -882,10 +880,9 @@ static int sco_sock_setsockopt(struct so
 		break;
 
 	case BT_PKT_STATUS:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			sco_pi(sk)->cmsg_mask |= SCO_CMSG_PKT_STATUS;


