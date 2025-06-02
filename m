Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3181B1C5D72;
	Mon,  2 Jun 2025 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872723; cv=none; b=AuOn6ZTP0dOBAc3w6m9TvgWJYFmW0exPZ34ZOxwq/Ji6QS7eLQbeiplwGwY3StOdhDYxYZU3nuhXRC/ei/mC9rD8pniayjKuSlZv52L5/zFttRnSD28JLzLAmWgeDS+V3fICbtsXresnc+NZm31ezwIb+tNluspzyS0S7du7b50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872723; c=relaxed/simple;
	bh=l5x1nNk5tDAGTD4IwtAEXgaAEO5zc/cRc0WmWQwUsqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hutsRc+WEOKFM/0QOXHJWPvVKblp93WDOAZHDMK/Y1kNtpVW0kEZmhC1VqLz5Kjk9f/xsSU3/f5+l320Na/Vro+18mDZ27GewZdkPrQyLlbLHKohUv5CsIunS+qhcX5eJvA/OveU5WzcUCqNOFxCV2vUCx2GP1+vNnAt9lrgnBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cA6nHZlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cA6nHZlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DE2C4CEEB;
	Mon,  2 Jun 2025 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872723;
	bh=l5x1nNk5tDAGTD4IwtAEXgaAEO5zc/cRc0WmWQwUsqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA6nHZlgdcsx4W5EAtmH84zdiRi4TjPYwKskbAdjH2Mlgey8PM8kxIjEK44sNbY2I
	 fmibKW3OVVAwBoqz+Ht/oaK29hoeO+gZV2CVMmei/7yEaQjj+V+wsP0ymu8M3STsr1
	 5Zsn3j9PBsuAtmIIBdjkXJTo/XK0yJwgRrZgQ8HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 49/73] HID: amd_sfh: Avoid clearing reports for SRA sensor
Date: Mon,  2 Jun 2025 15:47:35 +0200
Message-ID: <20250602134243.631852858@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit f32e8c8095490152b5bc5f467d5034387a4bbd1b ]

SRA sensor doesn't allocate any memory for reports.  Skip
trying to clear memory for that sensor in cleanup path.

Suggested-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index a02969fd50686..08acc707938d3 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -83,6 +83,9 @@ static int amd_sfh_hid_client_deinit(struct amd_mp2_dev *privdata)
 		case ALS_IDX:
 			privdata->dev_en.is_als_present = false;
 			break;
+		case SRA_IDX:
+			privdata->dev_en.is_sra_present = false;
+			break;
 		}
 
 		if (cl_data->sensor_sts[i] == SENSOR_ENABLED) {
@@ -235,6 +238,8 @@ static int amd_sfh1_1_hid_client_init(struct amd_mp2_dev *privdata)
 cleanup:
 	amd_sfh_hid_client_deinit(privdata);
 	for (i = 0; i < cl_data->num_hid_devices; i++) {
+		if (cl_data->sensor_idx[i] == SRA_IDX)
+			continue;
 		devm_kfree(dev, cl_data->feature_report[i]);
 		devm_kfree(dev, in_data->input_report[i]);
 		devm_kfree(dev, cl_data->report_descr[i]);
-- 
2.39.5



