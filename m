Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129DC2550D5;
	Fri,  4 Sep 2026 05:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499549; cv=none; b=HITfoR6HWwnBoIuCqoXe1+ph8zqf4owWVEfcNeyJYqH3Kpq+nQ4MY0TIIbfB9pfSqk1z7CCWZxLg0jcppVT87ImH4k1bOfV3r/IZ/17iu2Cuo3hLxlcQnkyrvg8m0h0MSoGrRw24gdu0X6RcOC51yz1drVnLepAx2So3l5kVcxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499549; c=relaxed/simple;
	bh=PBPqD4W+/hmdLEKqBHm2+hkO0oWoUrwVKSskxkSXrls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5XXmgr1kaXjSGkidJAieBvTiDHIvT068Ix95QTwks3hxb2hnUhAEpGITWjcBJ9Bz0IKnktH/GMJvUyWpLrUsXpoCP3PeTAWs744Vxdcb8F1n0m0ykxsC4pBFIgXxKD0ep/M2H9GYL+cjXmwMcaQ2DGcV9iFSj2Wpat2jXlHGwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrgLq4Sy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrgLq4Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D481F00A3D;
	Fri,  4 Sep 2026 05:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499547;
	bh=ebEWt9rQBqZiQbyR2NGSuxQqnmc1zt1idxzg0KDuMP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrgLq4Syy1Kh8erSy2eDM+lg04JfhixueNK9xFVxyYa4/dK6YX3v85HO47WUVzaJ4
	 NTvWaNerNU/jPJq4Qp/8vAzF6FDRzQvscAqJVjqYKjzgnJTYCVfcA6PKiaMb7uPUO2
	 sgydM8uQ15M9AkZTvgaIqaaT8JQmP1H/t1uqQqjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shibo Zhu <3499129952@qq.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 457/713] PM: sleep: Unblock runtime PM when device prepare fails
Date: Fri,  4 Sep 2026 06:57:05 +0200
Message-ID: <20260904045814.069736233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2234,6 +2234,7 @@ unlock:
 
 	if (ret < 0) {
 		suspend_report_result(dev, callback, ret);
+		pm_runtime_unblock(dev);
 		pm_runtime_put(dev);
 		return ret;
 	}


