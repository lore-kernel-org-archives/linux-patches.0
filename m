Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B8734A32E;
	Tue, 26 Aug 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216192; cv=none; b=fwHKI4HfzwLaPVdmbh1MNDwwta6leB41ZYjVPxsS3S92POR2hIkXp4Jdioou9U8r0YbAHmt0Rdp3pup7xYfzf0KIoyjyuMA5qFrZZbEOrRD2ud5Zu2oy4SHj8A0G5QEd3E8VaOOAZDb+CMxmVrT8n+ZUO4PUjGKlPrDX4JfUefg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216192; c=relaxed/simple;
	bh=MpaSvR5DLCvf8O3cRpprGshLSN79sKuC+UmzM2+/Kkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB5DmEZEZ43Cbr4GDT7CNA/PVCENx+4FhVIb3+/r9wAWKTHpVL4MzfD120GA1xB6jGn1Ctv2fUJmTpdrT6Z8NLmgWCHpm4hRwJoI6VYio3vV09ZKS+Zrswu/V/CGQHeGcxC5cnbWjcQ0AHp7Y50NEW3Nf5BjZO7Sp8hTyAPU5a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSGqTxTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSGqTxTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5182BC4CEF1;
	Tue, 26 Aug 2025 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216192;
	bh=MpaSvR5DLCvf8O3cRpprGshLSN79sKuC+UmzM2+/Kkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSGqTxTmOmMsMUrgsTAAkckYJlTaq536c5eYXq8OD6UiD1cuvrI7Uh0LBUnsiPyfR
	 fKLyX6Du+S2L7MtuCrk63HanU31yjUuuv0CWS0WshoKS3ySYaxjCI5Tg0+Qndtk7l+
	 Q3b+dHjwIHVLHjyEq0VeF44Tvnz05i7WTl1nd9WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/644] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110954.289345986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index 72087e05b5a5..250ea9ec5f0c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -860,6 +860,8 @@ static void __ghes_panic(struct ghes *ghes,
 
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
 	if (!panic_timeout)
-- 
2.39.5



