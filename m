Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC6D175A6B;
	Mon, 17 Aug 2026 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977855; cv=none; b=DTaZ3hdpVspcmn4+l/z/mcnUBhET781VEbbSHskYRNWOsBOKyA5dJ2HiEKRnidpwONhiW8Q7mZghgsgRmVBkDOiamnLDNa6IypqTnJD10Cyd3SS0DXb1EPAoELz2bdrmLLv/1jyFgUKv0rLKk7A15fjvjXYQ40b2pY94k0CE05o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977855; c=relaxed/simple;
	bh=tldzCz3ygA0/FLTPE9lXMWh7/j5j5YxqjRcUzy4NvPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtz484IwE26h8R7QREfSyorSUyBBx5xr2lYOxErFafFAV8kHDb7cUu725OBFnh90DnhxF746uzi2pvxnOhOtqQh2Cg4GZZl/P3FeSSxvuuyMpa6Dvtyd2OIkKjqJ3lX+obNSVRan1hf6xW5Q7tB87eqENdxczysYq+d8+H3czKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr8SPDyg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr8SPDyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E391F000E9;
	Mon, 17 Aug 2026 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977853;
	bh=pdgdn320s+SmKd1KJEG+0C1qF+PT7lHU+ehNCqVp9hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fr8SPDyggnxFQpU8T+DX4S55wHYETnToY+a5iqKK+H1q6K4ANzfFDZxZsGCPEdS7I
	 jTggulMjvl27+YUBUn1UvmevXjbWsOosPSqejLAqUopRC2PBZyehR/vT81HZBedywK
	 g5FoEXebaSSBJoMJeoImzisSSzX178HQwweck4o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/181] pds_core: cancel pending PCI reset work on AER recovery
Date: Mon, 17 Aug 2026 15:31:51 +0200
Message-ID: <20260817132536.071978706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 57d635329d799b79096155cdf47ee0013d6780d1 ]

pdsc_check_pci_health() queues pci_reset_work when it sees a broken PCI
connection, and nothing cancels it. When the PCI core starts AER
recovery, pdsc_pci_error_detected() runs pdsc_reset_prepare() and
recovers the device, but a pci_reset_work queued just before is left
pending. If it runs after recovery released the device lock, it resets a
device the driver now considers healthy, bouncing the link for no reason.

Cancel pci_reset_work in pdsc_pci_error_detected() after
pdsc_reset_prepare(), which has already stopped the health thread so it
cannot requeue the work. cancel_work_sync() is safe under the device
lock here because pdsc_pci_reset_thread() uses pci_try_reset_function(),
which returns instead of blocking on the lock. Only PFs initialize
pci_reset_work, so guard the cancel with !is_virtfn.

Fixes: 81665adf25d2 ("pds_core: Fix pdsc_check_pci_health function to use work thread")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260714180223.1642792-2-nikhil.rao%40amd.com?part=1
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260727170030.361116-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 2329396ec3e25..9526223a72978 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -550,7 +550,11 @@ static pci_ers_result_t pdsc_pci_error_detected(struct pci_dev *pdev,
 						pci_channel_state_t error)
 {
 	if (error == pci_channel_io_frozen) {
+		struct pdsc *pdsc = pci_get_drvdata(pdev);
+
 		pdsc_reset_prepare(pdev);
+		if (!pdev->is_virtfn)
+			cancel_work_sync(&pdsc->pci_reset_work);
 		return PCI_ERS_RESULT_NEED_RESET;
 	}
 
-- 
2.53.0



