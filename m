Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0F1E5718;
	Tue, 26 Aug 2025 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212819; cv=none; b=KYx4W1eUdKEYCGwYVUUZcIT4svPT+2uSiPnbb/GkKWoucs89fmyFmHG/dxyhAwLRLGlJ7VyFr8lD6ggeoUQDIPJdOcm6PjKzJmqB1ncvUf3hHFBMhsLPEfNsZvWhZ/oxqsNtgU3nWwinN0cDiHrUJscAACUlJhd0eRMaoqjDY40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212819; c=relaxed/simple;
	bh=IVIZUylAxAyD7r8gcHhbtmCqYp6ugG/YHZtKVOFtFek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyXeWUXaCIKmzY86gGpusKNWJavWTr8l0pLDt6rHTIsIEq++rVsojYKgldxWZb2VsY5jAmyAMkh8EHUy5lsGy2vlLAKyX2YE2ECjONeBx9GEythBYSPJfgedfClFHR1ApO35GkLdp+lsV/3JNhH7PKjI2HHgLGDSZeQSffEytr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOzsruZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOzsruZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABF5C4CEF1;
	Tue, 26 Aug 2025 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212819;
	bh=IVIZUylAxAyD7r8gcHhbtmCqYp6ugG/YHZtKVOFtFek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOzsruZRK7hAkTrZWcoVWSW9Y2yX5NyPs41QM2FvFTyaBWrRVnJyYM/DBUJndjv1h
	 e7mkw350yMT5ohJYiOf0S42JuTn3hljKZl72lKn5HciwbGqoB5LtySvlDZTujZKa3O
	 NdSSGFYwk0/SvXO0FTOZ8k6BblIp4H1KJFcKEn+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/587] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Tue, 26 Aug 2025 13:04:23 +0200
Message-ID: <20250826110955.844663509@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4734c8b46b901cff2feda8b82abc710b65dc31c1 ]

When a GHES (Generic Hardware Error Source) triggers a panic, add the
TAINT_MACHINE_CHECK taint flag to the kernel. This explicitly marks the
kernel as tainted due to a machine check event, improving diagnostics
and post-mortem analysis. The taint is set with LOCKDEP_STILL_OK to
indicate lockdep remains valid.

At large scale deployment, this helps to quickly determine panics that
are coming due to hardware failures.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20250702-add_tain-v1-1-9187b10914b9@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 22db720b128b..ec364c254112 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -912,6 +912,8 @@ static void __ghes_panic(struct ghes *ghes,
 
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
 	if (!panic_timeout)
-- 
2.39.5



