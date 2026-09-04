Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B3434A3A5;
	Fri,  4 Sep 2026 05:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500806; cv=none; b=kAv4JoORZRbttuZRrlu1TRyqmMgQnhwGJgDKwuQ1/4CtaQcVAH4t88iCTbFetaKPaIkEjXcIi7c/VvbtxTlwNjvp/uYuGtAFr+gCR1cy2VgKmSJoGGRC7M87349G6YX6R2zRaOx/c7KrTg/FPdCy/EX82bYKO4nqSmIug52zhlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500806; c=relaxed/simple;
	bh=6/1OlNVIWabipiePIIq1KO5B29ZvmKCLBAQo4AP7yoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNmvEFZcM6Bs5hhNYBcaKjta77qVu7sK3ZZU0ChSOiG99YWXUF9HZ4WiqLh7RI49IdVZ/lLbLohRCHc0uOC5IvI7emHxGJJ+i9Iz740J09uR48ocaU3j2mjvqZ4vxPNXb+kHl/Vac3rtyVmkmOd+Pww+GLnsQDsHeGzbrsLxXWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERzJMrSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERzJMrSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8DC1F00A3D;
	Fri,  4 Sep 2026 05:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500804;
	bh=Av19EX/OJQlp3J3CkEMMBujxn+/TTAoL+oHsUPy/L7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERzJMrSgouIuvrUibBJa9zIbPSEy+m5BVKrIT7KQEVXd63/RHXMq7EzEbux0mpnIE
	 MfTrckhf4X2/DudGc6R3QiyopsdLwnFqCMDWFuPWfHR52STkDqT92N+jIdDZa/cQvy
	 W2PLnfi3s6/uOAfNivd3aDB1NaHw8a4xR1UBlXK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 186/552] HID: intel-thc-hid: intel-quickspi: fix autosuspend cleanup during teardown
Date: Fri,  4 Sep 2026 06:55:43 +0200
Message-ID: <20260904045753.234752193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 05dffa55fd6dbed4bf2421fae5accc2b857e668d upstream.

quickspi_probe() calls pm_runtime_use_autosuspend(), but
quickspi_remove() does not call the matching
pm_runtime_dont_use_autosuspend() during teardown.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to the driver
remove path.

This issue was found by manual code inspection.

Fixes: 6912aaf3fd24 ("HID: intel-thc-hid: intel-quickspi: Add PM implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -722,6 +722,7 @@ static void quickspi_remove(struct pci_d
 	quickspi_hid_remove(qsdev);
 	quickspi_dma_deinit(qsdev);
 
+	pm_runtime_dont_use_autosuspend(qsdev->dev);
 	pm_runtime_get_noresume(qsdev->dev);
 
 	quickspi_dev_deinit(qsdev);


