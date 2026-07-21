Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E34028D9;
	Tue, 21 Jul 2026 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654761; cv=none; b=W/rN/9cRKYVeNYyaKMsno49FaYvMQ0h9+AUEP1AjJXyvS59I4e1oMP8T4/WgVzXIEKEYJgc+oGpPMeDIPoA4Syj4FODP0JpOQ71sSUqFJ3MqmmHMW0YSyeqJgC8YMytKy/sDMrAK8quJMPV+DFX+W8Me/OOEFHHH4Wqe+4gQJfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654761; c=relaxed/simple;
	bh=n35I609rfmvaTrEGpRi6rfkcWX7hpjLEybqSFzWWqBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYm20dv9g/ZplKA7QfmDl8UA+Sba0RAcvScVn7ihueiPYlkHT0/TLs+pSBONevBEEavWSE1aNBK75OlJprUGp1NQqXGZnitTK+AhmQ4ydGrkDusDHvqn0/7AvXRr85r6V4Ayw8hbOhx+cJFFATOXR+N0uEdxf33UBSkhPf/YQgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rf4vheLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rf4vheLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605351F000E9;
	Tue, 21 Jul 2026 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654759;
	bh=WKflC4gyQ/MnAoPc4PTqf/OTGIVBO2BM2bkcC1+Vgi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rf4vheLrnFoUbVMK4F1pBx2nAQJcv1+RruNNmVKaVAJEtNKpYyRz5n0vLcFkAKgOX
	 melHuwgFo+z94u2pFdTd8wQDmnBbCBLrJp7FoiToDP/9e3CS3P223ggrwdHxLzHLbE
	 lOhN4NoL2OFhCzslZtD72u8xZgR36qx4GZuRavQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1800/2077] tcp: Decrement tcp_md5_needed static branch
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152635.204044857@linuxfoundation.org>
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

From: Dmitry Safonov <0x7f454c46@gmail.com>

commit 6f6e860e370c9e4e919b92118a25e9e1f82e9180 upstream.

In case of early freeing an unwanted TCP-MD5 key on TCP-AO connect(),
md5sig_info is freed right away (and set to NULL). Later, at
the moment of socket destruction, the static branch counter
is not getting decremented.

Add a missing decrement for TCP-MD5 static branch.

Reported-by: Qihang <q.h.hack.winter@gmail.com>
Fixes: 0aadc73995d0 ("net/tcp: Prevent TCP-MD5 with TCP-AO being set")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260625-tcp-md5-connect-v3-3-1fd313d6c1e0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4333,8 +4333,8 @@ int tcp_connect(struct sock *sk)
 			tcp_clear_md5_list(sk);
 			md5sig = rcu_replace_pointer(tp->md5sig_info, NULL,
 						     lockdep_sock_is_held(sk));
-			if (md5sig)
-				kfree_rcu(md5sig, rcu);
+			kfree_rcu(md5sig, rcu);
+			static_branch_slow_dec_deferred(&tcp_md5_needed);
 		}
 	}
 #endif


