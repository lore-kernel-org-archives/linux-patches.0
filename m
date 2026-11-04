Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829258;
	b=KTGWCBNW69H6oOznMGI9ZUy9te5tJGgeXQF99ev6yKuWJuXtwfCPwjUS4rPmaAQTubkL
	 obqfu19XKYNaOetA8XTqEqP05sWCXPYDsqnINfjPdMviXXqx0UqiGd9fKjhAVzerJdusv
	 ObLfh2gQAvFbKjZmXjCdO3LC85zQ7klETfWFxuIdrdHcJZ8KXMXA8HRU1APuQhJ3YE70k
	 CPhZ/Ubw8n8Ce3EkDOBZZeKPAYABjSw39N+S8zA2LWUH0hEa+PlROsaK5NwpU9c37DUgk
	 zhIZJNJWHPnFzJqCvbPOAMbIp8KYy2bYwlc5PMmYI2uNQa+VOvHuzKG84ECp4f08tWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=On+FNtrbdUEwr9V7MPvIs4BeNLZjGQFoInvjVZIhrgM=;
	b=2pZQxcjUSskg9vGYtorlUxczTmPlqAkJ7DHiHf0nJVQ8YLm6TzXwC4KoGZCzmthEq1X/
	 UGKT/18rIM1WU/3eAAAYNpNSZ41Vpq0uQYEkklEY/Q9aMOFhseZ/PH9S5jERecbr09SPe
	 oeZyQxsq9zLXeomTATTi5yluceAlBIpz1yyI8R9WA63GSX+USf/20vlQRuEPGj69hp5Oo
	 YPTkNx6TCiOWz7xk6JmtP0cP2K2IixmmU9gnx3KvvOlGUotuIsL43rMLelAT8W9+72Fs6
	 EEK5G6LPWAN8MT8GgGEozL7XKIznxlfQpvELNNRbLY6cJxO3iJv6SfjTgkx+CoT88Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lBpop7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FF6074583;
	Wed,  4 Nov 2026 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lBpop7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5071F0093A;
	Wed,  4 Nov 2026 21:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829258;
	bh=On+FNtrbdUEwr9V7MPvIs4BeNLZjGQFoInvjVZIhrgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lBpop7WdI+koveEA1+ic3YFQyfT+YOQx+QImC2VcBdBVfGvaAgeZVh9WlnJWpQkL
	 O4kIZI5IlVpFootjF+cQN8cFKw/LXZUZR1/uvJiC3fJVlx5qoe9tmLvNeB/HDTXOJ9
	 ufiWcagVO4GhyeSSuksK0p3A9AciM09ZKAJXD2RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 547/547] ksmbd: keep retry timeout clamp bounds constant
Date: Wed,  4 Nov 2026 16:12:11 -0500
Message-ID: <20261104211053.944159298@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 146c3fc6540e24eef6296395a35bf5b924182e8b upstream.

With CONFIG_HZ=1024, msecs_to_jiffies(1200) includes an overflow check
that calls jiffies_to_msecs(MAX_JIFFY_OFFSET). Its saturation branch
returns MAX_JIFFY_OFFSET, which exceeds the six-second upper bound.
GCC 10.5 carries that branch into clamp_t()'s bounds check and fails to
build ksmbd_tcp_writev() on MIPS.

Compute the 1200 ms lower bound with DIV_ROUND_UP() instead, so both
bounds are compile-time constants. The lower bound still rounds up to
the next jiffy, and the retry interval remains between 1.2 and 6 seconds.

Fixes: c0632d2010ff ("ksmbd: track delivery of queued TCP writes")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610251743.jztr17Ib-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -696,7 +696,7 @@ accepted:
 		lock_sock(sk);
 		tx->tracking->retry_after =
 			clamp_t(unsigned long, 6UL * inet_csk(sk)->icsk_rto,
-				msecs_to_jiffies(1200), 6 * HZ);
+				DIV_ROUND_UP(1200 * HZ, MSEC_PER_SEC), 6 * HZ);
 		release_sock(sk);
 		tx->tracking->valid = true;
 	}


