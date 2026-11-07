Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065382;
	b=duHWKpEK9akx0+dpzQi9d2q4EtmmD4I7SWqG1HE+UpOKK6vZCJop7bkWK8DbUZL0+XrW
	 sehh48uhfIdXYfVgfj+0q4YXbWUKCepPL+Fc9Giub73wCt8pk7Al0UyWWL4LXGCBDdlTH
	 TTppXYO8LQyyiZgHM3QiXtx9wsDO1o+onMBbUhywXBqY2DUjox6VjYCqWSqNuWTs23ylp
	 alcHtYCP3kZ8nMqYeWm7mjeLKFb58NtOeY6N1iKQ80Wp7FbSH/q3Opg5OLNsMdf1qRFlY
	 Jv8xnXqoBXYhN+DbQzYGzz42DavnS1yhwgSrbETDnzn7vI7pdtdUpljBmuFprSXkESg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=alP1haX0OP+4JjcvwMKQoITi1GPvWHzNyvPMJrcBd6I=;
	b=oj+PrB9Y68iTzeMBn+FisD71QzKqOegAaeIevh7yRXXN5iLvnFHcD2zYyg4DTxIR942c
	 WLIcsAw2Qn8WaFTp/HEklxcFJhyTglP4jypEDfYa6WQ0yy8VSgDBlKRnYkQkfVOJ4ye9V
	 j5ELgTE2G5xanEorC8f7wCNRGs0QtY73wgavW+tNhDqwwfXFozr7WOV7CrUn55PWHgx1F
	 0VRaz5emC/nhBE8lg1eKXJbPE2OLtDXnJzLuIRGeN2r59DilMIHjhWxOaZY2/DmYkAACD
	 c7u4eYPNbJ8jBbMnW8UF5GwbHnRUqpie7obhJ2d+VynkqRc0Zf7OSuh5q3giWuWOAww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEGOzCz9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1544B606A32C;
	Sat,  7 Nov 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEGOzCz9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDCE1F0089F;
	Sat,  7 Nov 2026 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065381;
	bh=alP1haX0OP+4JjcvwMKQoITi1GPvWHzNyvPMJrcBd6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEGOzCz99rnC7fAgI8Nf8Rj344MrCloB9tjZLDbCuqiHSSDoMImjBbq+aTfa16a33
	 hsQ6kQG6cDZBvGNQKUDPF3wdybsGWT2myb3dVJyPpaY1B5q3IG2pzb8yi2O//7QfnG
	 VjqLfFBzluRL8Y9SHyPb0pGtnRBT/kht84Gt0xZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1108/1257] time/namespace: Fix overflow when converting absolute deadlines
Date: Sat,  7 Nov 2026 08:56:44 -0500
Message-ID: <20261107135009.855060117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit d69cfd33b5a8d176124c564513b9ceb933595d93 ]

do_timens_ktime_to_host() subtracts the namespace offset from an absolute
deadline and clamps the result to [0, KTIME_MAX]. A negative offset can
make a large deadline overflow to a negative value. Since ktime_t is
signed and KTIME_MAX is its maximum value, the subsequent comparison
against KTIME_MAX can never detect this overflow.

For example, with a -1 second boottime offset, an absolute CLOCK_BOOTTIME
timerfd deadline of KTIME_MAX can expire immediately. An absolute
clock_nanosleep() using the same clock and deadline can also return
immediately instead of waiting.

The earlier tim < offset check already handles the lower bound. A
negative subtraction result in the remaining branch therefore indicates
overflow. Detect that result and clamp it to KTIME_MAX.

Fixes: 89dd8eecfe961 ("time: Add do_timens_ktime_to_host() helper")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020233433.20997-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 3aff27bb0a154..635f7e544bcc2 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -51,7 +51,7 @@ ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
 		tim = 0;
 	} else {
 		tim = ktime_sub(tim, offset);
-		if (unlikely(tim > KTIME_MAX))
+		if (unlikely(tim < 0))
 			tim = KTIME_MAX;
 	}
 
-- 
2.53.0



