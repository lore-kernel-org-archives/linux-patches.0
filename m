Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705479;
	b=qX0H864k1Ch91Qcplr/Gw8moevTUyycIN3A5YNY4JqsAMn+Vo8aGIzw8hvaEXhiWcDdA
	 UIPgGNaPjyEdX5UbUXHUcJDnH+O0Yt8axYzzlxGeCLlEQPq9e62s+ZB/N3vuN/9mhacBO
	 3mlj1s1+pTuHp1s1ODYEQRe/tB5d/c2CUx40+S9VAOKCU7bL5GONBIVYeVOklzLjbPdKU
	 UkWxl2JeufRclpfKEXWb0iiBlvd3ynKmgSLsk5oASI2VqMqDAbFxQ2U4JxcvwgIoY67Aa
	 PeGIW/Xl19cM8LD/z/CL6QX9ego7lJOXjA4FzCsNyeXOpkE18OQJpNGRZLYStGIw6pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NEyVe67LDKOgzDRQR0OHbEjUZ1GDhgEubdlC836JuNU=;
	b=QPt24WgNxxW3PfPtbiyOJSockz7vSh1RG+4mvIZ1IuS7oS9/9uRq38oSJnD3YZLsu51q
	 QbvZEzmxudl6vBgGJVP4yCZVhs2uwdOo9rD5bm84E+0WVWkmfx5wJtT6M00+leQAIHwKN
	 Tk3lhfHdUC8LhV7X4W6Eup1fvqbzgp4y2lPbVOxPim0VjXhxN7R2taD29B3O3nGMMA9xE
	 JY5XFhflTfMpS49PLldji4YtquAldJ0X4n1YkoQ7b2IYlC/M/XJFtAtxZtB3IUEbR2275
	 bSNMQkE6/C19hjeiTAtvjy63vu17uHGzMmKiyZa1JCYuyxoLs2QteoNDAvjtPCUws6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXTDQFJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6B0606A31C;
	Thu, 26 Nov 2026 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AXTDQFJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7351C1F000CF;
	Thu, 26 Nov 2026 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705478;
	bh=NEyVe67LDKOgzDRQR0OHbEjUZ1GDhgEubdlC836JuNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXTDQFJYB19sy0wI2Tshmipy1gV4BXSTRF6K2jYSnCH0hf7V6VmKkcRWp0BAm7wzv
	 2RLl375Z0Gfy49x9tzFd3Rf5+S1twLQxL0LpkPENfKO8C/2UICA7sf0Z92ZptxeGmY
	 QbYSIJ0jeje5bSdsIo/b1MauIjJUTHSRLMoc6h+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 5.15 210/319] cpufreq: Cache post-resolution target frequency in __resolve_freq()
Date: Thu, 26 Nov 2026 15:39:38 +0100
Message-ID: <20261126144011.485288980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -539,8 +539,8 @@ static unsigned int __resolve_freq(struc
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, relation);
 	policy->cached_resolved_idx = idx;
-	policy->cached_target_freq = target_freq;
-	return policy->freq_table[idx].frequency;
+	policy->cached_target_freq = policy->freq_table[idx].frequency;
+	return policy->cached_target_freq;
 }
 
 /**


