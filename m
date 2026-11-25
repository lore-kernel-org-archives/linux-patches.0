Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623500;
	b=AekaGDv9aHUr4fgEtLL5cvYMOhDScVcIQYITGQpn8MmDn53etOoLMv8wGkj4extBnhQe
	 9ciZ/lVENmHUx6Ac8u51hJ85gNkla+GwFbb6OP5x3PZMop0orv/TzvOL78D3aGU9gWnAD
	 dSDcnthbSJ9nLSEhiHjqJrr+Ii87SLbB1+J/L49QxfDWEpKOSyX/+T9dxdJeyUZG65//R
	 IGCz7uHXci0xtcuItOKONglZJsPRS/+5nt8IfUM3MCG1YcpCDGq2Nzo0agwETQ4HZOFxA
	 uWrDokDBvo1yjdRFHKAvBSMvhimKXsw8xo0X//KMC1cixJ8LQlcUDa8M7OUCrUT8Izg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8sXjnhD3tL2V4wPP35if+Mq46qtoMaHrzmqWatXd3I=;
	b=KWypFVUBlGdLVnWh8VoOeQJD7Z/LcXUKZrIJmpfXNMKAc8or7ykOdK+ecHP58Qd8758q
	 nRxLTWGkNDsF1f0cV3WxShmPmHKlCovazfnV5NzS85kn5EjennR8W7Dd9hzYRibncOViw
	 3SjP/Lzf8vwF65/At1+oH3XUJduKnY1OVYLHo+mRM3BpBUfguRZisXj3S7uocri9VyHCi
	 SFsmYHwHFFeh2mZb05pERNroYkuLCvC28FMh7Es+sryUTbhBbleu1A0X/1O4JfEYB8rWY
	 fg1fbkXrB/xyM3EmnYgMZZzFd9QevFqjWw6wp4Jnv7o73PNHXtiAJ96sQMi8D3O3J/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZOdXbY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56595606A31E;
	Wed, 25 Nov 2026 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZOdXbY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A341F000D0;
	Wed, 25 Nov 2026 16:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623500;
	bh=V8sXjnhD3tL2V4wPP35if+Mq46qtoMaHrzmqWatXd3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZOdXbY5B71FmrMRZPlQSG74LKylH69jDInx//LMLTpWuJW7ahRfy3fyXFKudoLZb
	 1+WWVClttuWrMw7lmGkDARMu5Cr+XTaWA+B3QxCTJbJDa9j9JSCI3o+kQE9UHZD3n+
	 rMZvA7IFvRmB5aC9fZH1L6yG4TW+IvC2se6DR08c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 878/990] dm-thin: fix data corruption if discard races with regular I/O
Date: Wed, 25 Nov 2026 15:37:25 +0100
Message-ID: <20261125143842.583495688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 62ee9c09366cad69410330087d990e469dd92314 upstream.

In the function break_up_discard_bio, if a discard hits the same block as
regular I/O, it was intended to skip the discard for the affected range.
However, the skip code only advances "data_begin", it doesn't advance
"virt_begin". So, the data_begin and virt_begin variables become
unsynchronized.

process_prepared_discard_passdown_pt1 calculates "data_end =
m->data_block + (m->virt_end - m->virt_begin);" - if m->data_block is
incremented and m->virt_begin isn't, it will overshoot the intended
discard range.

Cc: stable@vger.kernel.org
Fixes: e2dd8aca2d76 ("dm bio prison v1: improve concurrent IO performance")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1705,6 +1705,7 @@ static void break_up_discard_bio(struct
 			(void) build_key(tc->td, PHYSICAL, data_begin, data_begin + len, &data_key);
 			if (bio_detain(tc->pool, &data_key, NULL, &data_cell)) {
 				/* contention, we'll give up with this range */
+				virt_begin += len;
 				data_begin += len;
 				continue;
 			}


