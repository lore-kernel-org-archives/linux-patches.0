Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAD944B69C;
	Tue, 16 Jun 2026 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625137; cv=none; b=nznxt60tv7nNnPe5QqmfmUmeDo6C3e5MlZmmw+Oh9TKrjb0aDtmljZFq40OSnbDZY1/hV+Sc26XglVocHPW9rSeL3l5MkI/vzwQduPALsWT9120i9o7qnIqLsZbEFfPFj3ABPZc3Oe9COmy1tLjv1JWrd4zCLa4AaXyH35/S3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625137; c=relaxed/simple;
	bh=iOnPlHlpvxlt0cKjZPaLRzpQf3MUE3d9TPkPKu5ru0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdZXUekFH3dEWSa2uVX7NF8XB1q2iUk3C91tOfMbUFHtTS/gIke90LfcU1BHJswlUDn04mWJwPZT16LnE7oUYqljYmyhDtCQV93ag7BtSRHWIT9keJh0tnZFHhQOGSLtgcJ5fchAv+dlg4HaoAJ9yEQI758V7nWrrfKk/NJmD60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOOtX5Ng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOOtX5Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53CF1F000E9;
	Tue, 16 Jun 2026 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625136;
	bh=p2vVQXt7ze19mo0uBlJ1T76zUGGt9I4Gd/nOn110gK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOOtX5Ngnz2ZUSgFCBNGuqyQVMZdsBcBZNx8iAZQLpnJvRgcwRtOx+Lsh03rFj79W
	 kJVXroKTl3bUU7sE+rSgfTiaG18OilnhEsgspmWS/mnFkqeKtb5lJ2UcMqui/ACEet
	 RnrNRKMM/DRtk03ylCruTjFxXq6DbffHFkNZFpK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/325] Bluetooth: MGMT: Fix backward compatibility with userspace
Date: Tue, 16 Jun 2026 20:27:27 +0530
Message-ID: <20260616145100.255951651@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 9bb82d1fdc3cad..c87ec0138c430b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9098,8 +9098,9 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
 
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



