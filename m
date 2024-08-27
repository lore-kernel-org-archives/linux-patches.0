Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6D1C5781;
	Tue, 27 Aug 2024 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770057; cv=none; b=WWZBfmUKklDXD6Sx13tRQDw8Q1VMVRCqr5TtvShu/I4cQjxIATOXdW5WFSCCp1Nn5zpIqmdIfAk6TrL/Ig9qrYw3RtPp7jJnafu1HfJyM4y6oEX4DBJzgIOhaWqPqAizEEG0cm74ZRBjQsSPDc6wSAKTt2gVM978fSOtl4x8cVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770057; c=relaxed/simple;
	bh=LkXlyQg+zBMcDb6P4TrTyygQIC9vo6bETtFextKFLZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgdwjvxNgTOAgWkR+p642oGRL9fyu8urzaH9F8/HKkUqCPYM76D0me51YHBFS1Lem40Ch/9EljfwrG0OYY6u1tswps0wQD0r/ewsNmAlvXIz67/AFYgIlsIW2g6scXiYuf8HIqBcUn40Q2TJxppkDuQ1mSTUAc/DOBURjOoc2dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc8TtELz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc8TtELz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D78EC61040;
	Tue, 27 Aug 2024 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770056;
	bh=LkXlyQg+zBMcDb6P4TrTyygQIC9vo6bETtFextKFLZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc8TtELz8LV8XxTDyXYfwOC9LxOX5bpQLHmSsUtTXGnMaDmY2vbQc4ayrDJSzIuPs
	 d2ZKJvk0YEz+3deZKQQSnJV5lTKPtoucK0zmRLL+WhZ66yaV6qrCbiqL5zVxH/2r12
	 x6nDCq/gaGjjMBYPEl+zPN2f471iLc8Et3ScUmRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jithu Joseph <jithu.joseph@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/341] platform/x86/intel/ifs: Validate image size
Date: Tue, 27 Aug 2024 16:35:44 +0200
Message-ID: <20240827143847.712310528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

[ Upstream commit 25a76dbb36dd58ad4df7f6a4dc43061a10b0d817 ]

Perform additional validation prior to loading IFS image.

Error out if the size of the file being loaded doesn't match the size
specified in the header.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/20231005195137.3117166-6-jithu.joseph@intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/load.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index cefd0d886cfd4..ae52de138a6ea 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -260,6 +260,7 @@ int ifs_load_firmware(struct device *dev)
 {
 	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
 	struct ifs_data *ifsd = ifs_get_data(dev);
+	unsigned int expected_size;
 	const struct firmware *fw;
 	char scan_path[64];
 	int ret = -EINVAL;
@@ -274,6 +275,13 @@ int ifs_load_firmware(struct device *dev)
 		goto done;
 	}
 
+	expected_size = ((struct microcode_header_intel *)fw->data)->totalsize;
+	if (fw->size != expected_size) {
+		dev_err(dev, "File size mismatch (expected %u, actual %zu). Corrupted IFS image.\n",
+			expected_size, fw->size);
+		return -EINVAL;
+	}
+
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
 	if (ret)
 		goto release;
-- 
2.43.0



