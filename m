Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124D322556;
	Mon, 18 Aug 2025 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523496; cv=none; b=DloNpNW/PDTZQmI3Lk4R52SwvQEi6juxHcVeAtkEqn4YxQUrTzVf6+vn2TT5JeUuU2vzuteeE2sH+dh3phA50IVLhjV8quyVeY6NEarLYvKsgszrra/Kna/xHDljq42okzl885H7TBT3o6ho8bg2w5G2EKDg5CQDX2knoCFYg3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523496; c=relaxed/simple;
	bh=a8PU34bVY4axGSCJowJxtYZJQNfkrrsmnMiE98ExQjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ38LI0pFzpPePDS3jeRkEP/PNVEjEW9SaMHOkVRtbPuVFr5rfoc2CjI0gXZgkHaa5vDFJh3GH6oHeYFssbUmSk26G0bNAZOfEP88GX7wUh4SinvLjcd0e9w931clJneBky4lYxT4Lyxgwxccl5PZRYgzJJl2ovNRXrK701J/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvF1T7Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvF1T7Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7039EC4CEEB;
	Mon, 18 Aug 2025 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523495;
	bh=a8PU34bVY4axGSCJowJxtYZJQNfkrrsmnMiE98ExQjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvF1T7CiTHFXSHjNPLQra2mM32yR+QHOQ0ifxiD5BX59tT4L24cQzPF6kmQSmWg93
	 PAt+pYfzCBcA6eftk6HWxNI/iz3JyseGEGWjnQz93x3xgBEayc5e4W9yPLqJqPVfuR
	 Gjzo8u8sATitoO5hiTvOvTY1++p1/tXhK06nVzQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 156/515] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Mon, 18 Aug 2025 14:42:22 +0200
Message-ID: <20250818124504.393001732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe9bd27367ee..ce9b8e8a5d09 100644
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



