Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050509;
	b=becFJoDIqodIYOigPz2aYIELYkzG5ldtvexI/A5TsCvHY+BPksigi//EcAVU3mlfvj1o
	 nO2tGtuDkaWzg4C1tdCqIswJzQ4IHwHICSZJ4S9AzcR5ZZFPIEzRkvcgZ/EoZefDksaDQ
	 PFoj5bRDvWgM4cQqVMqCw80JZcGUAN09yj2TpDP3HuwS2dNgjEnVwhVqUBiioDQpA6vi7
	 RtgNLkE+2livghLilh2Mk5TIyX1jbnQszNTD6rsXMJLzzl5ITPp0sibP+vWal5SYLABlX
	 KsMGR5QRIQ4nbluc2UksTzMEDZwu+WSzbEaJmd2QzgNV+9XPZXDVrCXxiYeYiHD1YnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUHubZxXxloIvxg+YwUV9svnX9gGM22948ofUd121L4=;
	b=BGXrFblU7BzDFkTb5wcYEU97HzQamdOVWQk1s2eE3Dxwr9SADcAcYp+9uFzKggegKRVE
	 naImHCLRDJcL5mAbKX6PTyJB2QNkMM+ZWEnq9PQBSpRBAUlCOMe3rmeCMnk0mdZixYDaA
	 jd7HT5TVlu416pF4ivmD8RCZguGtpfKjkLSFQz8hR0dsNvhh+F01n9Ee4a0wdw78/UpN/
	 Ii2SnV+jSBMyZZrdGkcoCGHUXU0XCs5SvguaQ3TqdX2NDHd1rt5128GBqu6B/ZTTo8nPU
	 +2bQuEmQsq4xkbIS8oH/bmQ2lFRiOr/kBbPCOnR/IA5g/ZJMUgW8tGtto6aX4I7ii+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yptj7kPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CFE606A31C;
	Thu, 19 Nov 2026 01:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yptj7kPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30F51F000C4;
	Thu, 19 Nov 2026 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050509;
	bh=qUHubZxXxloIvxg+YwUV9svnX9gGM22948ofUd121L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yptj7kPAXVOoyII0l+/1x0Tje58EihCEsxgj54jRVDa9HlLF+3uJM6otUlDmGpIAL
	 hsx4/4u6XDvnAnJgKOkMe34mTCJB3guTUR2Ym6hsPDVwK9B5tuLgE+X42D72J1yXsg
	 vTqmWLWGwL2PICruFai6j4BbAb+9Drm72vQDAopc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2733/2857] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:02:47 +0100
Message-ID: <20261118150340.032518151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e58bf3072f324..cd9306e9752f1 100644
--- a/include/trace/events/thermal.h
+++ b/include/trace/events/thermal.h
@@ -117,7 +117,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 	TP_ARGS(cpus, freq, cdev_state, power),
 
 	TP_STRUCT__entry(
-		__bitmask(cpumask, num_possible_cpus())
+		__bitmask(cpumask, nr_cpumask_bits)
 		__field(unsigned int,  freq      )
 		__field(unsigned long, cdev_state)
 		__field(u32,           power     )
@@ -125,7 +125,7 @@ TRACE_EVENT(thermal_power_cpu_limit,
 
 	TP_fast_assign(
 		__assign_bitmask(cpumask, cpumask_bits(cpus),
-				num_possible_cpus());
+				nr_cpumask_bits);
 		__entry->freq = freq;
 		__entry->cdev_state = cdev_state;
 		__entry->power = power;
-- 
2.53.0



