Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1F442124;
	Mon, 17 Aug 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976288; cv=none; b=NW3ZKTQCCgyVdC3+S6/KwZMJ3R3wtJsptXmX/BR5siuCbVfhDTMTSLjqOKeTlIejAf63aI6vRnZco9YuECBGgAJFEGdVe/Fqlwvv+G4CUFpzNlJW43v5vGDXEWGYnVsmORmcT7hZO+SWyiVZ91CI+FWQm5E5jw9rpyAjDOJDqiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976288; c=relaxed/simple;
	bh=0tpES6ul3rBeH8saoVELbvc9JZjI38M1pvF74ainVZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1fIXBwr8/AQS6Vigi5deD36Hke/EW1btHIDU4YlGcDLW2mYAy59qNvu1j4XrnkAHlhCgmEFWXCA0Fr5jRVAgldB7NtaOFmI8PDGqYu04y+NK+0CpkGajVFQsqmNn8hbTEzUzNZV8q1iNykNvxGV26yZUG55ddD92cJb/unm5Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=It3hH518; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="It3hH518"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CD81F000E9;
	Mon, 17 Aug 2026 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976286;
	bh=BUbUOotUb9peFEIQlNDzSLm/WIthnrk/LZG6H+iqgJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=It3hH518teZHcgRgSbmRRCyL005N5M3d9Pwu2WTthV0dDvGf8pL4022c6DjasiALA
	 6nNHRfzh11n3GY7oKdn8u7Rz4P7/r0m29Kw+dhLBiX6U1Pnnu8OJZR0cGXqMmsbqP9
	 xFqvbGklbHQ/O957uzQzdSRHn736rbpY4aCkw3F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 281/389] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Mon, 17 Aug 2026 15:32:00 +0200
Message-ID: <20260817132550.090520383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


