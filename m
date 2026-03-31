Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C192FB632;
	Tue, 31 Mar 2026 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976524; cv=none; b=qNLtaU/5PeUKWnaRMFI939ATO+mEhAJTz0n+X9tlhbqaVHKBVQ4n85TRZnksnPAy76wL6dC8r7FySHzw33/wHyKbe7sekgj7+RFezUV2CNrb6P0qAtL6B1g3Ph8IeELFOaQVBI3eyxpVQanLfhPdga2HQQhN2ajh4NDq5mc0aD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976524; c=relaxed/simple;
	bh=U02h65fJvGC52D5m2L0XISAmjT3f0e/YpMRbEpZNd+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd5oO8lX41iSz/aYEdkedOEp8HaEZKeH9cigNCCXB5vZkrnNq4M9YPNz4J7edphieE2qC6frIBcO7yib/gvTpAt/s3lN8AjebZoi7ou7f+nxZMIymuVtKIoM38LmOF78U3jps0CpzY9FoBVcb7OfWjRdeefPbs/JFe19Kd+mQyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2y1l3Zn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2y1l3Zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480E1C19424;
	Tue, 31 Mar 2026 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976523;
	bh=U02h65fJvGC52D5m2L0XISAmjT3f0e/YpMRbEpZNd+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2y1l3ZnD+ZqdAZxclYNV/kJttcVBxuUFzFVhbj1plxNWTsw8myxx/1gufflHaenf
	 0fWCgVkFMSJ9YZHr6V8ggDk0YyXIbMDets5nS95TJ9/5E6UQAsCOsu5wrqlNtzFOn4
	 87u2WG5rbsl6QoZN/i7zWQ/dMEO1XRGkcd5vjB8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/309] Bluetooth: btusb: clamp SCO altsetting table indices
Date: Tue, 31 Mar 2026 18:20:27 +0200
Message-ID: <20260331161758.045417716@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 129fa608b6ad08b8ab7178eeb2ec272c993aaccc ]

btusb_work() maps the number of active SCO links to USB alternate
settings through a three-entry lookup table when CVSD traffic uses
transparent voice settings. The lookup currently indexes alts[] with
data->sco_num - 1 without first constraining sco_num to the number of
available table entries.

While the table only defines alternate settings for up to three SCO
links, data->sco_num comes from hci_conn_num() and is used directly.
Cap the lookup to the last table entry before indexing it so the
driver keeps selecting the highest supported alternate setting without
reading past alts[].

Fixes: baac6276c0a9 ("Bluetooth: btusb: handle mSBC audio over USB Endpoints")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 7c7955afa8e8a..40f0c3b4eee6c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2356,8 +2356,11 @@ static void btusb_work(struct work_struct *work)
 		if (data->air_mode == HCI_NOTIFY_ENABLE_SCO_CVSD) {
 			if (hdev->voice_setting & 0x0020) {
 				static const int alts[3] = { 2, 4, 5 };
+				unsigned int sco_idx;
 
-				new_alts = alts[data->sco_num - 1];
+				sco_idx = min_t(unsigned int, data->sco_num - 1,
+						ARRAY_SIZE(alts) - 1);
+				new_alts = alts[sco_idx];
 			} else {
 				new_alts = data->sco_num;
 			}
-- 
2.51.0



