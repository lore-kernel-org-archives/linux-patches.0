Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34101428FC;
	Thu, 13 Jun 2024 11:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279446; cv=none; b=GnYMQfqoxZ65YILGkuwIvFWV0NMFaYdXD3wQMUwVhWoytbMy0GwyAEa0UjP4T/254ABUAqET0DA56YfqKvFhmBaZI0OPmthTYjCGqbG2i92ScBhGUYZm3rPz2EpZyjCdF3M1arXvlhmhc1VPf5ioxNtxPi7cRGKdviQlvYzvAAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279446; c=relaxed/simple;
	bh=jDp9Hu+ZfN/PSIoWoDahX5esE7oIR0zso6XfAQBRTDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2xMWI+9JH/ZEmPUN5Gxxi7DnlXdUKCha08TlIj8TalAS5v/OAPT+UG4dDOmrHEc4ePRPAI6R1HEOItHefsfmSg+pghCmRansOHu3FODQN3mdM+aQRy9xlt0hZYwuk4Lh205KSC7WH6SfEJxkdiY0lmZAJdWs3L4sHMujn8P1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Paekuivy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Paekuivy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7501CC32786;
	Thu, 13 Jun 2024 11:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279445;
	bh=jDp9Hu+ZfN/PSIoWoDahX5esE7oIR0zso6XfAQBRTDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaekuivyqUyyb1FvsruW4245Hlty+cMFAfG7rmK6ySXyFWivAMr+zfbH1KrMJlbdQ
	 GCk3oOwBoUMdtElb9GX7O0ISs4BvCstdq/zW2DH8UhWwnD06zN1LkKX04aj6kB3BdX
	 yoZfzI3T4zukegkZnlMhXIQwr1xRocoyD2gxmaVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Ben Cheatham <Benjamin.Cheatham@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 078/157] ACPI: APEI: EINJ: Fix einj_dev release leak
Date: Thu, 13 Jun 2024 13:33:23 +0200
Message-ID: <20240613113230.439580684@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 7ff6c798eca05e4a9dcb80163cb454d7787a4bc3 upstream.

The platform driver conversion of EINJ mistakenly used
platform_device_del() to unwind platform_device_register_full() at
module exit. This leads to a small leak of one 'struct platform_device'
instance per module load/unload cycle. Switch to
platform_device_unregister() which performs both device_del() and final
put_device().

Fixes: 5621fafaac00 ("EINJ: Migrate to a platform driver")
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/einj-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -903,7 +903,7 @@ static void __exit einj_exit(void)
 	if (einj_initialized)
 		platform_driver_unregister(&einj_driver);
 
-	platform_device_del(einj_dev);
+	platform_device_unregister(einj_dev);
 }
 
 module_init(einj_init);


