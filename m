Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4B627448;
	Wed,  7 Aug 2024 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043356; cv=none; b=fKtaTBptH31tHyrvzNtfWbut1nvOu5lnt+VpksM/Pbv5mrgd00llMdzdz6/cKM7J4FKpIFSVtTj8qtNdm/ZoZ0ZX+uqmzlrVOtVpihqKVEs+j9aZAh7oUHmQnE5KVS26yfupAoW33g6U39DKV9WeINFrcvZP78MG3+JQld1W4uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043356; c=relaxed/simple;
	bh=TeTI5aYTo7wL0U3l/Jsiv1CjnjTBMkgqasLYgotE1XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiIpQcXJwxndHSkWlTANInV9rm0AcSlWaDO8V6Kgk5/WwuzdTmIUvfo3HA3peRByA5CfCRWEhHc09e/QZ8PggdrNNW4oECGQaGXCwoWF2vpvFcnkDohVjhQ/xtYqOzLm38Lmb69HX4Tsr9YN/cy9lHxK8tH5Rd0f0R2zJtyN6a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lk8GNonC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lk8GNonC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB23C32781;
	Wed,  7 Aug 2024 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043356;
	bh=TeTI5aYTo7wL0U3l/Jsiv1CjnjTBMkgqasLYgotE1XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lk8GNonCn4TYIhTHAKL+PJQ9ef1ktiRl28g3ZLbafbpLNccczXNxR7zlKuByn1OrA
	 z1nhMmaDfLiDo6C+aooIkPpWPtRqxixyqxr5nYU/gdMr3YHeqC7DoJ6GzFR3gRZD6l
	 Ir06WcdcSQ0VkDM6wedhHFuRZmBCE5/LNvxYbX8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/121] Bluetooth: btintel: Fail setup on error
Date: Wed,  7 Aug 2024 16:59:53 +0200
Message-ID: <20240807150021.410720036@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit e22a3a9d4134d7e6351a2998771522e74bcc58da ]

Do not attempt to send any hci command to controller if *setup* function
fails.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 3da3c266a66f3..a936219aebb81 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2845,6 +2845,9 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		btintel_set_dsm_reset_method(hdev, &ver_tlv);
 
 		err = btintel_bootloader_setup_tlv(hdev, &ver_tlv);
+		if (err)
+			goto exit_error;
+
 		btintel_register_devcoredump_support(hdev);
 		break;
 	default:
-- 
2.43.0



