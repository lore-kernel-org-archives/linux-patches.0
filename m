Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F621E25F8;
	Wed,  6 Nov 2024 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896959; cv=none; b=sGpt3ZKgi1bVr1zyiNyx6Lyn2OeQVopHdlwR7krmQ6MdC1BQOlJRFvAh05iMa9hZ43AWUyltLcU+gP+NVwst/nHDtvqGyN4S7TrrWJzoqwFIlEvkw6aFtez5rFUjHgfU21gBBhHQxCvvWJmCLxAxTdW4YUdGDtqe6UPPKB8mJ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896959; c=relaxed/simple;
	bh=TMAnjjT6dCw01SdLWbWdj28y9CAUxm8Ea3ucAZ5HiZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G6/Qn+RQvJmEgW+hwLr/M0gNpkEKQQ74b8/LLk75vLl5CHoM6QwBIVytsqEw/y1g7zFYkaCZifAPszT/eAEAtHOQI15a11qryDTlu+q+r85PFCr2slVg1XDrfPyKMRXTjibZR4Wj/s4GAyvwfUL/FIO5olv8O2jjoALpF0VS3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miX7mnzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miX7mnzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E0AC4CECD;
	Wed,  6 Nov 2024 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896959;
	bh=TMAnjjT6dCw01SdLWbWdj28y9CAUxm8Ea3ucAZ5HiZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miX7mnzfIXiGQ9NZBGH0lQJNE/WG7vsBT9TWN7AJidkYk6gongDaYj/IlIQlmwIzP
	 BFQN93yVvidQNLdJKI8EU/w2fFXSO4q8Jfsd9aOxruhwTDo8JN+7e/CT1+Ttx0r+Zp
	 vJ9f3RIeSvV79WjZjFP2gl/z1Pj+3xMRxSHfcuxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mikisabate@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/126] cpufreq: Avoid a bad reference count on CPU node
Date: Wed,  6 Nov 2024 13:03:23 +0100
Message-ID: <20241106120306.112133262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mikisabate@gmail.com>

[ Upstream commit c0f02536fffbbec71aced36d52a765f8c4493dc2 ]

In the parse_perf_domain function, if the call to
of_parse_phandle_with_args returns an error, then the reference to the
CPU device node that was acquired at the start of the function would not
be properly decremented.

Address this by declaring the variable with the __free(device_node)
cleanup attribute.

Signed-off-by: Miquel Sabaté Solà <mikisabate@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20240917134246.584026-1-mikisabate@gmail.com
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpufreq.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 1976244b97e3a..3759d0a15c7b2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1126,10 +1126,9 @@ static inline int parse_perf_domain(int cpu, const char *list_name,
 				    const char *cell_name,
 				    struct of_phandle_args *args)
 {
-	struct device_node *cpu_np;
 	int ret;
 
-	cpu_np = of_cpu_device_node_get(cpu);
+	struct device_node *cpu_np __free(device_node) = of_cpu_device_node_get(cpu);
 	if (!cpu_np)
 		return -ENODEV;
 
@@ -1137,9 +1136,6 @@ static inline int parse_perf_domain(int cpu, const char *list_name,
 					 args);
 	if (ret < 0)
 		return ret;
-
-	of_node_put(cpu_np);
-
 	return 0;
 }
 
-- 
2.43.0



