Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B382AD32;
	Tue, 26 Aug 2025 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219305; cv=none; b=lL0We5fhKHy3moQ2Tasy3iaig9M4NEVJYvWW02q6Q0ITAFaQXMIugjmOogYMARALklIEoEk5wznR5Yjc6Zs1oe/Jp3E5LL+a3uEhTJKoDR6/YwkK0VFAZTSJucvlZY2QsRYzxE93jrQyFVS97QdjlIrtmCV9z0w2VnioTlZwu+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219305; c=relaxed/simple;
	bh=GZnVsq+OZnxdgwsTOQ/JXLL/zNkregAfTuWUB97EFDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG5ogeFEKqwASuII9/zGsvzY739rotG8+5Z11z5Xe9KvT1ws/tThqX4+mmNIooCEt2sojQrtDGkAPxNXVOANrIkMaAnb07zXq0d+UtwOsONAAdekXnWGMdgU45A4a+scr61iUeuB55Bn3NcMV9by4jUgUSOzlclF8PQuUn64RR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKfzN32M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKfzN32M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7056AC4CEF1;
	Tue, 26 Aug 2025 14:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219304;
	bh=GZnVsq+OZnxdgwsTOQ/JXLL/zNkregAfTuWUB97EFDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKfzN32MnoWVv6eXzVwN1taQy7BRPsYSPnWSc81oOGB8PTd3u4C07Q7YfEgIaSsfp
	 Ch2CWAebzTkB/iRBXh5DP3x/nRuOw1Se72AGS2nqZsMknl9sb21wPpy36+CI7cuYWy
	 Stxkt7hTbfTdMLlXCGqvw0jKOxuC8e/5iJUoavBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Teddy Astie <teddy.astie@vates.tech>,
	Yann Sionneau <yann.sionneau@vates.tech>,
	Dillon C <dchan@dchan.tech>
Subject: [PATCH 5.4 331/403] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date: Tue, 26 Aug 2025 13:10:57 +0200
Message-ID: <20250826110915.977591643@linuxfoundation.org>
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

From: Li Zhong <floridsleeves@gmail.com>

commit 2437513a814b3e93bd02879740a8a06e52e2cf7d upstream.

The return value of acpi_fetch_acpi_dev() could be NULL, which would
cause a NULL pointer dereference to occur in acpi_device_hid().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
[ rjw: Subject and changelog edits, added empty line after if () ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Signed-off-by: Yann Sionneau <yann.sionneau@vates.tech>
Reported-by: Dillon C <dchan@dchan.tech>
Tested-by: Dillon C <dchan@dchan.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1228,7 +1228,9 @@ static int acpi_processor_get_lpi_info(s
 
 	status = acpi_get_parent(handle, &pr_ahandle);
 	while (ACPI_SUCCESS(status)) {
-		acpi_bus_get_device(pr_ahandle, &d);
+		if (acpi_bus_get_device(pr_ahandle, &d))
+			break;
+
 		handle = pr_ahandle;
 
 		if (strcmp(acpi_device_hid(d), ACPI_PROCESSOR_CONTAINER_HID))


