Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98E51B4F0D;
	Mon, 14 Oct 2024 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917299; cv=none; b=MUa7g3e5XXpaPK4ZpuMINA/U93yMSqXJ4rA+u9q2W2GjcrxPp1/onIaQ1RGDK8UQFSUuHDq7TvMxMdmfo0mljoheCqHCjTjQ7AqE52gyACuxXVdQQs4jQ7MtgvNvHswrdSSeLOVOX64nuz59Jxc/w/W1d2LJ57EBXHp0V3hLwYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917299; c=relaxed/simple;
	bh=MMau0RerlKAiH5HNwtUQkoqnq/jAYS+9+g/Fy9U0jZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHLQJhKA/6N2ZV97QoHFPS2UmbXxDGb3hrIU3jlUfHvaCWT/1hQceCnoZej1aJmCOJaa1vyW626t7ijrvhBaIjxugDmaqaQyYeBE1C5Dqyr/mBXaRU9bEndx5gNUO8I5GCWz1n3VWL9NB+fI5gy/yuKv1/5oCrcrsV0KMSxBviY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALqWYeiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALqWYeiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17248C4CECF;
	Mon, 14 Oct 2024 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917299;
	bh=MMau0RerlKAiH5HNwtUQkoqnq/jAYS+9+g/Fy9U0jZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALqWYeiqhRKW+9TFZxzQolW9Rws/H2PIht3O4p8mbHxFQ45OC+V8vLK/l0SKY63ez
	 bGb5I3x+4QBO5a48R/mvIlDUZGSjq+w4NXugkHFti13MtwBtEZtzzs6zpLLbsl/KDq
	 uww3C6vDm5+wDST5Beq7hjzfUKYL3NHBNlWfLANs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Hixon <linux-kernel-bugs@hixontech.com>,
	Richard <hobbes1069@gmail.com>,
	Skyler <skpu@pm.me>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 179/213] HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()
Date: Mon, 14 Oct 2024 16:21:25 +0200
Message-ID: <20241014141049.953235948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
@@ -236,9 +236,9 @@ int amd_sfh_hid_client_init(struct amd_m
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
@@ -331,7 +331,6 @@ cleanup:
 int amd_sfh_hid_client_deinit(struct amd_mp2_dev *privdata)
 {
 	struct amdtp_cl_data *cl_data = privdata->cl_data;
-	struct amd_input_data *in_data = cl_data->in_data;
 	int i, status;
 
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
@@ -351,12 +350,5 @@ int amd_sfh_hid_client_deinit(struct amd
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


