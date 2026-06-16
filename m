Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECE735AC1E;
	Tue, 16 Jun 2026 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626669; cv=none; b=F0sEHGhDZMR9iqiDJt4Jiw6fG6c7e/T5onDiPTF25BgKdqQ9kCDkxuEET6VlU7a5qExVVnJmRgyRnYA8uDRgQU1gOzNwNEY43X5HvSok1mWId3RgZb6aEyAG7f09zIp9hhahiApa8d3pIx6rAFsLJihZdp/SxhzleezcYlruxI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626669; c=relaxed/simple;
	bh=nT9Le7MOltg7oeczEo743A28dPJ7tc6XpqHGaRx7MY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mug1eytT1qDJhnL3HdzDtksstv7HLu94exEUU/Hcy5f3B1iyCRhdmWzVVypROaXxlvv3kcqAVVngm6AalsDuLM7mK1Jy9aejdc2nBEzleOJc0LJHsuxq8l9kTo8qinhnoVdiCRn7GHX46mZ8H/hQbtc3by63Bf7/QVHfeSh9Y3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbeWwwEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbeWwwEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697C81F000E9;
	Tue, 16 Jun 2026 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626668;
	bh=n+9hi/ryjb6bjNo6beOZHsQrUXMbP1GrOHPYenOCqJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zbeWwwEjXUQH+14B/jFA85YgNYJH9KIqykP3mNhSv1YHvU4kVNWAIbUgWy4W+33Uv
	 nr3rsTNkxuS39+4EG75mcrZ25SWfOMLXne6R8tOq5HvLfWsftfF7c6lueuav4rOIDc
	 5d0j2pJteX83Xt1H6ESY3JiYSSmQ+XkXtPXwMGHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/261] Bluetooth: MGMT: Fix backward compatibility with userspace
Date: Tue, 16 Jun 2026 20:28:04 +0530
Message-ID: <20260616145047.307286390@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 149324fc762c2a7acef9c26790566f81f475e51f ]

bluetoothd has a bug with makes it send extra bytes as part of
MGMT_OP_ADD_EXT_ADV_DATA which are now being checked to be the
exact the expected length, relax this so only when the expected
length is greater than the data length to cause an error since
that would result in accessing invalid memory, otherwise just
ignore the extra bytes.

Link: https://lore.kernel.org/linux-bluetooth/20260602204749.210857-1-luiz.dentz@gmail.com/T/#u
Fixes: d3f7d17960ed ("Bluetooth: MGMT: validate Add Extended Advertising Data length")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 040a5595f45fee..f494eda5cc81c1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9197,8 +9197,9 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	BT_DBG("%s", hdev->name);
 
-	expected_len = struct_size(cp, data, cp->adv_data_len + cp->scan_rsp_len);
-	if (expected_len != data_len)
+	expected_len = struct_size(cp, data, cp->adv_data_len +
+				   cp->scan_rsp_len);
+	if (expected_len > data_len)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_DATA,
 				       MGMT_STATUS_INVALID_PARAMS);
 
-- 
2.53.0



