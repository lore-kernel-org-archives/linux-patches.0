Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BB62C3267;
	Mon,  2 Jun 2025 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876542; cv=none; b=vAQZiU9d9god9hjzpZpArToyeqU3WGogs2rGSKuOfYZQBGZkGa65167XWtcy4NQcxAwYPaTCWSXADLsaqJ3ip1BZGdl+DD//cNUfNENKOYVX+//+djHtzrCLj7ZMeh73gGzxOvY/CRl0vk+j0VFcgEloywdfYKOJ2AhWPr5uPkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876542; c=relaxed/simple;
	bh=toZBHg2s4ovtKke1psdLIzndIYk6R/aIK1vom8oG48Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpYQo6ZZPBsvcBAY8fLBRExGgZ28xTJuBtpVL1HA3Aym9JY85XnYpxMCVp03EZf2KktZoob7JoTBk1zm4jtEc7h8WhJ0ylyKtJTOBRgIktMhpM3pjrzGvaIXBpNoFYA44QSuLt3GmPQPcivGzdejaVU7XCTSLA6AOfJrkcI6ZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyOTlKUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyOTlKUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53ACC4CEEB;
	Mon,  2 Jun 2025 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876542;
	bh=toZBHg2s4ovtKke1psdLIzndIYk6R/aIK1vom8oG48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyOTlKUGhYnlb8yvJNvEEeHBy4n+91KNh1sIyIWqPSxlyENGu/+r/4bk4voe/LOIw
	 51ln4ss7W2nlkcYtykw7c/v8KXq3OWvZawB6BEWQ6QMWNTGswHUFYHbySPk7WKWIYX
	 kkN23vYc0KZH77zzcbwCsNTiwOWTR9EANtsEwD94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 207/207] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:49:39 +0200
Message-ID: <20250602134306.901337462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 597704e201068db3d104de3c7a4d447ff8209127 upstream.

For all the complexity of handling affinity for CPU hotplug, what we've
apparently managed to overlook is that arm_cmn_init_irqs() has in fact
always been setting the *initial* affinity of all IRQs to CPU 0, not the
CPU we subsequently choose for event scheduling. Oh dear.

Cc: stable@vger.kernel.org
Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/b12fccba6b5b4d2674944f59e4daad91cd63420b.1747069914.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ backport past NUMA changes in 5.17 ]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1512,6 +1512,7 @@ static int arm_cmn_probe(struct platform
 		return -ENOMEM;
 
 	cmn->dev = &pdev->dev;
+	cmn->cpu = raw_smp_processor_id();
 	platform_set_drvdata(pdev, cmn);
 
 	if (has_acpi_companion(cmn->dev))
@@ -1533,7 +1534,6 @@ static int arm_cmn_probe(struct platform
 	if (err)
 		return err;
 
-	cmn->cpu = raw_smp_processor_id();
 	cmn->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.attr_groups = arm_cmn_attr_groups,


