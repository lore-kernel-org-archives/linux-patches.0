Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CC352FC1;
	Tue, 26 Aug 2025 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218915; cv=none; b=DfXZP7mwQkrBjUsQXw6tr+SD1u/UKv5P7Mq2VA0Q+yq3ir/PI/OqJrhUipmBCcfSTW+s4U6Q97WoPnK3MXKco1wwCl2UcS3yTpCsPwcBhZ4ElkWC6z6xXe3LQPHr3+pSlyDUxHKypxlSy/IqXTZvf8jMfjbFN6EmNTz9B/cp3Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218915; c=relaxed/simple;
	bh=ovANF/QBNICfu8bxXWYQmUF1zs4yyda4lwAHyzHx7KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se/w6dySVbxzFZZMfwJvZjmIORUNnNM3Ux1J5CsN8x1BXe45VBFhC5YVHQUTB+MBOwVYo0HwGMVDfAt9TQXL+SHDL7ZsGZLgddLy11iuBpTd++ofXB188OCVM4mKNSlQOpm6H5nFUvgZ3LmhA+11LL6RbzuYeCXTC2z1lfJGSNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFLRLR7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFLRLR7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D153C4CEF1;
	Tue, 26 Aug 2025 14:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218915;
	bh=ovANF/QBNICfu8bxXWYQmUF1zs4yyda4lwAHyzHx7KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFLRLR7hfT4SZIEjm6i9F83FmNGLhoEpaqjquAi6EkeDab4V2SjE3NuT0iHV1D4d3
	 snegz6qrAF27kjRc/yl0Do0SclK04qAZ78s8RTESbvMgnFT+wPpkSlzYfetPy6EqJy
	 ER/7Iv18iYd5u5YASLzkji8h9KEETgg9PFT0PX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Prashant Malani <pmalani@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/403] cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826110911.883053063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@google.com>

[ Upstream commit 0a1416a49e63c320f6e6c1c8d07e1b58c0d4a3f3 ]

AMU counters on certain CPPC-based platforms tend to yield inaccurate
delivered performance measurements on systems that are idle/mostly idle.
This results in an inaccurate frequency being stored by cpufreq in its
policy structure when the CPU is brought online. [1]

Consequently, if the userspace governor tries to set the frequency to a
new value, there is a possibility that it would be the erroneous value
stored earlier. In such a scenario, cpufreq would assume that the
requested frequency has already been set and return early, resulting in
the correct/new frequency request never making it to the hardware.

Since the operating frequency is liable to this sort of inconsistency,
mark the CPPC driver with CPUFREQ_NEED_UPDATE_LIMITS so that it is always
invoked when a target frequency update is requested.

Link: https://lore.kernel.org/linux-pm/20250619000925.415528-3-pmalani@google.com/ [1]
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Prashant Malani <pmalani@google.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20250722055611.130574-2-pmalani@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 8910fd1ae3c6..c85b01aa801d 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -407,7 +407,7 @@ static unsigned int cppc_cpufreq_get_rate(unsigned int cpunum)
 }
 
 static struct cpufreq_driver cppc_cpufreq_driver = {
-	.flags = CPUFREQ_CONST_LOOPS,
+	.flags = CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
 	.verify = cppc_verify_policy,
 	.target = cppc_cpufreq_set_target,
 	.get = cppc_cpufreq_get_rate,
-- 
2.39.5



