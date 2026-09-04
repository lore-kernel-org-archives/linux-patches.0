Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE409248F64;
	Fri,  4 Sep 2026 05:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501222; cv=none; b=LjnT2orz++aCToCslRXoh6PTEXZ4dPCi8cW8qDD3KU4XCywSKUe1QKnn2el9KfxRfWRfqO7dWlb9/E9+QNNbHuq5spOOLqQGq1Q5AVswVb3NFU17Husq3lxzn0MTZJngoYxiR1/nRdfXqt6yIfcIHAw50e7ywWmMjsWCfi/Fz1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501222; c=relaxed/simple;
	bh=trG+9e//BVBIrvewIpmcdGxwrt6f/tIQxoiV4D7QRa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7136y35YCrLXkBBBRCZ052WxbDq+3hDWum1h7MxZ4xJDyQoW7WbNKI5yYZRfJONmtKGoxaSWFakyosLORnsFGhuUDOgTUZQBPKXrhTpumiW05SuLXc+zhHflO4g3vWj+nGsOB2NDvuCaIF3VVqtjkXOFoy1AVQtHUKCOUl0kQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNbpGN7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNbpGN7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4691C1F00A3D;
	Fri,  4 Sep 2026 05:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501220;
	bh=w/QhGNGY2ncJ/g9HbSbSD/jDLsWNDGvn0fd8CrNNcls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNbpGN7oS0QaaEJQteaHDcV3ipSRsWmIvGOxNBEsvdsRSIdeC2VbPz8slzBITbCCY
	 OqXFoE6bbdRfW3dQmiK2JsqNEOgKhSxqgT4gIpRZzMlNVmI4uA3TW6N54MGKKoPlpc
	 ysT/4uRUOz+O00U3HQ4/80rtdXb3fFEB7qac2ioI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shibo Zhu <3499129952@qq.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 332/552] PM: sleep: Unblock runtime PM when device prepare fails
Date: Fri,  4 Sep 2026 06:58:09 +0200
Message-ID: <20260904045757.791425486@linuxfoundation.org>
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

From: Shibo Zhu <3499129952@qq.com>

commit cb258d651d747a7f7063d40f145418bee562ceaf upstream.

device_prepare() blocks runtime PM for a device with runtime PM disabled
before invoking its system-sleep ->prepare() callback. For a device that
has never enabled runtime PM, this changes dev->power.last_status from
RPM_INVALID to RPM_BLOCKED.

If the callback returns an error, dpm_prepare() does not move the device
to dpm_prepared_list. Consequently, the recovery path through
dpm_complete() never calls device_complete() for the failing device.

The error path drops the runtime PM usage reference, but does not clear
RPM_BLOCKED. A later legitimate pm_runtime_enable() then reports:

  Attempt to enable runtime PM when it is blocked

before clearing the stale state.

Call pm_runtime_unblock() on the prepare error path before dropping the
runtime PM reference, matching the cleanup performed by device_complete().

The issue was reproduced with a platform test device whose ->prepare()
callback returns -EIO while runtime PM has never been enabled. Before
the fix, last_status remained RPM_BLOCKED after the failed suspend and
the first pm_runtime_enable() produced the warning above. With the fix,
last_status is restored to RPM_INVALID and the warning is absent.

Fixes: 3e5eee147b7b ("PM: Block enabling of runtime PM during system suspend")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Shibo Zhu <3499129952@qq.com>
Link: https://patch.msgid.link/tencent_C5AC0A02FC01F700E764F8C2E3ECE4F41009@qq.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -2161,6 +2161,7 @@ unlock:
 
 	if (ret < 0) {
 		suspend_report_result(dev, callback, ret);
+		pm_runtime_unblock(dev);
 		pm_runtime_put(dev);
 		return ret;
 	}


