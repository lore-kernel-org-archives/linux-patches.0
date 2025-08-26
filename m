Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C57128816;
	Tue, 26 Aug 2025 12:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212601; cv=none; b=kF3EP/mjCQZH+KFJZhflP7Bvg1z6+7fmBsu0oMF0jmemyK6bPJw9XoQRaLXz0YE1kLzpUOQ9hdf+tt3vIhbd+58mDJJiRBmP3lk+D/+2VhO5g25b38F0hAC5JZGFoV2Gy3GtxnzuPnDB2kmGujIf+rMN6qqXIqLKy6j81zdJWW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212601; c=relaxed/simple;
	bh=avrj+QOJu0OCm3tOrkSt3ZpHxVlv3spHXXI8I2h0d0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTsOw+k1xkBzZzoMCUb1c42qDioqiepbNd0SPH9rlGdjnsGiKsTgTIHQDMo/Nd63y1qjB1AVTNeIh6jtSYtShtxXqK4ArQZcKMGjJxdvN9pJwxwRGniHAJQV5aa/5xYsB1gT92d+mIFWl3qzxvZc4106WDTjVGIc6xWwfSUCKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8zrQdr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8zrQdr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A92C4CEF1;
	Tue, 26 Aug 2025 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212601;
	bh=avrj+QOJu0OCm3tOrkSt3ZpHxVlv3spHXXI8I2h0d0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8zrQdr3Yd8WpSxpXw1Ezx72tKbJecsrNPByINUCx9doEae04JI23IsVSxsxR43SW
	 vpPXt4xl1A9hPPDhkgVLR+6AZF13GKjH4cDD2U2b+XWdAvooFqdyPQJ93soUDbZvfl
	 MVS5h8sIuutWJJcemE0/M1f/uUelFU+Naf/qd5P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 032/587] ACPI: processor: perflib: Move problematic pr->performance check
Date: Tue, 26 Aug 2025 13:03:01 +0200
Message-ID: <20250826110953.771145063@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d405ec23df13e6df599f5bd965a55d13420366b8 upstream.

Commit d33bd88ac0eb ("ACPI: processor: perflib: Fix initial _PPC limit
application") added a pr->performance check that prevents the frequency
QoS request from being added when the given processor has no performance
object.  Unfortunately, this causes a WARN() in freq_qos_remove_request()
to trigger on an attempt to take the given CPU offline later because the
frequency QoS object has not been added for it due to the missing
performance object.

Address this by moving the pr->performance check before calling
acpi_processor_get_platform_limit() so it only prevents a limit from
being set for the CPU if the performance object is not present.  This
way, the frequency QoS request is added as it was before the above
commit and it is present all the time along with the CPU's cpufreq
policy regardless of whether or not the CPU is online.

Fixes: d33bd88ac0eb ("ACPI: processor: perflib: Fix initial _PPC limit application")
Tested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2801421.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_perflib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -181,7 +181,7 @@ void acpi_processor_ppc_init(struct cpuf
 		struct acpi_processor *pr = per_cpu(processors, cpu);
 		int ret;
 
-		if (!pr || !pr->performance)
+		if (!pr)
 			continue;
 
 		/*
@@ -198,6 +198,9 @@ void acpi_processor_ppc_init(struct cpuf
 			pr_err("Failed to add freq constraint for CPU%d (%d)\n",
 			       cpu, ret);
 
+		if (!pr->performance)
+			continue;
+
 		ret = acpi_processor_get_platform_limit(pr);
 		if (ret)
 			pr_err("Failed to update freq constraint for CPU%d (%d)\n",


