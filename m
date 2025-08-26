Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4191B2BE03C;
	Tue, 26 Aug 2025 11:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208176; cv=none; b=Bc1G+8uDITysNxcjAVzPHsdo3A3skr/x5L+i8RqmrF7fLcC9luWx9xFk93p+q/ZPAzWFsxd1H/mBXNW9pKMJ61HPk9rSty3uB0dJDp7jrrAwuvFnasIcojazPje3KZMKk4g7zMaULAeesF9UugyWHPC8U6EXsvk99+ShxXlRrGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208176; c=relaxed/simple;
	bh=Nye/Irry7GL+Hjd5l4I5xTxVeRV4ya6BdAQ4uUmW5yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCLx+nKM8lHRN6N+qFq8PdUIWpUgbdeHfoFBIF7MfhFco7/nzw2i9CMviPOFLrKd8QG4yQQ15iMtWZmEvlfFibeWryDKNV3tnCie3MXO2/YuBaiDJa9B0rKO6EiDClXoJMCe+EYaUVm5wxg9JpQhtY2Z4xo53dHuVpWKR2vWMuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYFkpJrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYFkpJrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD540C4CEF1;
	Tue, 26 Aug 2025 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208176;
	bh=Nye/Irry7GL+Hjd5l4I5xTxVeRV4ya6BdAQ4uUmW5yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYFkpJrW1PxS5OT7WxC2SmGjfdEvXZDq1flrB07t3jwpXXdfo/OQyg/PCi/kUwluX
	 FAF+C2RDNCOlnI3lNN/zAtyWLi8kN8uJeH3MpJVe97J//3GMvQlSVV47S29qDjCfJE
	 /2UCggOapcqwciz53U9Yel09h8Ahz+ln33NaArj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 003/322] cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()
Date: Tue, 26 Aug 2025 13:06:58 +0200
Message-ID: <20250826110915.274282908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


