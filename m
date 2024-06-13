Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E753E1448DD;
	Thu, 13 Jun 2024 12:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280530; cv=none; b=Ek8ajzsgZcWjv9N4IJo4xWazCvBvIZhGU8Xwo0J2YYzy69ixt552EJbPkbzMKHiuyXg9K7nvmRukJHfj+vd0NtvPnRX6B+QYX2WBUhBdbbXeCce1E4AXk5wTJnAsyRhPncOZYOpoprAgwIYeX8ZOEFokLFONcFi75o8iKHsSwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280530; c=relaxed/simple;
	bh=oXNaYm+rgi4z5oqDIHWVxdx5sKD9fQ+n+lKyouJJudc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKPSrdaPoRJP2T+QGr1kits1til30a05c21yIxYA86wpTt4eXsXe9wRo+1j2p32WKlG1LGn0YmlRvtVcAMfvrYCMOoQQmDcsU3AsQ79DNN8rcABjXpL+DcXtJ5YYD9HJ5KCEZtno8KXffQCSIFSZn4ojqaU4lmoF/oxv+JgoYH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDUzQK71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDUzQK71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB0AC2BBFC;
	Thu, 13 Jun 2024 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280529;
	bh=oXNaYm+rgi4z5oqDIHWVxdx5sKD9fQ+n+lKyouJJudc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDUzQK71Yc8R/78vhAiVmhKh4Fce+rstxp/LjCe3DOlMmc8qtXTNZCOZBWDOY6UsR
	 uvtfNNEozIGGDRrSh8L5VkmvXP+MzpY+c39EdvF/WS81wUvmQUbIKsWS4Yrt1uC/bj
	 +ALfSsiAypEPQYkDVLo5OwPihmC/bX5BxZpRhhaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Peter Jung <ptr1337@cachyos.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 085/137] cpufreq: amd-pstate: Fix the inconsistency in max frequency units
Date: Thu, 13 Jun 2024 13:34:25 +0200
Message-ID: <20240613113226.594434195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

commit e4731baaf29438508197d3a8a6d4f5a8c51663f8 upstream.

The nominal frequency in cpudata is maintained in MHz whereas all other
frequencies are in KHz. This means we have to convert nominal frequency
value to KHz before we do any interaction with other frequency values.

In amd_pstate_set_boost(), this conversion from MHz to KHz is missed,
fix that.

Tested on a AMD Zen4 EPYC server

Before:
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq | uniq
2151
$ cat /sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq | uniq
400000
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq | uniq
2151
409422

After:
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq | uniq
2151000
$ cat /sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq | uniq
400000
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq | uniq
2151000
1799527

Fixes: ec437d71db77 ("cpufreq: amd-pstate: Introduce a new AMD P-State driver to support future processors")
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Peter Jung <ptr1337@cachyos.org>
Cc: 5.17+ <stable@vger.kernel.org> # 5.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -675,7 +675,7 @@ static int amd_pstate_set_boost(struct c
 	if (state)
 		policy->cpuinfo.max_freq = cpudata->max_freq;
 	else
-		policy->cpuinfo.max_freq = cpudata->nominal_freq;
+		policy->cpuinfo.max_freq = cpudata->nominal_freq * 1000;
 
 	policy->max = policy->cpuinfo.max_freq;
 


