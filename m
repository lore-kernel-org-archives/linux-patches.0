Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAD91DE8A0;
	Thu, 17 Apr 2025 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912671; cv=none; b=u62Xhhzt5vj5H3eYEr726uYDxyV9p0xrJqb2LbUsEd7Y5VdN2tCWKv/Z8yF103KlNa3kzVSBdBlz3C6D6tJNc/mJIs8cmpSg8zWi/YB0FQ7eYKtsUH971haLlZAkJHdfBLVvPaIAKUUjZpky2a6JlXKqz2tbCHfNA4nE6bgxDWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912671; c=relaxed/simple;
	bh=zujhO72MvwZ1cKGIJmE/0XOf0Lf271HdCp0B3JhHXWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1kHe0IyRTyVQ7xp2RqS1ZVpuLNvMzXL/47B87XgRaGCPPUtAcjVumK4u0zmeZsxOnjzS7AtkdjZ+DBiNWFitNDDL0obParNzxh4Nx2EES55fcXXsSPaf4b/51YmUjMMOVvq9aPJ5qkE/2a2slDL6ag4Ocs821z6fBaxwdJMFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/Oa4+KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/Oa4+KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DEAC4CEE4;
	Thu, 17 Apr 2025 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912671;
	bh=zujhO72MvwZ1cKGIJmE/0XOf0Lf271HdCp0B3JhHXWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/Oa4+KLQW4CsSFWcgn+IeQc03LwAvHT7hn9JqdIAx9wM5ZZa0ULyAEOR0nYpKV9q
	 gZzLJgfAwn9qIzPME7E0MxhrBezelTjNPXmj5w8Ez7ZqkGQfRNXsMmPFBvG4KWXLYE
	 wXWDiXwPPA97HPPAvv3fCpap16BAE84LhDg5eooQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Sankar <vishnuocv@gmail.com>,
	Vishnu Sankar <vsankar@lenovo.com>,
	kernel test robot <lkp@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 086/449] HID: lenovo: Fix to ensure the data as __le32 instead of u32
Date: Thu, 17 Apr 2025 19:46:14 +0200
Message-ID: <20250417175121.433673981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Sankar <vishnuocv@gmail.com>

[ Upstream commit d6ea85f8371b99c1d3a90ee4e2fb1a648f8d71d3 ]

Ensure that data is treated as __le32 instead of u32 before
applying le32_to_cpu.
This patch fixes the sparse warning "sparse: cast to restricted __le32".

Signed-off-by: Vishnu Sankar <vishnuocv@gmail.com>
Signed-off-by: Vishnu Sankar <vsankar@lenovo.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501101635.qJrwAOwf-lkp@intel.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index a7d9ca02779ea..04508c36bdc82 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -778,7 +778,7 @@ static int lenovo_raw_event(struct hid_device *hdev,
 	if (unlikely((hdev->product == USB_DEVICE_ID_LENOVO_X12_TAB
 			|| hdev->product == USB_DEVICE_ID_LENOVO_X12_TAB2)
 			&& size >= 3 && report->id == 0x03))
-		return lenovo_raw_event_TP_X12_tab(hdev, le32_to_cpu(*(u32 *)data));
+		return lenovo_raw_event_TP_X12_tab(hdev, le32_to_cpu(*(__le32 *)data));
 
 	return 0;
 }
-- 
2.39.5



