Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3F684DF8;
	Wed,  7 Aug 2024 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042991; cv=none; b=D4oOB1WiEBRao58jZeIagIx9V/lEU31pOIYnZ/BB+rmy6XA1FtC7k55M59uDQbXZCpOawfcVHCb1y/Kt8CfIC1ag9HrqBLsRVUnHCUVWVPwTL7t5rIrjQ0xxm6lnWLXXg7eRovpAom5mnzjyYwCXch+uCfoAyIs9RRt5TlJD3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042991; c=relaxed/simple;
	bh=2TDuwAuZ9v2ieMit6fwpwUaHrdwFdQRb/4l2r9KEQ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl+Rr3rC6ZaaWyPdFBOpcYp/IiXiEH5RDO5Uf4qbOtQMJe3k+3X1k09YJnc5pq5F/k0dBlcLlX2nFC0Q+WrwtR3tbiFn/mz+jeWMFm7VzaQpDkvyuFj46+mguLr45cc1ar72nb9fWrGx1BzfC9i/oSo9NHYHEauF21LbY9LoZG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBJXu+7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBJXu+7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691ECC32781;
	Wed,  7 Aug 2024 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042991;
	bh=2TDuwAuZ9v2ieMit6fwpwUaHrdwFdQRb/4l2r9KEQ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBJXu+7Fmgqml7hDFT6sePfcFS3aJjEyTcJHTSYwQrKKqYkIM7zbAVRs0Wcd9yjKw
	 t0H0LFWgIs1GRZ6llQ0BkbKlXg8zKLbNT7fyQP++I64iyrr3oy76LPNZ9RaTi4VB3U
	 pK+nqpi3mHXlDDlAGqCR2S4tj/RjlmPVk1w36ezs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 033/123] Bluetooth: btintel: Fail setup on error
Date: Wed,  7 Aug 2024 16:59:12 +0200
Message-ID: <20240807150021.899008624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ecc67deecb09..93900c37349c1 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3012,6 +3012,9 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		btintel_set_dsm_reset_method(hdev, &ver_tlv);
 
 		err = btintel_bootloader_setup_tlv(hdev, &ver_tlv);
+		if (err)
+			goto exit_error;
+
 		btintel_register_devcoredump_support(hdev);
 		btintel_print_fseq_info(hdev);
 		break;
-- 
2.43.0



