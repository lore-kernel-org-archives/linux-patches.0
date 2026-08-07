Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADE92DC765;
	Fri,  7 Aug 2026 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115413; cv=none; b=S5Jy64+RjvYHW0EYLTZVbbR3PFy+tBbNh7er9kkIkTRa63qAUH5/NbnW5DMOPEFV2SMXjXA/bP+/ybgkvOql98YjnkcJfpZw0YqndJGmIw9SyVdyURZYiI/GjtFxSyeLYYxJfSAxowytqpjWUtt3vLY+bB1tr5TFdHrbGc5eWIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115413; c=relaxed/simple;
	bh=IC6GjOtNRjSCfkzPQy3fMFG/jYc9hBk+T4I4KBuRT/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghksnNFdkCkQp9L1TSFw4oa2uhHLxMoPF4PEbKs84orZNYHhDIXqPn2qSrkSF0WQMPrgfDkF5Y6zKEDGNtBvh5i720M27c8EYEWrWRPejqgISJFxgHkf23Zw0l82lhDPglO5J/0Kq50WvbR6fYV1SCxKFfx34igbla1Nl30Jze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8urt5t3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8urt5t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FF81F000E9;
	Fri,  7 Aug 2026 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115410;
	bh=d457lm6mJW4AsC/NF6YOtW8EL5tSvJSMjApbD0pRbH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8urt5t3pq7uHyFDR05o1OCQEE9y6CicWHOGAGNR8wRHsoHpNS3raQqhRykGK17W5
	 ovH10x5IkV+vnEh5FBG1sh+uTEeBYo6GjfnGIbkiOFKDzeQsTHGmZrYZMI/oO/6dT7
	 4aq7VKmp44uhHsQPJOmiuXVjxrjenL9TBlYjZyhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 266/396] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Fri,  7 Aug 2026 16:37:06 +0200
Message-ID: <20260807143429.995029166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


