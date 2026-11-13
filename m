Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590928;
	b=2+h3x+5/2yvNyo7CXCueDjLUhVR4vO73dkt7Hn1r5TbwTKoZ+LU8YW2JhJoNLyMt5Fo4
	 UfdIZshXhMdstuEtfYeJ089p+jkjcp5vhJoGS8C79AfOaFMIrYMH8JEFVyayG0AHA2I+H
	 qbHx+RodFWQqFO7kxlHdfSuNxpiagYBBMfzbDHqP4ZZpT2DWJElwtTDSTN+panAAkaMt/
	 T0XrGc0j6UjNFF2mSr3L6F0Lwi0EbEKFEvEj9kyMt7GmxmFixO7WSGnUPec84SBWHXdW5
	 fEQMN6HLoLuVMozo4cZnudvI+c+WWeFFH0fOW23tEZ/M8kPdCD462iTRTGhyhhxMMYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ZsiWhAQd2R4oyMZLzBIp6yqPJquD1PpUxIN3XVCrMU=;
	b=oQSQ2i+7KbKWAH1ZgHr9LXUqL7dWU3jplDKWf42hU1wpf3gtpJBIn8rgvWwzkdME1eWF
	 1XdiF1+QfyzdzKYtloOjpCoDV0OJiOxGocpTENjnFHmrMFLLg1r1HWedSW0PsMV2VOfLm
	 APmuVAXnHM8RY16SzFZyNheKF35zLDkxlxhLH6ZGPRP6srKJ78kNSVaHX7Dwyvr8WfaS4
	 oPTB3sxURsGf1mp+JHCyUjZ+JPAWi0hZ29Sx+FLndMHYhzVCVlDK3gL2PwKa6s2Rzzz/+
	 //jhTz9H4tSPkiAJ9Ui7KabZkFSz7aiC+6zClDr2hxMcrxu0DMbc3YxFQxDS0UbJMGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbgSvM5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF3606E676;
	Fri, 13 Nov 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbgSvM5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E161F000C5;
	Fri, 13 Nov 2026 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590928;
	bh=9ZsiWhAQd2R4oyMZLzBIp6yqPJquD1PpUxIN3XVCrMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbgSvM5E9k7b/lxoPNrVCfcg5TFyM/6wJ/NYhDngH/4CioLyLdrLSTWzV5v55dY4F
	 ns7p8uaq4cJhyva3djrqL9Uy95A74KlhzfPtItZYURPyGc53aOglT7QmeIH3v450v+
	 yHXgimz7MKpTGr3Xx25F9bXTr4n7YZu8q8XRlMlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/670] ax25: free the old digipeater path of a listed socket under ax25_list_lock
Date: Fri, 13 Nov 2026 10:44:39 -0500
Message-ID: <20261113153815.726791901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_connect() frees the digipeater path left by a previous connect()
with only the socket lock held. A bound socket is on ax25_list, where
__ax25_find_cb() on the receive path and ax25_info_show() for
/proc/net/ax25 read ax25->digipeat under ax25_list_lock, without the
socket lock. The path can thus be freed while one of them walks it.

Take the old path off the socket under ax25_list_lock before freeing
it, and set the new destination and path under the same lock, so that
a reader on the list never sees a freed path, nor a destination with
the path of another one.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, ax0 on mkiss):
a bound SOCK_SEQPACKET socket calls an absent station via 8
digipeaters six times, each new non-blocking connect() freeing the path
of the previous one, while a thread reads /proc/net/ax25 in a loop:

  before: 18 reports such as
          BUG: KASAN: slab-use-after-free in ax25_info_show
          BUG: KASAN: slab-use-after-free in ax2asc
          (90 with an mdelay(300) after the kfree())
  after:  no report, five runs out of five, and none with the mdelay

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 5aa967bbd20401af3415cd4fe056fca6624698f2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3e0934531a600..08b196ddaba5e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1247,7 +1247,7 @@ static int __must_check ax25_connect(struct socket *sock,
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
 	struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)uaddr;
-	ax25_digi *digi = NULL;
+	ax25_digi *digi = NULL, *old_digi;
 	int ct = 0, err = 0;
 
 	/*
@@ -1299,8 +1299,16 @@ static int __must_check ax25_connect(struct socket *sock,
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-	kfree(ax25->digipeat);
+	/*
+	 * A bound socket is on ax25_list, where the receive path and
+	 * /proc/net/ax25 read its digipeater path under ax25_list_lock:
+	 * take the old path off under that lock before freeing it.
+	 */
+	spin_lock_bh(&ax25_list_lock);
+	old_digi = ax25->digipeat;
 	ax25->digipeat = NULL;
+	spin_unlock_bh(&ax25_list_lock);
+	kfree(old_digi);
 
 	/*
 	 *	Handle digi-peaters to be used.
@@ -1360,8 +1368,10 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	spin_lock_bh(&ax25_list_lock);
 	ax25->dest_addr = fsa->fsa_ax25.sax25_call;
 	ax25->digipeat  = digi;
+	spin_unlock_bh(&ax25_list_lock);
 
 	/* First the easy one */
 	if (sk->sk_type != SOCK_SEQPACKET) {
-- 
2.53.0



