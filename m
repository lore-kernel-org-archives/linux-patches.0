Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826895;
	b=MdrLgOpsPEZ0Tvo9CYx73/09VYnUvHfJ1BZrEJ3htNa4ZqYVL5Tgggg7OZdHYeQ5kh+x
	 FfAH8gSJI5K0iBwwohd2Frw/UDW4gTU4MREDiBo8je3Bqm3OdHYlpep5nxoaohWTdhkSS
	 dygfD5NruUaMcHX/C22EK7EJhVDsUvF9DTquF1/HL0/veuVJsZCbyfhgzcdwXKJxUjdSg
	 8TvDQ7rSmbUcNk50BoPmvRblcdgPK4M6noLJZ0vud7fZwv4FK3BIkojubRgX8wJAG8ikH
	 66CkFDgKkrzonxrU2TpGoAf1R898eZ5KSQ5X6+TU+9kW0dWqCmNuYCcAPlA+I7gNInw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YbGIlWdmYkGEDpfICqQOJW5WMvkgPcJvVhBIt4tn5gQ=;
	b=A9F88PjQZdn6OpPIg42looXBK04J7KCdOay/Z+VXeTvYStKum4bYKIPinRCtCG9MC4bJ
	 lat+qKA/UC8xHKfuUFmPetOA/KSk/Pu/2sZNHpGhqVK0WNWPTxsdv1tmKZNIKLQDgM6G7
	 S5KE03HfYVXxvEIdbRZx+nztAXMYYr69ahVF/yfwVyyjREX8gD1nUD+qay4to22y/oK8p
	 GeQiOA9SFsDMaWOjnVi2bycVYmGL8Rk/rME1OJrYaxCh3kb9Xv3obiMyaOGtG6GapxrMc
	 I6hFuh9Ipi5irRbVegBOWf/95hc137aa8j5xpswZKdAB5S3p8aptQZsgCnvIsnanhaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCtieBlm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57736070761;
	Wed,  4 Nov 2026 21:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCtieBlm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAF91F000C1;
	Wed,  4 Nov 2026 21:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826894;
	bh=YbGIlWdmYkGEDpfICqQOJW5WMvkgPcJvVhBIt4tn5gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCtieBlmxYCNCF8+nxZd4AxavHihvu08qLbiLsWBo5Nw4cfIFe6ZaiGHatb2jwpPL
	 UYZLvnn+G3MjO/E9hiumsCTHSv7A1CO5Db5kLtmHq8KrHtjdsEuo/vSwt02d1ZLbr7
	 3LdSot6dQD9CZ6OvrUJ0TgdhKxlLXupSJmpzrS6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 053/547] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed,  4 Nov 2026 16:03:57 -0500
Message-ID: <20261104211039.803624522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d492dcbb3b81c1c2d0aabef41fa1307093f3a556 ]

__io_sq_thread() doesn't submit anything as long as the ring has
IORING_SETUP_R_DISABLED set. The check that keeps the SQPOLL thread from
going to sleep while the SQ ring holds entries doesn't know about that.
If an application fills in SQEs first and enables the ring later, the
thread finds that there is work each time it is about to sleep, goes
around, doesn't submit it, and so on. It uses up a CPU until the ring
gets enabled.

Entries in the SQ ring of a disabled ring are no reason to stay awake.
io_register_enable_rings() clears the flag and then wakes the thread, and
the flag is looked at after prepare_to_wait(), so the thread can't miss
that.

Fixes: 0298ef969a11 ("io_uring: clean R_DISABLED startup mess")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-37-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index ad42e8eb10029..ee97808a065a9 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -385,6 +385,13 @@ static int io_sq_thread(void *data)
 				 */
 				smp_mb__after_atomic();
 
+				/*
+				 * Nothing gets submitted before the ring is
+				 * enabled, which comes with a wake up.
+				 */
+				if (READ_ONCE(ctx->flags) & IORING_SETUP_R_DISABLED)
+					continue;
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;
-- 
2.53.0



