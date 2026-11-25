Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625756;
	b=XwOje/Fg+MAgDpL+/LgMjN/gUqEKdCpgOryyqsC8PprCqbVAcKAZMGoHRB/zLoS4YSPd
	 DjURH54Ll3s2igXeekbgQM/PVQu4vogxx6lRyisHRKayGM8q1qiGf6g8RSBMsf/FJBBFz
	 XfqQeTZEHN47X+THfHlsIKR1sU5lzXnK4ADjInUy9o+0ZS5EeOE3I057zSBZduEYG2o2x
	 eJUxDZ5eNg4Z6tAfl3ZJy3FjG3KJ349tPEY5O0ZoxfQECCXa7s27tIkJ0AmZGFNSxn+2n
	 6BoNpua296DLqTShoGyPoT5LYUxIlAweus2PlWc7ux+yl8SpiHgbyqCPqHRD54VDGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0AoM7SEKFpu0vBg9hupKmF3yE2cQMYrYmaqJAcSFgU=;
	b=dYy5OYIgIOnBU4ppkPT6hWSM+zDJkV0AmQ3yycSa7ToQbmVmDP7O4ziTq0k5KquYr3dy
	 pELei3C1uDX6COKMf538U+O2vSja4tfrtUsTzBDQp2PCINXER7dyQQXPafXOIqZZwYdIO
	 Bd6AmTZ3groTf4wh1wZPX2/MuY7Ivvk8Y09YDSzvtXezv4pJgI0A/+givL9YVdjWJq3vT
	 H/tMHtkaCyh9sd6Q/Qsdp/4/6ONd7sj/qGc+12ZJMRYL1EbTVURXIzlOBcjzPVg0aBTjc
	 +7p7DXnsIypKvq0rW76oNW0O0eH9CWO3BY0Bk/fe+tDFySjeehKwKL0z36BjdMDuUlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdFj9nU+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD1606A331;
	Wed, 25 Nov 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rdFj9nU+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933D71F000D1;
	Wed, 25 Nov 2026 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625756;
	bh=z0AoM7SEKFpu0vBg9hupKmF3yE2cQMYrYmaqJAcSFgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdFj9nU+c6tJJPv7PSByMaaH2HZk9tCNLp1XvqPrgs9l2p/zVzAydwLi8auXUU9SX
	 1E1j1tLTTMew/gAaURstQRChIBbHXMofSFQtLkrt2TiXLNZENe8Ipzqm3m4ojAlfvZ
	 7jf6GoppU22meQXi7m/pRb3yfT2gGz1NKwOXyC08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.12 623/816] cpufreq: Cache post-resolution target frequency in __resolve_freq()
Date: Wed, 25 Nov 2026 15:36:11 +0100
Message-ID: <20261125143903.605291956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 166207cac45191637c47a457a5c16ca6b6773a16 upstream.

get_next_freq() in the schedutil governor returns the resolved
frequency from cpufreq_driver_resolve_freq(), and that resolved value
is then passed to cpufreq_driver_fast_switch().  The only reader of
cached_target_freq, acpi_cpufreq_fast_switch(), compares it with the
post-resolution target frequency, but it holds the pre-resolution
clamped frequency, so any request that falls between table entries
misses the cache and falls back to a table scan.

Address this by making __resolve_freq() store the post-resolution
frequency in cached_target_freq.

Fixes: e3c062360870 ("cpufreq: add cpufreq_driver_resolve_freq()")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/14161745.uLZWGnKmhe@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -548,8 +548,8 @@ static unsigned int __resolve_freq(struc
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, min, max, relation);
 	policy->cached_resolved_idx = idx;
-	policy->cached_target_freq = target_freq;
-	return policy->freq_table[idx].frequency;
+	policy->cached_target_freq = policy->freq_table[idx].frequency;
+	return policy->cached_target_freq;
 }
 
 /**


