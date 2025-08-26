Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550D62676E9;
	Tue, 26 Aug 2025 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219289; cv=none; b=RltshNVFmyZhHHAbf9TVdnQydpkxMdn22fcaHPtuSIIZ8MCpTUQ4gCAZS5FElV7vOcGhZ5/FOf9KOTN/FwZXkkM+BstpXyx0a/GZoYK0PMbTWzIzbpDBZemjF6IbKv1xlZwWSldcZYhBylbS1BllAfQjuAxT3YZCS+WeU4Gcynw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219289; c=relaxed/simple;
	bh=CCemkoMhIoPnW7LMW4eyqiKpQctdf47VkkKhuXBxBdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFPD/Zvy1ltGLlQU4fQZ8JIBoT/6Lmgzo1S/Sxsfm+xiN+B6wYUZgU2Ubkz1ZEhLSbR9qFsqQAVRC8x3nP8S+MDmXMhuTKHQG1fIMkn/RcdDuNuHjIeRGNOUlax4j2/AHweEIIf/mNPC9a9KWIpm1cLdhFYnA3j0GYMQuefxXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l+ZMTna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l+ZMTna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E0BC4CEF1;
	Tue, 26 Aug 2025 14:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219289;
	bh=CCemkoMhIoPnW7LMW4eyqiKpQctdf47VkkKhuXBxBdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l+ZMTnag3m2A+vfHK+fNgqeijEYN70N7srv+Z1BXI+Doh3iqeUKJV+2q3OqcJdRG
	 Uoa2H7odW4qqG9VqmBeSvxXy1e1iPqNMPiCCohjNBopHTbznx//ycUpGxTe9FN9wGG
	 6Ia1Ap/DtKyKS+EDU/fqk/w+a2w5mKOpcxznujuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.4 283/403] cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826110914.622057590@linuxfoundation.org>
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


