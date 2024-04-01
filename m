Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59174AEFD;
	Mon,  1 Apr 2024 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989395; cv=none; b=ko3wFOXWlk/nhXaP+BhrB9Hhv9iCrvhTa5uj9cqCxPqviCgP4oQKfg6oSclmpmTNGZ/sjLMT5ZhNEIDHtCvaeljMD5aXsPDx2fekr8flO4J3nJqisJdoekS40yTg19u5KZVOoWFw2SRB+SWKbqJ95Q5Ra22YPvUaiI0GVn6T/Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989395; c=relaxed/simple;
	bh=mJ5rHIUsVWM4mT6oEgtmi0lCShEy97ld9MWXQhC+P5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhH0JlBNqm6Cgi3OX/gdquZLn9k3/1w4F22Nav468kpMFrNiIku3moo2g+0daJ7VrRNuw//3bX+GdjsUexVjtIo+2kp/kRCHW2WA9rS66qqLfNCf8SipLapaX5BfbPZgyCc2mjF4uPqYAgvC7hF2z5pFzYsppaHjZ0feoxwnw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaFDMvOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaFDMvOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA14C433C7;
	Mon,  1 Apr 2024 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989395;
	bh=mJ5rHIUsVWM4mT6oEgtmi0lCShEy97ld9MWXQhC+P5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaFDMvOBAxfbOirYr4v+vap1kG+ZCuQeXSxJjiS/M08rUoVCSSqn6+rynlDLt9fW5
	 UkQFUXyQogjAfZZo/e9eYTFldKnRFZe+hPLClwbQPrNL3z658onOyfKT+ZeYCza+Lq
	 leoWNn6LOZD49oNHO8EfnwIIF2gWGpCX/mLgUfzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/396] powerpc/smp: Increase nr_cpu_ids to include the boot CPU
Date: Mon,  1 Apr 2024 17:41:25 +0200
Message-ID: <20240401152549.004908324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 777f81f0a9c780a6443bcf2c7785f0cc2e87c1ef ]

If nr_cpu_ids is too low to include the boot CPU adjust nr_cpu_ids
upward. Otherwise the kernel will BUG when trying to allocate a paca
for the boot CPU and fail to boot.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231229120107.2281153-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 58e80076bed5c..77364729a1b61 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -381,6 +381,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 			nr_cpu_ids);
 	}
 
+	if (boot_cpuid >= nr_cpu_ids) {
+		set_nr_cpu_ids(min(CONFIG_NR_CPUS, ALIGN(boot_cpuid + 1, nthreads)));
+		pr_warn("Boot CPU %d >= nr_cpu_ids, adjusted nr_cpu_ids to %d\n",
+			boot_cpuid, nr_cpu_ids);
+	}
+
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
 	 * meet various levels of the architecture:
-- 
2.43.0



