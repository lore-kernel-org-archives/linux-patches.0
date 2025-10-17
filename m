Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D7E2F12D9;
	Fri, 17 Oct 2025 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714701; cv=none; b=t8YX01/rXXJJyKlCj8giqa1qsE6g3Rscs7zHFSmz2qyuNMsNecStbPUKEFl7kXCDPAqUWohrwiWG4j6bPp0cI1HO+egQBNcxc+INVOfTuEKATqK+vGnUr/D+BR0bOFSCylvW/hmjWyaZEniAikY+Iy8Xi42iKS6iF6iHJs5y/ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714701; c=relaxed/simple;
	bh=7jpaEoClsf3D5fgToDrYFthQgm4X0JyR7A/8LFDpdlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOo8togqQdod9MllwdkgcMt/tAwR1hSZ/Iu059gaWFvA0rOo+pFdOu+pqVQ8p0v67CkJF54ymm4TtP6ee92aMEhNtDqzbg40VnPlbYEM2LfqnnMMON+Qir4f1Sfo37ELWI2IlXsykMLqyEJf9IWgfyMaTxpHsBaicIB4fnBcxV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eITGWbTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eITGWbTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F16AC4CEE7;
	Fri, 17 Oct 2025 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714701;
	bh=7jpaEoClsf3D5fgToDrYFthQgm4X0JyR7A/8LFDpdlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eITGWbTo1wOpklmIh94UPf4QA7DJ4wsZjy8rHSI/U/BgSc+bu7S7I4oWxX1mCEHAV
	 2ApLMhfrrIiNH9L1PhxSKf0GN4aGSDDbQDo1dMvCVbBTC9cF76zuVmajsBmwer3kfv
	 zRUivl4hYNOC0fjvyJmrVX33I6CvtwQQVi8XuTmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/277] mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag
Date: Fri, 17 Oct 2025 16:54:02 +0200
Message-ID: <20251017145155.718501637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 64e0d839c589f4f2ecd2e3e5bdb5cee6ba6bade9 ]

Testing has shown that reading multiple registers at once (for 10-bit
ADC values) does not work. Set the use_single_read regmap_config flag
to make regmap split these for us.

This should fix temperature opregion accesses done by
drivers/acpi/pmic/intel_pmic_chtdc_ti.c and is also necessary for
the upcoming drivers for the ADC and battery MFD cells.

Fixes: 6bac0606fdba ("mfd: Add support for Cherry Trail Dollar Cove TI PMIC")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250804133240.312383-1-hansg@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/intel_soc_pmic_chtdc_ti.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/intel_soc_pmic_chtdc_ti.c
+++ b/drivers/mfd/intel_soc_pmic_chtdc_ti.c
@@ -82,6 +82,8 @@ static const struct regmap_config chtdc_
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = 0xff,
+	/* The hardware does not support reading multiple registers at once */
+	.use_single_read = true,
 };
 
 static const struct regmap_irq chtdc_ti_irqs[] = {


