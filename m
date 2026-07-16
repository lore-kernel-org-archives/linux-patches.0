Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56A42CB16;
	Thu, 16 Jul 2026 14:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212393; cv=none; b=PLp6HIx5rf475PtmxC7cCRA4vbQ87vvsqIpxUcp7pTHag+SEJlNPTtFaSpNT18T26TkpTyrrKuCMLwi9e20oqPO51RiAv+fvOG0KbuUd9sNX4zfm7oyBbD0rpYuUA5/A1rgG6NpIbnf/VdgzJvg3TZMyN5xiZjzLSv5/pUJYVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212393; c=relaxed/simple;
	bh=v/YD01RVw/TXUwa+G3BJgiBPpLKbAH7I1/5r1E4yKx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kehLYoG6/7HhXaS6gsnN+okidIVrwb13hmaVR5fgO2OjvfAjLiTnq2Y4g+rTkoaM3ccxgGukL7j5sfAR5Nh0NIsdCS1qP9CTCG1oqk9Gw1JFX3/KKDL6Cc1QB7dsYxOwe9y7/xcYw7Wq+7ATd8mPIHbe/BBYH+yFQ4a+rg3i6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxpUvpwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxpUvpwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F731F000E9;
	Thu, 16 Jul 2026 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212392;
	bh=ZB/aS4LiNlLn68Id8JlhwePL7QeHHun92B6G1qgczZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxpUvpwIKjNfpUUznp2Ix0a8gQQhkCxielK969slDXWns0T9SexgrqDVeJrzCZ0t+
	 0Bmppo80ZpJ5GfgsepmppNhWrrzRZxohexkejjLSKLEvIS5DF/u1ps+dMSPgfQPxJB
	 OedhASk/SHh03pUbGz1hkCPPZacppSofwwrdn32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 283/349] crypto: qat - notify fatal error before AER reset preparation
Date: Thu, 16 Jul 2026 15:33:37 +0200
Message-ID: <20260716133039.670410089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

commit 6931835f2fdd0cb9b1c7791748d7e67d0749056a upstream.

Send fatal error notifications to subsystems and VFs as soon as
AER error detection starts, before entering the reset preparation
shutdown sequence.

This reduces notification latency and ensures peers are informed
immediately on fatal detection, rather than after restart-state setup
and arbitration teardown.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,13 +33,13 @@ static pci_ers_result_t adf_error_detect
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	if (accel_dev->hw_device->exit_arb) {
 		dev_dbg(&pdev->dev, "Disabling arbitration\n");
 		accel_dev->hw_device->exit_arb(accel_dev);
 	}
-	adf_error_notifier(accel_dev);
-	adf_pf2vf_notify_fatal_error(accel_dev);
 	adf_dev_restarting_notify(accel_dev);
 	pci_clear_master(pdev);
 	adf_dev_down(accel_dev);


