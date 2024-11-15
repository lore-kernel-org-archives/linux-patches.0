Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DFC185924;
	Fri, 15 Nov 2024 06:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653685; cv=none; b=AjsaL3YDjLFdtSH59N4oVIwxSesF8ancJRs/yB5izhgDkj/26iWRdTmTxbCN5MMcONSWufN7kKa1s/ma7rGwT8woYcPm4KgrXgI1uzTmDK9RGOXc6BACdF4xz6x/gq5Tyj5hkyiR3EGSHLBJ89AAgpnH7d/uLPr5Dd5p1xL867Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653685; c=relaxed/simple;
	bh=nX5GuuxSCm2eJub4QzSQdHCvpixjIsPQSJLkhb2h0jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0q/O/XHNAX0dtzxfEJWCCLlfHo70xC46rPYGvzB8nrPtDMJSP9OlhDguoKH0Tr+Pe6ILDXWX7hYTy1cz/q00Dc5vVFCMJQ5Y1xkCbBYSr663A0QC45Ty2YFvPwgecMv3C0lv5/0JqUSro68cy971Tnbsv6DD0TDgAeu/nfdTkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4jpTTKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4jpTTKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88B1C4CECF;
	Fri, 15 Nov 2024 06:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653685;
	bh=nX5GuuxSCm2eJub4QzSQdHCvpixjIsPQSJLkhb2h0jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4jpTTKNPVUrHcZSI7tIVJdldUIhsqKQRdF6G2583XtxdS27T/0WYRJa1CakNWRPF
	 tUnFD50ITcArBqvroDyOMLXCpnxNemPuJTXj2BJH3RJFAOvEQDHF/luzN2R4CJu4d6
	 vjYWcLHPEbPbmamhblW07kpTA3YkH8XcslWNgVG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans de Goede <hdegoede@redhat.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 37/39] platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors
Date: Fri, 15 Nov 2024 07:38:47 +0100
Message-ID: <20241115063723.944759035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2fae3129c0c08e72b1fe93e61fd8fd203252094a upstream.

x86_android_tablet_remove() frees the pdevs[] array, so it should not
be used after calling x86_android_tablet_remove().

When platform_device_register() fails, store the pdevs[x] PTR_ERR() value
into the local ret variable before calling x86_android_tablet_remove()
to avoid using pdevs[] after it has been freed.

Fixes: 5eba0141206e ("platform/x86: x86-android-tablets: Add support for instantiating platform-devs")
Fixes: e2200d3f26da ("platform/x86: x86-android-tablets: Add gpio_keys support to x86_android_tablet_init()")
Cc: stable@vger.kernel.org
Reported-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Closes: https://lore.kernel.org/platform-driver-x86/20240917120458.7300-1-a.burakov@rosalinux.ru/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241005130545.64136-1-hdegoede@redhat.com
[Xiangyu: Modified file path to backport this commit to fix CVE: CVE-2024-49986]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/x86-android-tablets.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -1853,8 +1853,9 @@ static __init int x86_android_tablet_ini
 	for (i = 0; i < pdev_count; i++) {
 		pdevs[i] = platform_device_register_full(&dev_info->pdev_info[i]);
 		if (IS_ERR(pdevs[i])) {
+			ret = PTR_ERR(pdevs[i]);
 			x86_android_tablet_cleanup();
-			return PTR_ERR(pdevs[i]);
+			return ret;
 		}
 	}
 


