Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623122;
	b=3iKn1i4P0JVcigxhYGHss3vBNFIyrIvlOlPy0pXyficbliDFKTueVRHfOXyNUm1cgAga
	 /KZSmjv3/UqFeofMIsC2fJRECii2fijtZ3qy3/DT5sLTxMfaf+siwWkL7W8Z/Uz8/fUJm
	 M4hkP/DlvLbOrtRdYopDrWzw9/Hbp0S6OUmbcvJoaGmL6LO3tcX0OIvIRV6QWk46dfqIT
	 6ZhUYwgIU/rO47N7kQFaBHf45xcxFIty96O88EDLLMvJtE2VVxgnS9pwEMt++4buMDScz
	 Brxq4BzZj7a2bk5SMsPdVMOzqFX7ndE73G9zKKiUuW9En5v/l04vahEOJ3B0tcziJvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APp1dtRWDTt7ek7v4Y8GO/cAWWCGl0zNeLIXQcM1gQk=;
	b=2QA2xd5rur8cn4gwOcx+DGhAlUZM36H32HNzcxVg/opc9WlOwP2EAv0xguRTKJFNc8Mk
	 19Ca1mbEPNecNmjxEwZuwxpkJB7vsFzdMiDEKK/QFtoofet1xbkV8Q/G8RtSJWI4LF/YT
	 OS5xH+Plzp7ctvkSBV5WgTEfVO/GLckaUZ4KSvyRCJPb/vdhbPysswbay/LfEAtGZjjZ9
	 fzfN0FpF3VyE11EcLCmwIIss37kiFOu8Y62R4PCE8KkxPUnj26gEnjCsWMwNhUOdLEqYg
	 JEc4HfQqrX7I8CbR0EAlp4lkjRitLGx/Q7V35+Dqv/5xode4A86ES0fE9kKdI1sOsnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq+amlmA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79191606A323;
	Wed, 25 Nov 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fq+amlmA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720E61F000CF;
	Wed, 25 Nov 2026 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623122;
	bh=APp1dtRWDTt7ek7v4Y8GO/cAWWCGl0zNeLIXQcM1gQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq+amlmAyCsqpt9wEldd/BbklwgiiITGzpZbRD/hLIipUHHBQyjt/0Xwd27Mrip0V
	 DK2MLnunK7bhBcUrGAHR/xzF+JD3XDzOqGHCFVFXuXrJwM0sj78bRqgUp3aZ3VZ+jM
	 elQPS+0yi41tHII1TEwcD20cQr8cQ+lb7KCnT4d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.18 758/990] cpufreq: Cache post-resolution target frequency in __resolve_freq()
Date: Wed, 25 Nov 2026 15:35:25 +0100
Message-ID: <20261125143839.813335749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,8 +509,8 @@ static unsigned int __resolve_freq(struc
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, min, max, relation);
 	policy->cached_resolved_idx = idx;
-	policy->cached_target_freq = target_freq;
-	return policy->freq_table[idx].frequency;
+	policy->cached_target_freq = policy->freq_table[idx].frequency;
+	return policy->cached_target_freq;
 }
 
 /**


