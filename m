Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061499;
	b=sEznFuzazQS98oxZhaUUef0GcL4ZBVIyYCvDD8Lqs6iLfYAwjqzJlgzb7e7sXzYiYjUA
	 CKxHafLR2q2/MZsc+S/ayUYqUBMn1G7b7GAGKE1ZE9pThekkrox071Dry/ywh2X9SK2hl
	 jA7l+kY3u1vwOzeAkqa/5M/LcHPcN57RcBSHikDefqkBsFcW/IK25tu8OZWwMB0tssaOB
	 dLNY1u3SDE/onvZi71hPmRnKsvAh1IDDlaz3v69mdmDv7rFlgYDnjDI48UwULqMWBnAlN
	 tbADvdy7LVA7un34256V8HR5p935PJUX3kpxl35iqwfjvvx/sawXrx1832QpNpTdbAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHaLgkGizZu2qyK6ALEr72cszWsZXVCzTVoDrT0B6/E=;
	b=mSy1OX1QZdPI3HAnOKx2rAZzgPUdsVwBcXkdmW0e+Mm1HpKNQFzrsopk+1QdjpMfvRNk
	 WctZjnuM+FmJmgCX3k9zCsXQvB5hRtzAZe9YpbubHeWCRPt89I0Gdp5rQuipaDi7w6EXP
	 ycC/+gyCMy3aelNGO9ZdITKI78xXEIpQzw+tyB2Sx9iwObFoESO81BkUZmEuYnltCnL8M
	 ngUQzuV99ksfjREYyqLMy70CYUiHK0iJ3nzmF7WwuGJ8w9FELi14KQd46mkm2ekpJy6sL
	 Ki2m4BD/q+WZITMZSeF2JZtdEa1VNklyXCpQ4I3axeCMOm/Ve9/h4oNzlLOvpMNb/sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nk2EwqZ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D236E606A331;
	Sat,  7 Nov 2026 14:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nk2EwqZ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE8F1F0089F;
	Sat,  7 Nov 2026 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061498;
	bh=ZHaLgkGizZu2qyK6ALEr72cszWsZXVCzTVoDrT0B6/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk2EwqZ1Sv5/VLIsEqe83tQ5CgwuRKfuZ3/qY0MnKTS+/TJqfO/IGeimBckw419OM
	 7xQWUqSsHmkFZdnI9ByK0GLaBv/JsucTE1eYxogH1L/rZPEjHd0UBqX+J9qW8lBi38
	 Dqgm80ZVvV9zSIXkuZdLfJMj1tvnqexTisL6RbCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0594/1536] tcp: Fix potential UAF in reqsk_timer_handler().
Date: Sat,  7 Nov 2026 08:43:30 -0500
Message-ID: <20261107135014.226110151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 97c8a3c1f73d828de43a5a88e8a9a143efb2b661 upstream.

When TCP socket migration fails at inet_ehash_insert() in
reqsk_timer_handler(), we jump to the no_ownership: label
and free the new reqsk immediately with __reqsk_free().

Thus, we must stop the new reqsk's timer before jumping to the
label, but the timer might be missed since the cited commit,
resulting in UAF.

As we are in the original reqsk's timer context, we can safely
call timer_delete_sync() for the new reqsk.

Let's pass false to __inet_csk_reqsk_queue_drop() to stop
the new reqsk's timer.

Fixes: 83fccfc3940c ("inet: fix potential deadlock in reqsk_queue_unlink()")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260506035954.1563147-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1158,7 +1158,7 @@ static void reqsk_timer_handler(struct t
 
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
-			__inet_csk_reqsk_queue_drop(sk_listener, nreq, true);
+			__inet_csk_reqsk_queue_drop(sk_listener, nreq, false);
 			goto no_ownership;
 		}
 


