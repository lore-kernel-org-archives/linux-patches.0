Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B458486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37366C433D6;
	Thu, 27 Oct 2022 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889872;
	bh=U06coDEuQx6pcnnN1YX/sopXo3/LMHMUqydIPEdVZLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZ5psFJ+lJsWstUCz7IfxNLUh+tSN1LWdFfUbfvy8wAHVCgBXcamjR3MhkkIBkqo7
	 Af1XEgEF0ABTHibjnQw7dI4izkScvho+KNzYjTKS9PcUrhAAl1/YScQWiufBI+9BFK
	 oohGd6cV/6nvaNjyfRwjbe70BWhl2JUHDgpUiz3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fabien.parent@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.0 06/94] cpufreq: qcom: fix writes in read-only memory region
Date: Thu, 27 Oct 2022 18:54:08 +0200
Message-Id: <20221027165057.423442254@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabien Parent <fabien.parent@linaro.org>

commit 01039fb8e90c9cb684430414bff70cea9eb168c5 upstream.

This commit fixes a kernel oops because of a write in some read-only memory:

	[    9.068287] Unable to handle kernel write to read-only memory at virtual address ffff800009240ad8
	..snip..
	[    9.138790] Internal error: Oops: 9600004f [#1] PREEMPT SMP
	..snip..
	[    9.269161] Call trace:
	[    9.276271]  __memcpy+0x5c/0x230
	[    9.278531]  snprintf+0x58/0x80
	[    9.282002]  qcom_cpufreq_msm8939_name_version+0xb4/0x190
	[    9.284869]  qcom_cpufreq_probe+0xc8/0x39c
	..snip..

The following line defines a pointer that point to a char buffer stored
in read-only memory:

	char *pvs_name = "speedXX-pvsXX-vXX";

This pointer is meant to hold a template "speedXX-pvsXX-vXX" where the
XX values get overridden by the qcom_cpufreq_krait_name_version function. Since
the template is actually stored in read-only memory, when the function
executes the following call we get an oops:

	snprintf(*pvs_name, sizeof("speedXX-pvsXX-vXX"), "speed%d-pvs%d-v%d",
		 speed, pvs, pvs_ver);

To fix this issue, we instead store the template name onto the stack by
using the following syntax:

	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";

Because the `pvs_name` needs to be able to be assigned to NULL, the
template buffer is stored in the pvs_name_buffer and not under the
pvs_name variable.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Fabien Parent <fabien.parent@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -262,7 +262,8 @@ static int qcom_cpufreq_probe(struct pla
 	struct nvmem_cell *speedbin_nvmem;
 	struct device_node *np;
 	struct device *cpu_dev;
-	char *pvs_name = "speedXX-pvsXX-vXX";
+	char pvs_name_buffer[] = "speedXX-pvsXX-vXX";
+	char *pvs_name = pvs_name_buffer;
 	unsigned cpu;
 	const struct of_device_id *match;
 	int ret;


