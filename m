Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106EE299A94;
	Tue, 26 Aug 2025 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218949; cv=none; b=l/qkSQoL46IBySjMkIZy5G2ElCd7nrZLETRrUmf4JtGkeCjrX7eW4CAkMCK27dgFqi1epI+wvQyHo0aM+rmmq6xIvcU+N1h+jNHaA7JfSu87t3QcvXG2RGpcVobPNp/CgQwyJZLIImZQWIULeqRd9qafGXU7vcBqCIf/gSGN5iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218949; c=relaxed/simple;
	bh=QnhewsbJ+9tuNQ07pZlakyStjI0nUb4OWAPXDlZF14g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpDgIq7gzksBg4pDgB+H3mmM21w1l7DHDuhH1J6y8pYvEGmVWdcHLJ2+kWWGb/ZFZOm9IfEdi3BZKIoNtdjbGqu8Ar/hGXnSJpAVcVuxpFronyecIi7QXB3GTDfXN69deBTbLPnGNfgYuTcqIUCCus/xSbrcy4ZyMADlSCbMN90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agZRkiqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agZRkiqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E8EC4CEF1;
	Tue, 26 Aug 2025 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218948;
	bh=QnhewsbJ+9tuNQ07pZlakyStjI0nUb4OWAPXDlZF14g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agZRkiqyuTQIhKgwfrA4C4EgFNF3JRjDWFV8MpyWxr2VpHQqflPt09sFdKYmILzo5
	 BNp/kjNnoMYfPb6rK+MkKziE8vxV1laoqsDLDHz0UYYF55MVKrYEbuGb9mfu8t0y9+
	 9PSU3VpNImsrHBnpYgVleKWHhhVmU2oH1jxImaAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/403] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Tue, 26 Aug 2025 13:08:42 +0200
Message-ID: <20250826110912.283253668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 50bed5a70812..d02d7cbab387 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -709,6 +709,8 @@ static void __ghes_panic(struct ghes *ghes,
 
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
 	if (!panic_timeout)
-- 
2.39.5



