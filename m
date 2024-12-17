Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9C91F6661;
	Tue, 17 Dec 2024 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456531; cv=none; b=KELtZLAlR08RVNt9C6f+cBNk5C9uNfFqhELUbG1tg845Zjfn2KmaBK3GxbQoa3xITyGss8tMrDTeaHdoeK2Y8he6jyrutOfVWpT5SpEd3PsRYQyT2gUfAf+69O+lP8s8Bo8iC30bcKQKXk/1YI1chU9+bRL9zgjWICdQ61bHJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456531; c=relaxed/simple;
	bh=0gq/DyNNNrCDCY5XgPoh91ciXPl72xpiQpc1zZB/q/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjNR6/15bwzaoXIcCCeN3EzrLTudaSNMwAE3Sf1kMcycuXbmTCkOsgWFhY5mL1d3n4MoCmT1iAucH2YMync93rij8u4fWUeyggYbWtwWEiIkdlMDTrkCkVeZEAQEdpcSV/Khbiw5yFmXUHgm9mREBdJ8aiNC1JA6FFyJlq7kB7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMk97waP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMk97waP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68581C4CED3;
	Tue, 17 Dec 2024 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456531;
	bh=0gq/DyNNNrCDCY5XgPoh91ciXPl72xpiQpc1zZB/q/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMk97waPEMnXGMpobElfaIbxJ3XOLcFWnuuSiYOsc+PB8wS9b2lVKQ9ucESf2TOuQ
	 emQbh8F3Jy7wZHqg6BsLbaVoNBPyW2z26vEf5BTbTehxxVYGy+SVqUlXnOY44+JhRE
	 BDujlDk/bGBJAUCM4hBF01xFgFWV62garZ2Ss9j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/172] acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl
Date: Tue, 17 Dec 2024 18:07:24 +0100
Message-ID: <20241217170549.938883051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Sonawane <surajsonawane0215@gmail.com>

[ Upstream commit 265e98f72bac6c41a4492d3e30a8e5fd22fe0779 ]

Fix an issue detected by syzbot with KASAN:

BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/
core.c:416 [inline]
BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0
drivers/acpi/nfit/core.c:459

The issue occurs in cmd_to_func when the call_pkg->nd_reserved2
array is accessed without verifying that call_pkg points to a buffer
that is appropriately sized as a struct nd_cmd_pkg. This can lead
to out-of-bounds access and undefined behavior if the buffer does not
have sufficient space.

To address this, a check was added in acpi_nfit_ctl() to ensure that
buf is not NULL and that buf_len is less than sizeof(*call_pkg)
before accessing it. This ensures safe access to the members of
call_pkg, including the nd_reserved2 array.

Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Fixes: ebe9f6f19d80 ("acpi/nfit: Fix bus command validation")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20241118162609.29063-1-surajsonawane0215@gmail.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5429ec9ef06f..a5d47819b3a4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -454,8 +454,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	if (cmd_rc)
 		*cmd_rc = -EINVAL;
 
-	if (cmd == ND_CMD_CALL)
+	if (cmd == ND_CMD_CALL) {
+		if (!buf || buf_len < sizeof(*call_pkg))
+			return -EINVAL;
+
 		call_pkg = buf;
+	}
+
 	func = cmd_to_func(nfit_mem, cmd, call_pkg, &family);
 	if (func < 0)
 		return func;
-- 
2.39.5



