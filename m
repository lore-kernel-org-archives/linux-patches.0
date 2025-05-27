Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D51E89C;
	Tue, 27 May 2025 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366093; cv=none; b=IqlPS7h41qbfT3XLyLWt8Wm4CQjMeD1/G3mQgkrFbYVpDphzJvdhZG6xgm/9+lgZytK2wTgml/xsfvzdUB2iwwO84IozF2k40K+j90cjwDjM3tTIErnSB6s+PAy9kFv585iIx59CMZXv381OD//C6rqt/wVQ2ckOqIoHheS77O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366093; c=relaxed/simple;
	bh=JsvqQXapHETlAZIENT/1qU6WSCBLspmyF/Ru5sa8Qd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiuvAqPUyBssV9XqDDOQVdd+I9LHi45maYu+V1+8TRkXPSzkhpD4ij1FT+YrkOVnqj9OdrGaRlGwb2ZT5wbTFjdSmVS7FDEVgZ6D6fHnfGEC11ZV0pdY0W7GSd/jZuMbwQrdE7GdYVBvbsY3m/UI0FVudwCrim2rdJrBKePRkAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=102rAmEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="102rAmEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83E5C4CEE9;
	Tue, 27 May 2025 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366093;
	bh=JsvqQXapHETlAZIENT/1qU6WSCBLspmyF/Ru5sa8Qd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=102rAmEMJH9iioCeydGPRBhNf3LIsH7CZJOcGsHVorBV6960g+9v6u8ZJgozzi9g2
	 9C+4sH/FoNmNvvHh4r1NL2h2q569O7D7SWsJ0aDKZWDuFbpK+b0mVLa2G5F6mTtAZR
	 dVcSzQtLsmjSFKsWbvbYWwbpFp+So7P/CCKH6XWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	zhang ning <zhangn1985@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 589/626] thermal: intel: x86_pkg_temp_thermal: Fix bogus trip temperature
Date: Tue, 27 May 2025 18:28:02 +0200
Message-ID: <20250527162508.913032415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit cf948c8e274e8b406e846cdf6cc48fe47f98cf57 upstream.

The tj_max value obtained from the Intel TCC library are in Celsius,
whereas the thermal subsystem operates in milli-Celsius.

This discrepancy leads to incorrect trip temperature calculations.

Fix bogus trip temperature by converting tj_max to milli-Celsius Unit.

Fixes: 8ef0ca4a177d ("Merge back other thermal control material for 6.3.")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: zhang ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/all/TY2PR01MB3786EF0FE24353026293F5ACCD97A@TY2PR01MB3786.jpnprd01.prod.outlook.com/
Tested-by: zhang ning <zhangn1985@outlook.com>
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Link: https://patch.msgid.link/20250519070901.1031233-1-rui.zhang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/x86_pkg_temp_thermal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -329,6 +329,7 @@ static int pkg_temp_thermal_device_add(u
 	tj_max = intel_tcc_get_tjmax(cpu);
 	if (tj_max < 0)
 		return tj_max;
+	tj_max *= 1000;
 
 	zonedev = kzalloc(sizeof(*zonedev), GFP_KERNEL);
 	if (!zonedev)


