Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232D444A41B;
	Fri,  7 Aug 2026 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117476; cv=none; b=rkWxV15oeETVTeGZirJwXdcwwwYcWl5rPwC7ziIuBPEPXUOy16gQfEryZlFISM6jinXmkaQU5bjc49MWm3Qk/9++W4+C6cE/gVyoriDYsMiTbxzacdep6ugSA5xZ4XWNLttK7v1Bh7zTcryIPPqo5FAj+M03pZ4SyARgIfyUBCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117476; c=relaxed/simple;
	bh=2F+Ekg1TqZ11U17Zw5TWzEMqLZhPMV3hegumTRYPKP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHtvNna/aWuMuBnXsrr8FR6RkgrWj1SUhaAbArifPfSRDYBsgq/gboaCJpY8bj8jkL44HKtdDJN82cS5AJpT750kthpv/+Y5sJYQWDpHe8ChwwAf+lG+DluUd81yCZVmX6W/u2M52NcHvbWBulgQr0S5PRnN+R3uPREw3QcSMlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHHh15Ur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHHh15Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A64B1F000E9;
	Fri,  7 Aug 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117475;
	bh=jxga0xNktNipoVKRviMH4ClGnbl/+cMb9C8msHam/oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHHh15UrH6IkfNlAfnoj+Dv2pkwphZFmA6P/6Gyrw3nuLFb8k0QWRedeedh1ebyTa
	 rNpnPx9LPdmjepVgul36VzcvT7p0LEvTdDKzKbH7sInvOzGKEeOzQYKI/md5Ww2jB8
	 h5NfKN/naRIV2uT0g3JW8oXa7b/5vUQAjxGNb2Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 332/438] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Fri,  7 Aug 2026 16:38:48 +0200
Message-ID: <20260807143435.051422457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit d5f8e5f6040d052d44fcbf4f31dd35145c0c8d7d upstream.

The memory allocated for data->powernow_table inside
powernow_k8_cpu_init_acpi() or find_psb_table() is not freed in one of
the error paths in powernowk8_cpu_init(). Fix that by adding a kfree().

Fixes: 1ff6e97f1d99 ("[CPUFREQ] cpumask: avoid playing with cpus_allowed in powernow-k8.c")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727093553.98246-1-nihaal@cse.iitm.ac.in
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/powernow-k8.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1083,6 +1083,7 @@ static int powernowk8_cpu_init(struct cp
 
 err_out_exit_acpi:
 	powernow_k8_cpu_exit_acpi(data);
+	kfree(data->powernow_table);
 
 err_out:
 	kfree(data);


