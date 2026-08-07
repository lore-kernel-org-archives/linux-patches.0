Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F743382C5;
	Fri,  7 Aug 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114276; cv=none; b=FeF9b5lwoebTnBEdYFYl7tTbSMcD2cXJvWYNgbDiM4w8xiQJO6cjeQguSUo+t53eOUoglPCVUgFotqM4a0iFLuKR3qfIArBCgTd24PBFW97+o+yVjDlYPWAP5cgLIP4KMwvQBTwjo5IaCe4EdeEU5DHrZlVHXoYhE8i5tvo+qso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114276; c=relaxed/simple;
	bh=R10xOVm4/7HRR58do36gkbZowkRyZ0fV+QWLZ283WMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9FNskhBxd0odkHRIDhi0imSUrO9Rpcr6QLC7+Fx9QIhXux4qe1LjTJT89FetZmdARhWMvQTnfhFN1NTkZPyEJPPLZeQDmPzixWOHt9eWvj+bM5bEeYeOTodNtMUWQT/c1EFAO/5Rpkso01RwHmvFkOcCB6rr07xnpKodCD74lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssqh0zJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssqh0zJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771BF1F000E9;
	Fri,  7 Aug 2026 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114272;
	bh=5d3o8Q3qzM5jujxr5E8prTH1jMGySPiiGFWeilaCOQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssqh0zJO8kTDISBEhRv2b9rnp4teHyFVlzY6yQiZtbcpHpuAouPykTI+DdxykX9ly
	 eggB5sJ32ON86UVtMczZEYcus4I+EkypucthKr4nZoXuI9GVYCRa8QuAYorYSmnhI9
	 gYXiREDX+YMKKEdL258DR/SpvNRVnWyqYFRTbbDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 204/337] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Fri,  7 Aug 2026 16:36:47 +0200
Message-ID: <20260807143422.978472750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


