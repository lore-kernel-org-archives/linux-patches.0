Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056941;
	b=T+WzqPMKynvfedSYlm67po8V8TjIYsvDyR7FjaDCN5pfVLECRYNk++lPW1F3WlPyr3xi
	 F3MTYgYy+uKGCIdJyz7ekVrlfHyAt53HW0xCC5STWiPRUwRYhwwvCDt2RhTaTzlyZ32XI
	 Y0TNWiINKd9mVRcOzYohdoLaGU6TouEyJRs+sQRf/WEtXvEwQJdZuBFcrMSc6XJPFUdUH
	 wp8wc5U6DGzirdcXz6sh5YkJfH/QKrI87C0axhhNezIsu9jwO+UfAi4kxWAvAFrX2Mlkq
	 UYs4pHxnq4Bt8Idm/Q/XLIbbA3lKtEUvrR4qXeY0VNXexmUOY0TOMdlXfFpWDjZtC0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A6ceWG0DrkrTmqmqycMMSVl8/xlf18UfpaZe6/3t3kU=;
	b=sDeTc7qvSYBaxRTgK8oWIBWrpPLil5GICS/z6R5vw6adAvYJCmpbH9HDAtFirzmk/DcN
	 K5PTaBfWzTYhGqXc4d9gePf+NAA5f3H5PjlUjgh8UVNDMHrYJF8KCu84H0jN8l5ruqfwI
	 ojXgClUfRf3xT1LSYbbCtFiSWifD1kx6HiEG/sQ9fIvg7bMUpKfAlpcxOfbR92N9ZiiAo
	 Ju5lawhhFDQHntkKq708Su4qEiVdCY/4wsuk0FNyNcdLMsYuUbtrX4bnHGZndLcEWeNaF
	 7WUqYFvt+wtloVfk4KfexEhzNpJKIJGo+/DzsDYnQqSZiEZeZpNGf8jsRw1Yz6WBwXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hW6YTTx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD99E606A32A;
	Thu, 19 Nov 2026 02:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hW6YTTx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F0E1F000C4;
	Thu, 19 Nov 2026 02:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056941;
	bh=A6ceWG0DrkrTmqmqycMMSVl8/xlf18UfpaZe6/3t3kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hW6YTTx5ojgikGfYomi4q24UC7eU/tofwd5qdR7k7QmGWLKksBvZDeDdgXmtIv+PF
	 cZRFaPhEHT6gqzmbFIWyq6xTWa7dfY9rZ8RevjEutbvDFHvRIJzEOxaRpcewPuZaVu
	 0VVxD3i03gTva1ESQ7Xgq0UqJOQUhJqO90B9YdbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2126/2214] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:03:22 +0100
Message-ID: <20261118150135.608251724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 82c9c94f54a444a686e926c872dae4b198d1036f ]

num_possible_cpus() counts CPUs, but CPU IDs need not be contiguous.
Using it to size the thermal_power_cpu_limit bitmap can omit CPUs with
higher IDs. For example, possible CPUs 0 and 64 produce an eight-byte
bitmap on a 64-bit system, dropping CPU 64.

Use nr_cpumask_bits for both sizing and copying the bitmap.

Fixes: 6828a4711f99 ("thermal: add trace events to the power allocator governor")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261023060724.5691-1-dennylin0707@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/thermal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/thermal.h b/include/trace/events/thermal.h
index 8a5f04888abd7..997c5e7d1930e 100644
--- a/include/trace/events/thermal.h
+++ b/include/trace/events/thermal.h
@@ -129,7 +129,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 	TP_ARGS(cpus, freq, cdev_state, power),
 
 	TP_STRUCT__entry(
-		__bitmask(cpumask, num_possible_cpus())
+		__bitmask(cpumask, nr_cpumask_bits)
 		__field(unsigned int,  freq      )
 		__field(unsigned long, cdev_state)
 		__field(u32,           power     )
@@ -137,7 +137,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 
 	TP_fast_assign(
 		__assign_bitmask(cpumask, cpumask_bits(cpus),
-				num_possible_cpus());
+				nr_cpumask_bits);
 		__entry->freq = freq;
 		__entry->cdev_state = cdev_state;
 		__entry->power = power;
-- 
2.53.0



