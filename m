Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3AA34DCE8;
	Tue, 26 Aug 2025 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217992; cv=none; b=bfqFz7h1FiVTi8fUwrUAE12BXpFyxakOk2Rd3npQZN3sEyKq9+AY9MUlEhjn8rNVNe1Pp3VnvNqFqBr222dAdwrX31d5OH72/UB8sUd0F8DJKXyhgbt5RGDtukZSrNuIQjePDL6M6GwljR/uT8x2yNm14ssFDkqlF4zRd/Qs1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217992; c=relaxed/simple;
	bh=EhyQegcEqDxD4m2WMgGhwKPI7k4H2An5pz3XrloBwzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljUmDmQtSarQTIMYO+5z6vGD0M8yDYmXL6USXKKIxss/XDbukYYlWf3jRi/9dHKds1IHC1QEE/voHLVE8rNvzO0qRfN8i/xd8Ut+t1T2vT9/AuLpWLwnoYjEwo4HOrgCrEStMipA5t1ZETFQywQXT82FfoyCxIcqm8EMQtWjJ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF3AWSjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF3AWSjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79339C4CEF1;
	Tue, 26 Aug 2025 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217991;
	bh=EhyQegcEqDxD4m2WMgGhwKPI7k4H2An5pz3XrloBwzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF3AWSjIm0zMc822REMDXSbxKPRyj7d9JXDAqi+euZXPgIEAyNksP//VKOcr/z1Z+
	 tRb9ZkqJZ5kIE2s0UqqePy5sme08xIswf63lJcXOBABLd29Lxz7b5Z1lhJU9RxtHUb
	 BFkvQ6Wv3nDmTQsJOUZAd9svhviRHn79rnqZe3kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.10 353/523] cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()
Date: Tue, 26 Aug 2025 13:09:23 +0200
Message-ID: <20250826110933.175579414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 4a26df233266a628157d7f0285451d8655defdfc upstream.

The freq_tables[] array has num_possible_cpus() elements so, to avoid an
out of bounds access, this loop should be capped at "< nb_cpus" instead
of "<= nb_cpus".  The freq_tables[] array is allocated in
armada_8k_cpufreq_init().

Cc: stable@vger.kernel.org
Fixes: f525a670533d ("cpufreq: ap806: add cpufreq driver for Armada 8K")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/armada-8k-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/armada-8k-cpufreq.c
+++ b/drivers/cpufreq/armada-8k-cpufreq.c
@@ -96,7 +96,7 @@ static void armada_8k_cpufreq_free_table
 {
 	int opps_index, nb_cpus = num_possible_cpus();
 
-	for (opps_index = 0 ; opps_index <= nb_cpus; opps_index++) {
+	for (opps_index = 0 ; opps_index < nb_cpus; opps_index++) {
 		int i;
 
 		/* If cpu_dev is NULL then we reached the end of the array */


