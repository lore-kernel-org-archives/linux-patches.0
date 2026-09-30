Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0D25187DA;
	Wed, 30 Sep 2026 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788469; cv=none; b=NhnsdIUBNyyHpAFS7mIEfBQQpcqcEnvUevr6KdlZXIDNz6ggxvTf4qr52y6Em3OiXbW2u53NwKy2XKx0KdGDDyUdMdG3I0bEzlPlwaY7mv+Oz7+E2U/AlpzKUVEUjj1DhOBQ3wGkmvPzAgVy2smpBRVbv1DpK+ehao0bBpWYAG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788469; c=relaxed/simple;
	bh=fjaKhdA2TkZPrGnIiyJ3eQMDykpPayzLxHI3RH88Gi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gsg/Lz9UUVbGIxMXn+gLfd1EKpL2XhUcGm61z0GsZ4g/SrHH0ebE4PeoTqvJ//ejfHW8WR+v1kYE4Usn72Mu9RMRkKCyG2yCTLh/8NG7Yj4A9Rw2RG5cMbMmEH0Yy5WQvvJZKEvtpwxVfijigHZgbJPHweC5N6Jbk/GEaZosBFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljI0HSKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljI0HSKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDED51F000FF;
	Wed, 30 Sep 2026 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788467;
	bh=uVpEPHf11PXgJQOAg0Fh/Y2tZUyOu0KedOYcUVt1sMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljI0HSKLggTTxVN6Q2M77+0+ufyFj1FxfjI0Pt7+UaFw0Ql2tdiMom4GMpoy8mbUa
	 emukP+A8eIUtH5ammKopZVwdR1pxuQqCStSXwAMIFWUcpnOvfwCCqShLSUjo/s1+Gn
	 P3NykrIT3H3es7cLCsxeePvmGlLA/kihZBJIw004=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/877] Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events
Date: Wed, 30 Sep 2026 17:17:26 +0200
Message-ID: <20260930152417.643819564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 78b6abd6c7a7591aacdae657f813214dae4fcd3b ]

A too-short BTMTK_WMT_FUNC_CTRL event (WMT header only, no trailing
2-byte status word) is always treated as BTMTK_WMT_ON_UNDONE. This
short form is how firmware acks a plain enable/disable request, and
the actual result is carried in the header's own flag byte (0 =
success), not a separate status word. Decode it from there instead of
assuming failure.

Verified setup on MT7920, MT7921, MT7922 and MT7925: no regression.

Fixes: e3ac0d9f1a20 ("Bluetooth: btmtk: accept too short WMT FUNC_CTRL events")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index eb42b694da7f2..33e0e3eb65159 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -709,7 +709,12 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
 	case BTMTK_WMT_FUNC_CTRL:
 		if (!skb_pull_data(data->evt_skb,
 				   sizeof(wmt_evt_funcc->status))) {
-			status = BTMTK_WMT_ON_UNDONE;
+			/* A plain enable/disable request is acked with just
+			 * the WMT header and no trailing status word; the
+			 * result is carried in the header's own flag byte.
+			 */
+			status = wmt_evt->whdr.flag ? BTMTK_WMT_ON_UNDONE :
+						       BTMTK_WMT_ON_DONE;
 			break;
 		}
 
-- 
2.53.0



