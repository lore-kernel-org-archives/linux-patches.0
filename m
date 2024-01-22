Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA5013DB90;
	Tue, 23 Jan 2024 00:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969142; cv=none; b=dv+FRAjLMeHLqiVi2hlp8o9w/vdSrGzbm50tVwelBf4YujnYEDVOckrhaGf6DoT0xRDL+cJwDtTK/8+EI9+BXDERZEZ8Tp/6q9wGzWJZjiQFRd3AEh92sg9ehAHRD4UmgvxQ0ZtqA0I5SosFct4z3xccAVKRQk0nK4mGxbJhMIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969142; c=relaxed/simple;
	bh=g2B45hr31h1B00t+38wkX9gHmStRpm5MrfK5hTi80kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC/tl2tQnwNLNpnsgPlheCXQiUlieoxlW+ecThneOfb5xwgjcrpSNxGGGb4Xq9H3kzc/I0PHu5l5uhN+7xtLuKCbWAz7rsG4NYxOCsJVl6dBCkLxFCnADWpeZcrcP0p5UG2ecVI4WvlTZKIZNQvVD4C7Sgvq4/l8OK54LzYSeU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxTkzf9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxTkzf9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBCEC433C7;
	Tue, 23 Jan 2024 00:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969141;
	bh=g2B45hr31h1B00t+38wkX9gHmStRpm5MrfK5hTi80kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxTkzf9U3K6jL64YtzdnkzZgJ1gpjPxfSS0y+9Ybbbd9Fps6VFOX8ZFWif3QnPxsf
	 S9fE8VqambVRLq81jjikzAbcCpsHabJXvyszhpiyrYAUaPpQDWwu4qR5+NySc1bMWS
	 7dk2A5naH59RQO7uY0y455Aggd8mbm01FFe+nGyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 048/641] crypto: qat - add sysfs_added flag for rate limiting
Date: Mon, 22 Jan 2024 15:49:12 -0800
Message-ID: <20240122235819.580974343@linuxfoundation.org>
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

[ Upstream commit d71fdd0f3c278c7f132c3a522645ebf9157edd6d ]

The qat_rl sysfs attribute group is registered within the adf_dev_start()
function, alongside other driver components.
If any of the functions preceding the group registration fails,
the adf_dev_start() function returns, and the caller, to undo the
operation, invokes adf_dev_stop() followed by adf_dev_shutdown().
However, the current flow lacks information about whether the
registration of the qat_rl attribute group was successful or not.

In cases where this condition is encountered, an error similar to
the following might be reported:

    4xxx 0000:6b:00.0: Starting device qat_dev0
    4xxx 0000:6b:00.0: qat_dev0 started 9 acceleration engines
    4xxx 0000:6b:00.0: Failed to send init message
    4xxx 0000:6b:00.0: Failed to start device qat_dev0
    sysfs group 'qat_rl' not found for kobject '0000:6b:00.0'
    ...
    sysfs_remove_groups+0x2d/0x50
    adf_sysfs_rl_rm+0x44/0x70 [intel_qat]
    adf_rl_stop+0x2d/0xb0 [intel_qat]
    adf_dev_stop+0x33/0x1d0 [intel_qat]
    adf_dev_down+0xf1/0x150 [intel_qat]
    ...
    4xxx 0000:6b:00.0: qat_dev0 stopped 9 acceleration engines
    4xxx 0000:6b:00.0: Resetting device qat_dev0

To prevent attempting to remove attributes from a group that has not
been added yet, a flag named 'sysfs_added' is introduced. This flag
is set to true upon the successful registration of the attribute group.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.h       | 1 +
 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index eb5a330f8543..269c6656fb90 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -79,6 +79,7 @@ struct adf_rl_interface_data {
 	struct adf_rl_sla_input_data input;
 	enum adf_base_services cap_rem_srv;
 	struct rw_semaphore lock;
+	bool sysfs_added;
 };
 
 struct adf_rl_hw_data {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index abf9c52474ec..bedb514d4e30 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -441,11 +441,19 @@ int adf_sysfs_rl_add(struct adf_accel_dev *accel_dev)
 
 	data->cap_rem_srv = ADF_SVC_NONE;
 	data->input.srv = ADF_SVC_NONE;
+	data->sysfs_added = true;
 
 	return ret;
 }
 
 void adf_sysfs_rl_rm(struct adf_accel_dev *accel_dev)
 {
+	struct adf_rl_interface_data *data;
+
+	data = &GET_RL_STRUCT(accel_dev);
+	if (!data->sysfs_added)
+		return;
+
 	device_remove_group(&GET_DEV(accel_dev), &qat_rl_group);
+	data->sysfs_added = false;
 }
-- 
2.43.0



