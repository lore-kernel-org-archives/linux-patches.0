Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99251AA7AB;
	Mon, 14 Oct 2024 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920127; cv=none; b=gPJ0hEMvSI4cg6xMwa1HPWkzTILMXLXpJ5qJedLqNIWY6cONd9VvuMT4E9w4g5I6YiwwOdXZPmtworV551BjMGqvrN8JFow6t45VBgWqm9+0nxDug9ubl9QXrSVYwhSkrU+hJTPpT9gZhHzko54z5QWBhTa04POQBep+ZuPCkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920127; c=relaxed/simple;
	bh=TT1SEeSCzQRbyngIByTipQed8LphaODu6YA5G8jYzig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lphbdrYIiSt2xOFk4Y6WGSv5iVyG9Kwvrg3z5+cBS0NNCdmoKfLtCSEbN78b+uBaOXz450qNMsUmWWw1Xk3gDLf0vJAJIx+/1eJlrQdNf+HWCAcrOsZpg/phDT6NTq1FczxLep4n+pwW5AXoPQOq8j87TqlXHH2DSlyQCeycx/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNPvqaho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNPvqaho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30853C4CECF;
	Mon, 14 Oct 2024 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920127;
	bh=TT1SEeSCzQRbyngIByTipQed8LphaODu6YA5G8jYzig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNPvqahokRjfKW5+c1ajP2CX/9FtSehbX4yJ2C2GG47xJac20+UAGG/JFXxa9JcBK
	 eHQJOS4Pxh+eMB5s09I3E4qY1xgsX1jrhtXNzcXktXglcLF3D1DDZVfgqqNmDEH78L
	 UIKlz5OpCuMC8XQp7JR4fcXFkb5Z0PyGyzzX2fkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Hixon <linux-kernel-bugs@hixontech.com>,
	Richard <hobbes1069@gmail.com>,
	Skyler <skpu@pm.me>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 773/798] HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()
Date: Mon, 14 Oct 2024 16:22:07 +0200
Message-ID: <20241014141248.431306139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit c56f9ecb7fb6a3a90079c19eb4c8daf3bbf514b3 upstream.

Using the device-managed version allows to simplify clean-up in probe()
error path.

Additionally, this device-managed ensures proper cleanup, which helps to
resolve memory errors, page faults, btrfs going read-only, and btrfs
disk corruption.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Tested-by: Chris Hixon <linux-kernel-bugs@hixontech.com>
Tested-by: Richard <hobbes1069@gmail.com>
Tested-by: Skyler <skpu@pm.me>
Reported-by: Chris Hixon <linux-kernel-bugs@hixontech.com>
Closes: https://lore.kernel.org/all/3b129b1f-8636-456a-80b4-0f6cce0eef63@hixontech.com/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219331
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -235,9 +235,9 @@ int amd_sfh_hid_client_init(struct amd_m
 	cl_data->in_data = in_data;
 
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
-		in_data->sensor_virt_addr[i] = dma_alloc_coherent(dev, sizeof(int) * 8,
-								  &cl_data->sensor_dma_addr[i],
-								  GFP_KERNEL);
+		in_data->sensor_virt_addr[i] = dmam_alloc_coherent(dev, sizeof(int) * 8,
+								   &cl_data->sensor_dma_addr[i],
+								   GFP_KERNEL);
 		if (!in_data->sensor_virt_addr[i]) {
 			rc = -ENOMEM;
 			goto cleanup;
@@ -334,7 +334,6 @@ cleanup:
 int amd_sfh_hid_client_deinit(struct amd_mp2_dev *privdata)
 {
 	struct amdtp_cl_data *cl_data = privdata->cl_data;
-	struct amd_input_data *in_data = cl_data->in_data;
 	int i, status;
 
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
@@ -354,12 +353,5 @@ int amd_sfh_hid_client_deinit(struct amd
 	cancel_delayed_work_sync(&cl_data->work_buffer);
 	amdtp_hid_remove(cl_data);
 
-	for (i = 0; i < cl_data->num_hid_devices; i++) {
-		if (in_data->sensor_virt_addr[i]) {
-			dma_free_coherent(&privdata->pdev->dev, 8 * sizeof(int),
-					  in_data->sensor_virt_addr[i],
-					  cl_data->sensor_dma_addr[i]);
-		}
-	}
 	return 0;
 }


