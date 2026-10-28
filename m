Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207414;
	b=AiIEMbk+OwhM1H3fqabEc9nKr/hGj6KiVkstTQRGMhknWcnbk/lPkMrHwqbXcbdzCp49
	 ZBI4Axv/7wjsD9xHW67MA8G23N1MLcEQiMkK4khZ/xE3am6YM8BHzsZbZHA081TkRk7Kb
	 y0LK4pccSR1+xw3d9Fp0qLLM7tRi7LuTGs5aQnz6bM52zFuXsWjOooZP4ZiIjOZRFZ9h9
	 HvWNm6pyEwP8zjOonsXy9IY+sCQVpr0gZFZ2pP57PhpMuCEEwJUzU+Esekkk6nj6+Yoj0
	 T/JMdm6fcaPfc3ITXpDTWYeu8dIcGTzUbBTsPrrr8kgjGIZyWIk6iCdzZXT78r/Dy4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eREdLP7hN2KTcJDz4QZv8qYhp+Eieyj2V9w/S6p5I0E=;
	b=v1qnEVw8cVSrl0R1J829gvHC0VM0hiYo8YyN/sUN6AmQTrSLoldDL/1dD6IDfKMpoTlR
	 BWS+p6soRGE+ZGJaCyRGSfBJq0LDzo/GzaYQtwV0mOGhkhp+pBfCYL4sj1YmEivNFIIeZ
	 MFA6kqDAxorwmYB4j4CPHUZXvahGh1/2g9aWPV4aDbTWIOQTfPfz5teAZq30DnoixWmLC
	 zy131DeNqfmYi9RrJYE83Z3KIHFrybA1tYb4AjOJ0oRMeuujzslVIordjk0UEnbQaMauO
	 WTdaija1PCbtGVVqZ6VG61HLoDE8jU/AT1VZXbngCMbgVL07ucEMseIdsriRWfEv5og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRAivGHF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E02606A31A;
	Wed, 28 Oct 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hRAivGHF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633901F01825;
	Wed, 28 Oct 2026 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207413;
	bh=eREdLP7hN2KTcJDz4QZv8qYhp+Eieyj2V9w/S6p5I0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRAivGHFNdr++G/KibvEiyRVALKlugP3eBQv9kMKNoHsWy5WpKIeBOuU0f8W+o6rE
	 4jjeluMq9cTiOmV4bNOsd/YAz+ScsaIXdqbgFGpMjO6V6JTUk1SQu5UdABLUPFiayi
	 3r8wLaM/0gaBqxUHdt5lPENl/b3cLR5Wlznmj/PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/247] rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup
Date: Wed, 28 Oct 2026 17:56:44 +0100
Message-ID: <20261028165947.388237782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

When rose_kill_by_device() is called (via NETDEV_DOWN on module exit
or interface removal), it calls rose_disconnect() which transitions
sockets to ROSE_STATE_0 and sets SOCK_DEAD.  However,
rose_heartbeat_expiry() only calls rose_destroy_socket() at
ROSE_STATE_0 if SOCK_DESTROY is set -- the SOCK_DEAD path is reserved
for TCP_LISTEN sockets.  Without SOCK_DESTROY, orphaned sockets in
ROSE_STATE_2 (clearing) loop indefinitely in the heartbeat without
ever being freed, keeping the module use-count elevated and blocking
modprobe -r rose until the T1 timer (up to 200 s) expires.

Set SOCK_DESTROY immediately after rose_disconnect() so the heartbeat
destroys the socket at its next tick (within 5 s), allowing clean
module unload.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>

(cherry picked from commit 741a4863ad570889c75f7a8e404567d8f3e46335)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 03a298ecb8320..314f11fec831d 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -211,6 +211,11 @@ static void rose_kill_by_device(struct net_device *dev)
 		spin_lock_bh(&rose_list_lock);
 		if (rose->device == dev) {
 			rose_disconnect(sk, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
+			/* Mark for destruction so rose_heartbeat_expiry()
+			 * cleans up the socket at its next tick rather than
+			 * looping forever in ROSE_STATE_0 with no owner.
+			 */
+			sock_set_flag(sk, SOCK_DESTROY);
 			if (rose->neighbour)
 				rose_neigh_put(rose->neighbour);
 			netdev_put(rose->device, &rose->dev_tracker);
-- 
2.53.0



