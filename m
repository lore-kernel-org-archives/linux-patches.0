Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B054BFE;
	Tue, 27 Feb 2024 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044253; cv=none; b=HGEH0S13OaEy+ONmHDqA0/iKfu5M3pR9nU9XJ9fI8WDBTu8qBIYZ55gmkoVx4TQEphOb9M6mz3LqS3cneG39TlNpvOb+KUyj42NGzwgJURCiPV5W2lH9kdC6+jPt5LN08fLKOeF0NFj67zvMzuyCPMJjwgnF9f4VButtihmdv88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044253; c=relaxed/simple;
	bh=r9U5p3Cxy/g3OkoBC7ZA6xOEu74ul0MVBsuR+8VZuUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRK1KIift2RVPWOWHRfzqSMBtNfNBGLELyVW9uZ7bY9PvaXEtmu1rhTgcmCDNmRndgD/8V/AELCaGK9jfYmgbnAz4V2ITufEZk77A4QpXUQS6XBjG0klXd/ccMyx8KOrFrXcqvx7UVsxmwVCQF3TwUTj3Uz68rCbV0O2H+FdJ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXqxRkYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXqxRkYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC123C433F1;
	Tue, 27 Feb 2024 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044253;
	bh=r9U5p3Cxy/g3OkoBC7ZA6xOEu74ul0MVBsuR+8VZuUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXqxRkYKe0dpM5nvXPFaE+2h4wQkq0SZ1wMdV8g5FJ2S+qRZLnO1HVLqlys/61Zs6
	 RwqLQo5QGjizi4V54akvkRdftH63OIi2mvXQVuVQtYewlxcSkKO1QA8LqpstbcjJQH
	 Z8uvnLTlYMum/xvWeD1ybYYKIsQdjgJ8wiFBfQbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/122] drm/amd/display: Fix memory leak in dm_sw_fini()
Date: Tue, 27 Feb 2024 14:27:59 +0100
Message-ID: <20240227131602.562736053@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit bae67893578d608e35691dcdfa90c4957debf1d3 ]

After destroying dmub_srv, the memory associated with it is
not freed, causing a memory leak:

unreferenced object 0xffff896302b45800 (size 1024):
  comm "(udev-worker)", pid 222, jiffies 4294894636
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 6265fd77):
    [<ffffffff993495ed>] kmalloc_trace+0x29d/0x340
    [<ffffffffc0ea4a94>] dm_dmub_sw_init+0xb4/0x450 [amdgpu]
    [<ffffffffc0ea4e55>] dm_sw_init+0x15/0x2b0 [amdgpu]
    [<ffffffffc0ba8557>] amdgpu_device_init+0x1417/0x24e0 [amdgpu]
    [<ffffffffc0bab285>] amdgpu_driver_load_kms+0x15/0x190 [amdgpu]
    [<ffffffffc0ba09c7>] amdgpu_pci_probe+0x187/0x4e0 [amdgpu]
    [<ffffffff9968fd1e>] local_pci_probe+0x3e/0x90
    [<ffffffff996918a3>] pci_device_probe+0xc3/0x230
    [<ffffffff99805872>] really_probe+0xe2/0x480
    [<ffffffff99805c98>] __driver_probe_device+0x78/0x160
    [<ffffffff99805daf>] driver_probe_device+0x1f/0x90
    [<ffffffff9980601e>] __driver_attach+0xce/0x1c0
    [<ffffffff99803170>] bus_for_each_dev+0x70/0xc0
    [<ffffffff99804822>] bus_add_driver+0x112/0x210
    [<ffffffff99807245>] driver_register+0x55/0x100
    [<ffffffff990012d1>] do_one_initcall+0x41/0x300

Fix this by freeing dmub_srv after destroying it.

Fixes: 743b9786b14a ("drm/amd/display: Hook up the DMUB service in DM")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 54d6b4128721e..3578e3b3536e3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1456,6 +1456,7 @@ static int dm_sw_fini(void *handle)
 
 	if (adev->dm.dmub_srv) {
 		dmub_srv_destroy(adev->dm.dmub_srv);
+		kfree(adev->dm.dmub_srv);
 		adev->dm.dmub_srv = NULL;
 	}
 
-- 
2.43.0



