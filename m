Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064713;
	b=XG7uyiBtVY0Zi4VwusLUv+BBE86b9LjHo1ug160nComlxmel5wF2xm3HXApIhLsGVI0E
	 WvaFw329kFoMyyQptcwGhWBJciGOkqW/6/BMXYqGWn/Rq92zGJfsuvA95MsTNQyWpQfBq
	 m81xxnpeGYN9iQuXoWE3LQQ8NTIFepA/Nt78R7Tno6gObHB29roMKN906TlBE6WO/kfZi
	 oVn7E5PfahIZM5hTIFa6j9+ZpXGBw4it+03Dl3Dy5ejIp3Mzl/74AFhSLshi9orneWA9Z
	 zjWSTJULkN9sBYpC4IDn8d4JCTxUToiY0goBGWGUyGo5lJ/LtADlaVjGojJrfPtjeNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KAYv6rQMXDJvcdsXiHzTLMQCLCwFcD6MBxm1hrbq8Q=;
	b=M4jgmpD+sw6QieW6gkblRZ/2rrbzAaimu+zpFwk31rHHps0InfCs/XG4/HdqGAqPslCp
	 HB4IFgKfFYP+y6Jh5V6ycBC6TYCYSFzx/ZoE4opQ+RrF1kva+F+yd/8JSlkXMRjcBs+v5
	 z4j9oEjitJ0+BJ3TvE+Ewdyro3Qp0+DiiZkCCZFe3s0EE+KWpvpBcSEEQbYLaYwN9wi0e
	 sXqFHWzNtlsqDQmAWco4BMHC1qaJDYmwDJNaWbBih3QBMkni89CX5JbvkUeiitMqbMimB
	 6WAsyKXg0uehQBJz8PA9/iPmopdxxbFLm5M9XDdtH8+F4dHtMHdH6lq6NGpKU+2Qt6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0GlXp0k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926FE606A335;
	Sat,  7 Nov 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C0GlXp0k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB6E1F0089F;
	Sat,  7 Nov 2026 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064713;
	bh=4KAYv6rQMXDJvcdsXiHzTLMQCLCwFcD6MBxm1hrbq8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0GlXp0kQIUAl6q4ZWwRgCcU6Esnu5o7cCiSENxE/aZH/vWWwZ5qVTkbyjsco0jLd
	 Bb7CLvKJ23b4T7nGbAW27eNz8prjR7V1A4hBxUaVHsqRbI8ZvkxIjhmB3aP68+r8ww
	 do0o40FM1EtbbKdKAOWq5/PsTmEjQnWDePWPUXfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0696/1257] dm-bufio: fix a race leading to an unsigned integer underflow
Date: Sat,  7 Nov 2026 08:49:52 -0500
Message-ID: <20261107134958.481445829@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 005d2ec5723cd4ac740de678274623f1fadd6a6e ]

The function __scan tests "count - freed <= retain_target" and then sets
"atomic_long_set(&c->need_shrink, 0);" It exits with the condition "if
(!atomic_long_read(&c->need_shrink)) break;" It may be possible that
between these two statements, another thread sets &c->need_shrink to a
non-zero value. In this case, the function __scan continues and it may
possibly the "freed" variable is larger than the "count" variable. The
expression "count - freed" underflows and the function __scan will
continue to free all the buffers, even those that are below
retain_target.

Fix this bug by immediatelly exiting if we set
"atomic_long_set(&c->need_shrink, 0)"; and don't attempt to re-read
c->need_shrink afterwards.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index edad64654ef68..5f02262707610 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2426,8 +2426,10 @@ static void __scan(struct dm_bufio_client *c)
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		while (true) {
-			if (count - freed <= retain_target)
+			if (count - freed <= retain_target) {
 				atomic_long_set(&c->need_shrink, 0);
+				break;
+			}
 			if (!atomic_long_read(&c->need_shrink))
 				break;
 
-- 
2.53.0



