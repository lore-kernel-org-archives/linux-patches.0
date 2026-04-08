Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83023D9DB9;
	Wed,  8 Apr 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672545; cv=none; b=XquAF5EZXlEG1dhITzdKsogN7iD7zPbQk1SNo+OkY/xxQJlriYY9tVCHGZUSGPr5IvyG/qAbt5B2xpwFEY9MdlIYmEokDavabwedftu3LOL2IeSfrTpEBgSVmK0ShIeOYVPr9BjrtG328o5Nc+PvBn9/5zgIUnuhUanSfVY0Hzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672545; c=relaxed/simple;
	bh=7HYjXKHPHrm5GBiAMC7i+QsYk6txo0JQsa5CcvgTjII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVf63WmExpssMMdhiK7Y9M24kJzbSyhVVmU+SsLNOGSvz9xviFNTRctr3wlStSfiYu2ylro+8v1uPx30q+7a84JZpy6zS/WhA0Qvw0GR34fHd3hns8x037uiofvSGxRevdvm8SIpcrc3GWnQaK/e58Sx/N2TVXGIqjE8Ts3E8z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/JLnGXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/JLnGXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEA3C19421;
	Wed,  8 Apr 2026 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672545;
	bh=7HYjXKHPHrm5GBiAMC7i+QsYk6txo0JQsa5CcvgTjII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/JLnGXfPZQFTP19WHXn7kh9bnDIICJsomLKX7C6DHo3gS220d1FH+qGddMhy9jcp
	 vQBb5X654gJJ25X2PIL7bZvhNTJZSiOsgaIpCb5REinh1smdntdkHHrex9qpV+dsoW
	 h9lRLwlNn5fn+pqSiaHoGaB2xHlh/6LQWNWupN0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/160] Bluetooth: MGMT: validate LTK enc_size on load
Date: Wed,  8 Apr 2026 20:02:15 +0200
Message-ID: <20260408175915.002099352@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit b8dbe9648d69059cfe3a28917bfbf7e61efd7f15 ]

Load Long Term Keys stores the user-provided enc_size and later uses
it to size fixed-size stack operations when replying to LE LTK
requests. An enc_size larger than the 16-byte key buffer can therefore
overflow the reply stack buffer.

Reject oversized enc_size values while validating the management LTK
record so invalid keys never reach the stored key state.

Fixes: 346af67b8d11 ("Bluetooth: Add MGMT handlers for dealing with SMP LTK's")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 7de0a0d752629..81651f8ed03d0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7145,6 +7145,9 @@ static bool ltk_is_valid(struct mgmt_ltk_info *key)
 	if (key->initiator != 0x00 && key->initiator != 0x01)
 		return false;
 
+	if (key->enc_size > sizeof(key->val))
+		return false;
+
 	switch (key->addr.type) {
 	case BDADDR_LE_PUBLIC:
 		return true;
-- 
2.53.0



