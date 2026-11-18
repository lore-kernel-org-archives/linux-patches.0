Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032906;
	b=AYbTm0aSSastBNqSXrMLgAoO/Y/s64wvDqF9n8SaGubHUSntB/24+TONoNtFjRgpgzu4
	 UM89R57gp1oOwvOoP314pexohVRKw3+EiBjMoQoI1GZta3Vq2hna76dCWyCcNYMegGDN+
	 m4azDeBe7fNgcksrRhl95FHoz2PvpyMBTnJ+h0Cp0rxCFDX4XIOzaryhpUZZzM5OABVyD
	 EZ2du5K5vkCLOUUcy+nxgyIs9weBPUzIckLOY1yqsc8PZBnJ/XiNcspteVX8MkH37E1kQ
	 ySpspnXOgOvg3C8O0Dt24CjgkFSUQXgs126y7UXV2CXd0Q+muuaZfAJS8mM4U65JkNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsPwQtjRirQrbTh9wdWhx0mGnNT6E/jr89A/fCxve0E=;
	b=j14D9gyIB0lq/HLG4xtZvX86DMwVeAN8bUPfSVTJiXOY8to41OwLN4/aBlsmkOEsOe3x
	 7J72Qzxfe1YNYWiyE7ABsk7bJ0SxEd29CQmFgDfsBv7bUGZMHHZsdBHwZQkrfOi/ePh+s
	 AYp25X8mHbCtDoB3FumGfeJUc27/GHIp+BY4upxtfLhbySNQaKBJdXekDQkCaaOhK7o22
	 CI0llgJ7cZc2fpCVIqNV4Ko/h7vr4fs3RrEXMjGoBpKo65/SWnepKL5ASi6fJO+xmPcC0
	 ddV7yImG/9xf3vTYikAXOCYyZS0uOpthHuZESt83wiudZjnhmy+Ca6EXowVVGbE+YyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVKPxNva;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B059D606A320;
	Wed, 18 Nov 2026 20:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVKPxNva
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115211F000C4;
	Wed, 18 Nov 2026 20:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032906;
	bh=YsPwQtjRirQrbTh9wdWhx0mGnNT6E/jr89A/fCxve0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVKPxNvaz7h8B3ChqmVwmQ8+E55NIMB1FEMiPznkCFXwQ001H4mqIFPXlUswN8byq
	 j2EbhFPVm0QWvItNdphB+UFTuM5uc3v37LzDvMQ6erHXvIwXi2zjaprK0dkdJrGL7z
	 meAIWIKxUPi7GuumRBWX6idWZXnpRUOYJixWM3X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1578/1756] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:01:45 +0100
Message-ID: <20261118150112.589359729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
 drivers/thermal/thermal_trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_trace.h b/drivers/thermal/thermal_trace.h
index df8f4edd6068a..2f953fd8289dd 100644
--- a/drivers/thermal/thermal_trace.h
+++ b/drivers/thermal/thermal_trace.h
@@ -119,7 +119,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 	TP_ARGS(cpus, freq, cdev_state, power),
 
 	TP_STRUCT__entry(
-		__bitmask(cpumask, num_possible_cpus())
+		__bitmask(cpumask, nr_cpumask_bits)
 		__field(unsigned int,  freq      )
 		__field(unsigned long, cdev_state)
 		__field(u32,           power     )
@@ -127,7 +127,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 
 	TP_fast_assign(
 		__assign_bitmask(cpumask, cpumask_bits(cpus),
-				num_possible_cpus());
+				nr_cpumask_bits);
 		__entry->freq = freq;
 		__entry->cdev_state = cdev_state;
 		__entry->power = power;
-- 
2.53.0



