Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1955127466A;
	Fri,  7 Aug 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116213; cv=none; b=hAuoS3ZMGHeqtV3O1Y6r7NiMfccFk/cGQhlLQ6BWIGJKJnXDj/yiCd7KBmIfw9BmczqE+A3siKV/Gbk2PizaLSD50maor3aHV1YFEvL/kz0HG9Hvh31K3SH1psmdvV+oCbi3euEbZXr6h9KXJJRRlzC4o7W3notlRblk+YR1MJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116213; c=relaxed/simple;
	bh=FyhibI1CZIv0cgfcEeYwgSRsOtCfjs5fnSKZuJvkMhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQ5zTVf9mLmR0mvKW/UlJpWq4Di9TR5RyA9HsEaFmT1yNBQt027GYipi7FTl/VwVG2H5o6gptge4S3HDWy8NnV+WorCm6ff6/WtewpFjvPWnwCbc/K3dFpUCk5ORte/Hlmda3WNt0xJvHLhaY7CjzxFj/sg7mePyg788e7amQvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8C0Y3BF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8C0Y3BF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CFD1F000E9;
	Fri,  7 Aug 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116212;
	bh=TpranWkopFg8wkVSdkhJ3of3I4DCTQDpO9pkqCWnHhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8C0Y3BFwqb8jEDVtKrO6PzsdsBuaQiE168A1n12jJoYQsdWFkFeF77AegO2DvJR3
	 ihqUg8mio9Hgv9WKd1QXe7yDV8K3OZ+eyDQ4vzw1GXcSNFth9QxB3wdfh60u7eaGkZ
	 aC9IdVw7TjWcaSOJO2dtqQIhu1f7vU+QvOeZnmTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 151/261] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Fri,  7 Aug 2026 16:38:28 +0200
Message-ID: <20260807143418.623652331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


