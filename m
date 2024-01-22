Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB22513DB90;
	Tue, 23 Jan 2024 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969140; cv=none; b=GdznsEFjVHgKKwVrI+fgW9MF4B/2qnUfEa93FDUInzTIHZd67iOY9fCYnEe1Kg6Bz/3xRVikc1YduxkSrJAlgkHyPMfVIxA+zzhmpml2aTZiRX0p7O6zrFvLyI3fKHIOuJzhOZmaqBIroKcM0mKQ6WwuW9SItWxxaoSdCWiHx4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969140; c=relaxed/simple;
	bh=cQYfjEp9X5nDhiSPnLJKDJdIRJMA7rE2vsR1MqBBkjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz9RT02RYEr8mNfMi3DE1kxPuuWEs4wXhZdwj0MZXhK46V5JqKhgwTJ9a9I7w43BHlO/4sYhHquU0/p3jy1+ljLgkFSObxsy/nmG5AX2rfEYZtD5f4TFW2d8Tfg8eWi84HwMkiBQ/j6/eZkr5gadmMfe/n+qPMA8bV099yWB7QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnMvPvuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnMvPvuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9068CC433F1;
	Tue, 23 Jan 2024 00:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969140;
	bh=cQYfjEp9X5nDhiSPnLJKDJdIRJMA7rE2vsR1MqBBkjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnMvPvuGOc13Pf2MwdlZoGDHbCeA4uO/c+lcyDYJDnDHQHAGXYTpQYxtCsGeHo9/e
	 864qMxBeos9q4x1w8WnJesjkDUH59lE1k3EQEBDWB+OR5/y3PmotePE9D6US2xv5gW
	 cm+1vhpPhj2lR0iLsp2EME+oBjc+cTojrjxDBdAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 047/641] crypto: qat - add sysfs_added flag for ras
Date: Mon, 22 Jan 2024 15:49:11 -0800
Message-ID: <20240122235819.554293140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit 65089000ba8c2ae713ccac6603319143f3e1c08b ]

The qat_ras sysfs attribute group is registered within the
adf_dev_start() function, alongside other driver components.
If any of the functions preceding the group registration fails,
the adf_dev_start() function returns, and the caller, to undo the
operation, invokes adf_dev_stop() followed by adf_dev_shutdown().
However, the current flow lacks information about whether the
registration of the qat_ras attribute group was successful or not.

In cases where this condition is encountered, an error similar to
the following might be reported:

    4xxx 0000:6b:00.0: Starting device qat_dev0
    4xxx 0000:6b:00.0: qat_dev0 started 9 acceleration engines
    4xxx 0000:6b:00.0: Failed to send init message
    4xxx 0000:6b:00.0: Failed to start device qat_dev0
    sysfs group 'qat_ras' not found for kobject '0000:6b:00.0'
    ...
    sysfs_remove_groups+0x29/0x50
    adf_sysfs_stop_ras+0x4b/0x80 [intel_qat]
    adf_dev_stop+0x43/0x1d0 [intel_qat]
    adf_dev_down+0x4b/0x150 [intel_qat]
    ...
    4xxx 0000:6b:00.0: qat_dev0 stopped 9 acceleration engines
    4xxx 0000:6b:00.0: Resetting device qat_dev0

To prevent attempting to remove attributes from a group that has not
been added yet, a flag named 'sysfs_added' is introduced. This flag
is set to true upon the successful registration of the attribute group.

Fixes: 532d7f6bc458 ("crypto: qat - add error counters")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h    | 1 +
 .../crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 4ff5729a3496..9d5fdd529a2e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -92,6 +92,7 @@ enum ras_errors {
 
 struct adf_error_counters {
 	atomic_t counter[ADF_RAS_ERRORS];
+	bool sysfs_added;
 	bool enabled;
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index cffe2d722995..e97c67c87b3c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -99,6 +99,8 @@ void adf_sysfs_start_ras(struct adf_accel_dev *accel_dev)
 	if (device_add_group(&GET_DEV(accel_dev), &qat_ras_group))
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to create qat_ras attribute group.\n");
+
+	accel_dev->ras_errors.sysfs_added = true;
 }
 
 void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev)
@@ -106,7 +108,10 @@ void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->ras_errors.enabled)
 		return;
 
-	device_remove_group(&GET_DEV(accel_dev), &qat_ras_group);
+	if (accel_dev->ras_errors.sysfs_added) {
+		device_remove_group(&GET_DEV(accel_dev), &qat_ras_group);
+		accel_dev->ras_errors.sysfs_added = false;
+	}
 
 	ADF_RAS_ERR_CTR_CLEAR(accel_dev->ras_errors);
 }
-- 
2.43.0



