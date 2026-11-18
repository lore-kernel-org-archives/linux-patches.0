Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062138;
	b=xrKfm5eDovbnr/mWBMW5dPUQ5/GmcqDSZiP+lpZBk2pZmfFNMqusEZ7cUENYQQx6ug1S
	 5UnAXVK7goDLqlZA1vTrex0+z29sMytOqKNstnHMVqidXeH3Y91GOKfKwLn+mW6/jMIyO
	 T32fD7BIXd5l69+ymasUJLoNuygX9IXMy5s7+HUA4gXiUpGVnYjx2CV1ifPhNZMoGcd/v
	 9xh1ukM0fN9sCHr3FhxDQfFARbgF1k1Iw7zh/tRVQVu52rqipULvc2ouqvG4CuT2lAwsd
	 +KmRCSUjBsQoZ40m2wGA5yr1fizQ+FvW8EDaYw4iAm+8FmyYo7dZWwLbZJtYpr83VCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zuuTACKvrGYDRAktX2BOOob+k84XUU6ImnFMaCisbwY=;
	b=Y3TrVsMF7277U76Jbk5RDaDelLmIBWXbUDjqag7VLQMt4+p+FrBQCCCVGEoy/vNFXCdA
	 l1PjufkK0l07qlgpoHIIXpzbRQQDvKtvKOoZPVO0MjICeLfJuRY48f8SN3g0xB7ZuiGOI
	 maDgr94fUAkbFPP7HJ6xLV/vJ/jCnfQkPDiFhyQ3TAlMkR7uZuQfhqDDKn+v4PqP9u2kr
	 fP67jU3hnxCpDHZLZJiaRkczGvTDMAbMlQHrXR/xe9kjNiK3X8tULJdSX1CqagUsEHVla
	 bBn8oBvcIMRBLdGGsad79WF+Ft5d6nxGBwUULwU2fEj9FZHnlflVrO7/BtfItm2FMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIyKGnkp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B76606A32C;
	Thu, 19 Nov 2026 04:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIyKGnkp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBA21F000C5;
	Thu, 19 Nov 2026 04:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062138;
	bh=zuuTACKvrGYDRAktX2BOOob+k84XUU6ImnFMaCisbwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIyKGnkp36sLeD1iyxjSaYb2yJvQeWMA5MRjjcK9P1/xSVWzGl0HYKl9b/N/r3Wcl
	 KBhq68CLPdAUJ4ZkpTBE3H1lT4XEC/82R60wN65hkswRt2ury99BZibm7nqGwxDNvW
	 QQ7ATKns4+N4pCtCQORVId1MOasLjIv+ZwUEVOUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1776/1848] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150033.715711765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 135e5421f0035..4ba9ea4c95631 100644
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



