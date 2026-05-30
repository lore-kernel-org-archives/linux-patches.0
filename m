Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E32D3B1EC0;
	Sat, 30 May 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163210; cv=none; b=Q5G/ZkwpYa+GImmqFh9LDvRol4LnFGSygI2NkDPiTUSngnTZUf1BZBnrPpX0m2QHF2iawqam8fQ7VkBHkJ8rr7j80TbIbvvqzM+gANwUr0/oKBI+e74YLNHkqkYy6Wv5r6yctCn6X6OzUxYnutxJ789x32Mtx7W3jlNW+M0TrHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163210; c=relaxed/simple;
	bh=MEpWQyq2teihkodI4gjcndNEg2odwFYQoW2m0Fplit4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQ3qTM9n3AOgZFOiQ3GQip60yX7EOUcGS2D34bZiFtya5LLcGahFx6/XerGpLUOH1RuNsztMiRtjmAgKF7laLbkJWiKaRV+PpBBwIr446buBl0ojWLmhib/C/6dfdlTRhdZ27fLaLKh5plmKljLMlgaTuPVh0ts7tYQmvyRF6ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY1AfqJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY1AfqJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895171F00893;
	Sat, 30 May 2026 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163209;
	bh=qLZCUWinIgITKMqk5DM3xwakRqZ9dE30jJrb4MMSwzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OY1AfqJBfw/6mYjlacEwDg4k1AAqDhyOARRTg4gWDcD455qLUqHXn9b2l/wAli5fU
	 Gr8vfdcTYYG/9wRGglQa/OTuMBcnzw2Uwdxat35B1Vph06oyRK+InNaj2D/Zeg9O9f
	 OWscM1IdP/pnhwEtWg5Z6kV9MncrPDpxPC+ox1Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mikisabate@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 5.15 162/776] cpufreq: Avoid a bad reference count on CPU node
Date: Sat, 30 May 2026 17:57:56 +0200
Message-ID: <20260530160244.675448483@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context conflict resolved. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpufreq.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1014,11 +1014,10 @@ static inline int cpufreq_table_count_va
 static inline int parse_perf_domain(int cpu, const char *list_name,
 				    const char *cell_name)
 {
-	struct device_node *cpu_np;
 	struct of_phandle_args args;
 	int ret;
 
-	cpu_np = of_cpu_device_node_get(cpu);
+	struct device_node *cpu_np __free(device_node) = of_cpu_device_node_get(cpu);
 	if (!cpu_np)
 		return -ENODEV;
 
@@ -1027,8 +1026,6 @@ static inline int parse_perf_domain(int
 	if (ret < 0)
 		return ret;
 
-	of_node_put(cpu_np);
-
 	return args.args[0];
 }
 


