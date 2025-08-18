Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D73335BAF;
	Mon, 18 Aug 2025 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525239; cv=none; b=Xui7ZC5Ugcq/kya371EOoGNK+kaFr5kzAJ805PFUBpgHt0ZlcvCoKHMYP3FcoMaS3W5dDrye5rJkBhBUnS7ow/gbhX1v1pIJHPEegA8eymn5608pDqTYqswDxMUpA4o9dDZD+6k/e7CpQ7qqvSVRf5FC5e+ZhQ1dpK2uPGEF+P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525239; c=relaxed/simple;
	bh=VQg9kOpW/R3vungOZ3Ca2uu/KLjCD1MbCPONwhNPwSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9Ml4MN7Vcm6Gar4eRLXnXm1GxHBoo/Q9DiDrMZWiNyVTIfhrSIp43wzUXq1InBBhOA7SXEEQV6X0Pb2A/hbVZ5Cq/MjDB/GlzPCejp1c7KA851RpPOAaWlhMMtuSdLCUVDRij32dlgcd8voAKgPLFmVfLzeoIMnCpftecaIlVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U11G1b/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U11G1b/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ABDC4CEEB;
	Mon, 18 Aug 2025 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525238;
	bh=VQg9kOpW/R3vungOZ3Ca2uu/KLjCD1MbCPONwhNPwSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U11G1b/qNb2+uyfnQl743GcYnG+2kn7/mz/U0PPLLHEpun+gYSf5PAXQhwXFZblz4
	 226dJKvaMT0DlCplePPhUhZ2nwnFrNxdYTV047jcx9ULLkqrqV9Bfj9PP6s8tBD+JR
	 tEsbxmflFXa+hl/VS+FkBe0gGHDJA5DtKKO9kq9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 169/570] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Mon, 18 Aug 2025 14:42:36 +0200
Message-ID: <20250818124512.309134125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 281a0a2f6730..bda33a0f0a01 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1099,6 +1099,8 @@ static void __ghes_panic(struct ghes *ghes,
 
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
 	if (!panic_timeout)
-- 
2.39.5



