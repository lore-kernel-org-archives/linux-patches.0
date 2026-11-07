Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065259;
	b=BX4xnPXI3mcU8RRj3Owzh8MUyuhMxkvZEiboY6X81R1MhBBv6YxDyKQuMrpGyevGDPo8
	 97lVI8GhidPShftzlnwA5jveG4QvWgtJEFWJb29OPXfyifi9vAyyjrItd5F57h6bAuRQY
	 +CBp9/SPv2GHU7cgvb/zQv1vzPrUnpcW5xjeNr4wdKv2d5NVmtwmRSGkzTR05z/KsVWN4
	 c/uWVJrt975J/C2mTo1h1uxocvCQG2+MlOOqTuIPlawpNWogY+iKUyQCJCVCVFa0HkHV4
	 G6FfIQoND766fr4maPjWAPN3NGIq0QtY21qOnWVkswkoUoPU6jyC64UqtkJT/ewtENw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1H5VRu6dmpEWEXTuQzxqdC5abW6ZNEgF4atJfoVr+Wc=;
	b=qk40BhlpvFgqk40QhKiLXBdfolH0zAM1+MBPF4MonZqmIfgVfgCKyyhgR6RdnQzaei5p
	 10JhYiRH/rYQiFuVAekEnBbFPHMrZ76MWgA5f4EC8LqVDmnwh0SvdpV7bTOeUXgXNr+U+
	 4vmEE1R72vK+eYcNDWanyHdp4rLQPFZV4m1APXX1CVFCOXKJURhtLT3OSV7upDIQMJEis
	 nTAY369af7Ej8GBeuUlyiwnULDjQLANVZ2PzTP20fq9XS790AbbyFBR3b2ABesJNVlhzl
	 BJ82jEP+097CIsMI4mi4HuuqDXkcGh1A8a4jDydpDh8oWepnhTQxI9py26MfIFFzfng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/21Hxtg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB696606A326;
	Sat,  7 Nov 2026 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/21Hxtg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7131F0089F;
	Sat,  7 Nov 2026 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065258;
	bh=1H5VRu6dmpEWEXTuQzxqdC5abW6ZNEgF4atJfoVr+Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/21HxtgZqGcd4QYdoavIWrr+XGd97awo8H6R+NJLTaawfxIA/u8C3/UnV4wQHRXK
	 RAqaSBYTslfHcDjO907kl3wVGF7aVO5cFRL009EkdQQz+9r+NSBbCMawgZ+HQqU4vw
	 bAp9GIs28ADnOfzUdlgiz9V8XmjbHOcJ+A0grmho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1026/1257] PM: EM: allocate the cpumask for every perf domain
Date: Sat,  7 Nov 2026 08:55:22 -0500
Message-ID: <20261107135007.660410447@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6c7a7007c5b7566fba4fbee1d40011fb8f833dc3 ]

em_create_pd() allocates space for the trailing cpus[] flexible array
only for CPU devices.  A performance domain registered for another
device therefore has no storage for its cpumask.

All performance domains are added to em_pd_list.  The netlink interface
does not distinguish CPU and non-CPU domains when it calls
cpumask_weight() or iterates over pd->cpus.  A request for a non-CPU
domain reads cpumask_size() bytes beyond the allocation and can report
bits from the following memory as CPU attributes.

KASAN reports slab-out-of-bounds reads for both dump and by-ID requests
against a synthetic non-CPU performance domain.

GET_PERF_DOMAINS does not require GENL_ADMIN_PERM, so an unprivileged
request can reach this path when a GPU or another devfreq device has
registered an energy model.

Allocate the cpumask for non-CPU domains too.  The zeroed mask remains
empty, as required for the documented unused field.

Fixes: d8eef0453132 ("PM: EM: Implement em_nl_get_pds_doit()")
Cc: All Applicable <stable@vger.kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260910205234.5392-1-kmehltretter@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index a76089e2ce8c4..d19a65461ae80 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -439,7 +439,9 @@ static int em_create_pd(struct device *dev, int nr_states,
 
 		cpumask_copy(em_span_cpus(pd), cpus);
 	} else {
-		pd = kzalloc_obj(*pd);
+		/* Readers expect pd->cpus to exist and remain empty. */
+		pd = kzalloc_flex(*pd, cpus,
+				  BITS_TO_LONGS(large_cpumask_bits));
 		if (!pd)
 			return -ENOMEM;
 	}
-- 
2.53.0



