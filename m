Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C8199255;
	Thu,  6 Jun 2024 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682994; cv=none; b=gkrk9cpXQHDrKRmRImV3dVsDp0xIgt1acEaqhqeU8VeuY81CzURb7YoCpSZLuHGiU+q7BQ9QzN5dpOyCVATfJykC/vkZQStoBRWfRerC62YdzYtADg6N4e6/1Bsiil8ytHHwWdRgRoGasuweFnzlAYATfR3TGnWyf9i6aEYr6RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682994; c=relaxed/simple;
	bh=ZZGsl9QpkR6mN9ZS4c3uaDJZDGm09IrJIYplptqoEN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA4mXJQlJvhKvBsDyQkp57Lmj3xI71r5/QvsGsIBi6/L5eK/uFMna+S27YZEtssVr9ASFvi2hWlY1xLou4bMMAy8VuZGqEF9B8Pg8Ws9WDsN9g4KVu6qg8QQrTHUBIFMnm6UM/xWCpHUalxtVvK4nuHZkS9C3IDmMrXF3DWI9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JemI5Hyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JemI5Hyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C87EC32781;
	Thu,  6 Jun 2024 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682994;
	bh=ZZGsl9QpkR6mN9ZS4c3uaDJZDGm09IrJIYplptqoEN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JemI5HytznPC3wXXqmYQAuPrlzCS7fcLIVTrU5wzTLM3YUgJ9ZfOwc6goUa7ZHUJX
	 6MLZ76efAoxEd8KIihSk0lj+5ZoPaZray66fr897TetZ8G8wpJGrA3d9yRtXpcP4ux
	 KJPLKS402uZOqGmFqU3SVozlCa2v6m1QlOvkVr08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Herbert <marc.herbert@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 191/374] ASoC: SOF: debug: Handle cases when fw_lib_prefix is not set, NULL
Date: Thu,  6 Jun 2024 16:02:50 +0200
Message-ID: <20240606131658.265206089@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b32487ca7b51ce430f15ec785269f11c25a6a560 ]

The firmware libraries are not supported by IPC3, the fw_lib_path is not
a valid parameter and it is always NULL.
Do not create the debugfs file for IPC3 at all as it is not applicable.

With IPC4 some vendors/platforms might not support loadable libraries and
the fw_lib_prefix is left to NULL to indicate this.
Handle such case with allocating "Not supported" string.

Reviewed-by: Marc Herbert <marc.herbert@intel.com>
Fixes: 17f4041244e6 ("ASoC: SOF: debug: show firmware/topology prefix/names")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240426153902.39560-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index 7275437ea8d8a..6481da31826dc 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -345,8 +345,27 @@ int snd_sof_dbg_init(struct snd_sof_dev *sdev)
 
 	debugfs_create_str("fw_path", 0444, fw_profile,
 			   (char **)&plat_data->fw_filename_prefix);
-	debugfs_create_str("fw_lib_path", 0444, fw_profile,
-			   (char **)&plat_data->fw_lib_prefix);
+	/* library path is not valid for IPC3 */
+	if (plat_data->ipc_type != SOF_IPC_TYPE_3) {
+		/*
+		 * fw_lib_prefix can be NULL if the vendor/platform does not
+		 * support loadable libraries
+		 */
+		if (plat_data->fw_lib_prefix) {
+			debugfs_create_str("fw_lib_path", 0444, fw_profile,
+					   (char **)&plat_data->fw_lib_prefix);
+		} else {
+			static char *fw_lib_path;
+
+			fw_lib_path = devm_kasprintf(sdev->dev, GFP_KERNEL,
+						     "Not supported");
+			if (!fw_lib_path)
+				return -ENOMEM;
+
+			debugfs_create_str("fw_lib_path", 0444, fw_profile,
+					   (char **)&fw_lib_path);
+		}
+	}
 	debugfs_create_str("tplg_path", 0444, fw_profile,
 			   (char **)&plat_data->tplg_filename_prefix);
 	debugfs_create_str("fw_name", 0444, fw_profile,
-- 
2.43.0



