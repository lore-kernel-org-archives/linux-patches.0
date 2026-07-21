Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F133A9FC;
	Tue, 21 Jul 2026 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666653; cv=none; b=EjPwsxDCQ5j/DcQPruZg+mRcv2ECxlR74gDWLP+VsV4Fr2gRT4m83uYmkdzidmkvpqBlUOzw6R9B1rFXymq/FytcKF6XyxUZ/qKxeWHCECmmHB1sirUyOz4KVL73WTnQe62nl6qrOMjjKNL2aKq/+ZHNMfRPc3E40NhSadouYaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666653; c=relaxed/simple;
	bh=N1Dd5CYAMzivGC3fmaIGihWykTHL2snyrA/xp2rJJAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPfcBIJN8RKr1l0X5+awBkTtN2ovHZ5vHfdZmU3ORSA5ClWD4B5SHSicoRW9Ke9Q7C55kX2BpaXfD5qLm+rmG56D0nX+bigHGSuEmIUNmlgSgxN8fBNcvNrH99mvOAJb3hswgTUfQHePq27XYETehYdMANQo93yGWxkKkx4hfss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RobS8MvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RobS8MvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8F31F000E9;
	Tue, 21 Jul 2026 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666651;
	bh=6MNhAyN47F5TplqXWchOKLYJqGLKkvIJG68nKBVprhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RobS8MvJpBKbysO8L9QnwqmlUyOgs8nTe3YLMS4vjFC9B/spwwupNgT7NvC/xBoiI
	 nDsr8suVOtl5lb+6c/Yjdf5iLZj74XPYXSF/yIn7eGLs0edqES/kwEtRM3DuG2gEwu
	 9KoBSDPvuhCTeqakyj/fvI7OB++QLPaxGGfB63jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0737/1266] ACPI: IPMI: Fix inverted interface check in ipmi_bmc_gone()
Date: Tue, 21 Jul 2026 17:19:34 +0200
Message-ID: <20260721152458.365729285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 71b57aca295d61276a60e131d8f62b0cc7cf1a35 ]

Before commit a1a69b297e47 ("ACPI / IPMI: Fix race caused by the
unprotected ACPI IPMI user"), ipmi_bmc_gone() skipped entries whose
interface number did not match the SMI being removed, then killed the
matching entry:

	if (ipmi_device->ipmi_ifnum != iface)
		continue;

	__ipmi_dev_kill(ipmi_device);

That commit folded the removal block into the existing non-match test
while converting the object lifetime handling, but left the comparison
unchanged. The old != meant "continue past this entry"; after the
refactor it meant "kill this entry".

As a result, a single ACPI IPMI interface is never removed when its SMI
disappears. If multiple interfaces are tracked, the first interface
whose number differs from iface is removed instead, while the interface
that actually disappeared remains on driver_data.ipmi_devices. The
stale entry is not marked dead and can continue to be selected for ACPI
IPMI transactions. It can also prevent the same ACPI handle from being
registered again.

Change the comparison to == so ipmi_bmc_gone() removes exactly the
interface reported as gone by the SMI watcher. This restores the
pre-a1a69b297e47 behavior and is the correct interface matching logic.

Fixes: a1a69b297e47 ("ACPI / IPMI: Fix race caused by the unprotected ACPI IPMI user")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/B486593E06E6F6E0+20260616093621.1039943-1-raoxu@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_ipmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 148d9486106cad..acecb7f86fd976 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -485,7 +485,7 @@ static void ipmi_bmc_gone(int iface)
 	mutex_lock(&driver_data.ipmi_lock);
 	list_for_each_entry_safe(iter, temp,
 				 &driver_data.ipmi_devices, head) {
-		if (iter->ipmi_ifnum != iface) {
+		if (iter->ipmi_ifnum == iface) {
 			ipmi_device = iter;
 			__ipmi_dev_kill(iter);
 			break;
-- 
2.53.0



