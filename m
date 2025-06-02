Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99007221D92;
	Mon,  2 Jun 2025 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874157; cv=none; b=f9hEPnj9cXf8nP93tJjOzVop+Ip5NJzCDzh+sIFVzZz7HzOAyYVGQCiIjmTZ1mzrY98N7x762dfg9JPcnAVCl0XPJS+SJsQSSD2tZ/04i0rEtQ1If1q8eSQyiaebqABbsjV5ihamhRmCJCtTEaB7WZZBRCm42aIQz1simmW0ZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874157; c=relaxed/simple;
	bh=G/pfVWXN0n5gH6NOSqfr+mXc26ga0G6m1JVIStRnGbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RugESR9B/d6cqHaExkXHJnOrVNH0bYQf7qJhUhLKs+ZwbdnbOmXiDOU5qkb+cHaeqlnd+WCR+4ZZ2y/S1ZYcJEuOQ14bFjI6GByOehd/PMVsxkG5OvnbaN14typTIlpU6h+zK25WpBbvR5nH+bqFtSKKN/Adbrhjo1en+xLs1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmhTQ5N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmhTQ5N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5275C4CEEB;
	Mon,  2 Jun 2025 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874157;
	bh=G/pfVWXN0n5gH6NOSqfr+mXc26ga0G6m1JVIStRnGbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmhTQ5N/1J1uKVXT5/Mbi+KOiU4oO5aDbCrXU4NqwW9NW9NMmo3bV/bo/SZvxiG4U
	 KIKyF/YNUAw0K3Fz/RaQ+rgzOEkDUlswuLCmOkZBA3KVnrlBreWW2dhXTkq80VvJnS
	 mjdXGAeFKKGPLO40Q3dTS2QcxK9qw15uArrOG4Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	zhang ning <zhangn1985@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 369/444] thermal: intel: x86_pkg_temp_thermal: Fix bogus trip temperature
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134355.896454348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -331,6 +331,7 @@ static int pkg_temp_thermal_device_add(u
 	tj_max = intel_tcc_get_tjmax(cpu);
 	if (tj_max < 0)
 		return tj_max;
+	tj_max *= 1000;
 
 	zonedev = kzalloc(sizeof(*zonedev), GFP_KERNEL);
 	if (!zonedev)


