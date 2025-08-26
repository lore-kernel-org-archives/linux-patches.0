Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B161ADFFE;
	Tue, 26 Aug 2025 13:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213396; cv=none; b=Kl5q+YBF5G8eZXGjdQzPVihmSZ/HbDz/mQJa7H6lfNfy91g3irjtG+2FzcYFusVYaSYYNdCGjqd0ZDhTyA1v48RcUPguLg6O3TmDiL6viowmLzVcqu5X9Slvj6FrsHag0WdfQtlH9srQnQjnWeWoeLI0K3VL+7/8PdLMoGHhViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213396; c=relaxed/simple;
	bh=h3OD38q29Q0Mdn5OrW4KlV43GqU1VVAmydDWcN75WdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAc4UaTjO6ndzgilYpX2BQHVIt2PQPtcUT88jdIjTakk51bQBB4DanSsIidfEMDST2mMDnLlzja+XnKJfklrQyU3Ksq75/EoMGe7JdT7lCKDIuRrfcS77A+G9JfkSOz3tOkLMoL9ZLRvjmHiNZWaz+amsJPicf+ufCcIKUA0iqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnBrbbL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnBrbbL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC97C113CF;
	Tue, 26 Aug 2025 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213396;
	bh=h3OD38q29Q0Mdn5OrW4KlV43GqU1VVAmydDWcN75WdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnBrbbL6dhBuT/RzQuOJ61h41YVeHlVqTo2tFTfl44oRnu0t3paY7oCdtVD4+4Xmh
	 dth0Y+qoUR2D/pTicWFokNNgBSSlBCBl4gF7CFsMaA8KegsD8fA8uF/yQGgkoZZ9w9
	 evzGLAEnPQa3HnqJN8Bh9+7Ot2sP5WmdX0f9crkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.6 330/587] cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()
Date: Tue, 26 Aug 2025 13:07:59 +0200
Message-ID: <20250826111001.309951883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,7 +103,7 @@ static void armada_8k_cpufreq_free_table
 {
 	int opps_index, nb_cpus = num_possible_cpus();
 
-	for (opps_index = 0 ; opps_index <= nb_cpus; opps_index++) {
+	for (opps_index = 0 ; opps_index < nb_cpus; opps_index++) {
 		int i;
 
 		/* If cpu_dev is NULL then we reached the end of the array */


