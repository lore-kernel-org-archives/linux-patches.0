Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA811B87E8;
	Tue, 26 Aug 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214313; cv=none; b=tOMgGoOyZYnyMHZile+Om8XSwYuCGy4gWhxlJqfHubONj+389M3Nb87PHhyf/S+4ovLYLv1KdZMUIQ2IxGOVz9TLSCWZrtk16KbbcRgzsUhx3lpiT7km0uDdWuQc9yrxuQ8NmTpAdl0KYjEm6NaaJUyMALYsa6XP3MyV1MxWkOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214313; c=relaxed/simple;
	bh=W0sYGl+jzpwW8zDfxxQtAf+BAGGXoAj6UPyOdfzMbeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWQTxFFsirDK6QREHWJ9rVVUqByW+YkoL4Erj7ucGd6ptZbOTaBXQPGrHJPXbjIO4AR2mEsMPb7Wbt+Dtzdhy9V3eBY3tYY5FeL/hhEFQGZAX535bXkM2OXpxu2RQugSPhw0zXn1aAYSnApLbylF5Rm9r57+dWMHSS8AO3X190Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiVBxyGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiVBxyGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C51C113D0;
	Tue, 26 Aug 2025 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214313;
	bh=W0sYGl+jzpwW8zDfxxQtAf+BAGGXoAj6UPyOdfzMbeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiVBxyGsuMzjQkyaRuEeZTG3+nz/4f4KWGfUzl6BO6/RSO3NwnM6QzAyPoI4itx7M
	 XF6s/7uT9T19wgYDA9cU/s16+l/gX7YitYpE4LpO3xXSpef8ZTiP3gvdbM8HjKE4Au
	 NA+Nvc74anEiHmQIk7MTOeLd2QcHJgwk4h8P355Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/482] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Tue, 26 Aug 2025 13:05:45 +0200
Message-ID: <20250826110933.100482403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f327ec4c30b..3c862acaa28a 100644
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



