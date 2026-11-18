Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042437;
	b=mvtAzyhxrRrQnCpXemkKxjExorfJ9ZJxl+vaNozM1GMHA7+HIWSSLdAeHQpsDfVxBfu3
	 huJN+SNxWOLrj8JsP8GP7f1A9po9cZAtvLnYS9hYrwcFgIMZxCPbZO6GqGfa+I70kHK+5
	 zl04pwgZ35iEg/eRjIHmSY6tAi2b9qpcC3pTyK4xRgmWFZGPO8YnuVnUl0igEv9wu4RWY
	 Ev2U4RA7R5tBlHz+Df3inDMNZH6QHe0YqRKVMcKqlsCzYVRERZNpajpTygF4zjY+BecUG
	 qvGmFDbcdSZ+RHot884YgItJb/33ZS6Zz2SUYZFkZmA+cyE9rMZX/qVp1mOs/v0T8Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hjSFyPR2NZdFcOT1AUyzbp3IMwqv3YYQzNfQCxJbmZM=;
	b=EObIYlTlYgdLLRoQCB608J2lL76CZBdIGPxinjMF5HO0Bif41EO6sgHNDTJULBM0w+R/
	 JXxYauAlGdadfah/9kQ6Qix8ESNatICr6gxqmuabJYtfzId35cy3bL01WzdTR1QjrpOoy
	 P+LEozil7a4CV/EqYoQe35gqhR5Dj3Nc4OmQnIUGGSlEkERN9dEfkxMeise2/N2R+bYWs
	 UeE9qiPJT+2JOUXb5zx6J5RKmMmytEVvia/xKSmRzuWt/MimUMCY3/f2xcKxoCOA30Ocg
	 PhV3HCj4eL2hmrDzbkEifa2jiwQlHWgJlxtSKFeB1xbwkG4TQVSUWwW1Pw754LVpY7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VitPUUD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F68606A31C;
	Wed, 18 Nov 2026 22:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VitPUUD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB87A1F000C4;
	Wed, 18 Nov 2026 22:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042437;
	bh=hjSFyPR2NZdFcOT1AUyzbp3IMwqv3YYQzNfQCxJbmZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VitPUUD/kdodO3xAS1ofjpkqmIuQRn4TXvKYo/GCnjBLwvZMRerYnzM0KPqnveR6h
	 +tSPE338w1+glnGT+9apVh6jLHWSohvVV9wWKPlahsIxFTj7bnp5j9r6aSLpW5fWVE
	 CAcOE5IS+BbFZU+9y/RkcuoabTSQvcNMklMw/SI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3171/3318] thermal: Fix CPU mask truncation in power limit trace event
Date: Wed, 18 Nov 2026 16:03:13 +0100
Message-ID: <20261118150454.963953315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 459c8ce6cf3b0..1af97af2a3be0 100644
--- a/drivers/thermal/thermal_trace.h
+++ b/drivers/thermal/thermal_trace.h
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



