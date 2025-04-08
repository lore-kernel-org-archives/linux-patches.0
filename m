Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655BB269830;
	Tue,  8 Apr 2025 11:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113095; cv=none; b=F+OJQPI9B9AGBb3Rqdu8J96HQlOPQZWYvSEr+Q7lHZD/lcfnDX4aqXbVwuO0G5RI3VmeVyO1GCMksgUJM7NF6d6PZUkFxBUuGvijyV9W8wbnw/T/1RqkKSxGMaX5pf9kzRY97CFKvPRjSIHyqYoXexY0StgEnp7EewttmvO1UDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113095; c=relaxed/simple;
	bh=WYeQYPLCy+8v6NCS1XoGVN1cJo/UDTSFVM7fbxTXq+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttWxVZbZB4+TKmyrQJUnm3tUxWqMH5NP+KLBPgkK2S/3Ls3ELEULJZaaBoj1g7oKdA3eb7sKYDa7ZQhf8OriMaCKsmczxjjH/JLF5eZFlig00C93G8H/fsGHM7H1qg85c1yUV6EKxSLO5ThgYwE9OrgMHTL9nKKzIXAXyFyEOqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7+3SZH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7+3SZH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DDCC4CEE5;
	Tue,  8 Apr 2025 11:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113095;
	bh=WYeQYPLCy+8v6NCS1XoGVN1cJo/UDTSFVM7fbxTXq+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7+3SZH1MQjCSJUBASrq/LaMSgtbkZvED8T0NDc5h1yT0/i2BQh4DCEnSLYGCPlN+
	 xCJ8lxWcC5mRT5TPF7yWJDhzxaAKALayHdl0bsvLbmLsdxuxHut8UxIXst5WPtQv3+
	 LdvQOUijghQfdEOZAwbUP1TF45fdTizuMJS0KdSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Harry Wentland <hwentlan@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/268] drm/dp_mst: Fix drm RAD print
Date: Tue,  8 Apr 2025 12:47:24 +0200
Message-ID: <20250408104829.393954427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 6bbce873a9c97cb12f5455c497be279ac58e707f ]

[Why]
The RAD of sideband message printed today is incorrect.
For RAD stored within MST branch
- If MST branch LCT is 1, it's RAD array is untouched and remained as 0.
- If MST branch LCT is larger than 1, use nibble to store the up facing
  port number in cascaded sequence as illustrated below:

  u8 RAD[0] = (LCT_2_UFP << 4) | LCT_3_UFP
     RAD[1] = (LCT_4_UFP << 4) | LCT_5_UFP
     ...

In drm_dp_mst_rad_to_str(), it wrongly to use BIT_MASK(4) to fetch the port
number of one nibble.

[How]
Adjust the code by:
- RAD array items are valuable only for LCT >= 1.
- Use 0xF as the mask to replace BIT_MASK(4)

V2:
- Document how RAD is constructed (Imre)

V3:
- Adjust the comment for rad[] so kdoc formats it properly (Lyude)

Fixes: 2f015ec6eab6 ("drm/dp_mst: Add sideband down request tracing + selftests")
Cc: Imre Deak <imre.deak@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250113091100.3314533-2-Wayne.Lin@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 8 ++++----
 include/drm/display/drm_dp_mst_helper.h       | 7 +++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 71a30387ca125..21ff7ef7ce920 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -178,13 +178,13 @@ static int
 drm_dp_mst_rad_to_str(const u8 rad[8], u8 lct, char *out, size_t len)
 {
 	int i;
-	u8 unpacked_rad[16];
+	u8 unpacked_rad[16] = {};
 
-	for (i = 0; i < lct; i++) {
+	for (i = 1; i < lct; i++) {
 		if (i % 2)
-			unpacked_rad[i] = rad[i / 2] >> 4;
+			unpacked_rad[i] = rad[(i - 1) / 2] >> 4;
 		else
-			unpacked_rad[i] = rad[i / 2] & BIT_MASK(4);
+			unpacked_rad[i] = rad[(i - 1) / 2] & 0xF;
 	}
 
 	/* TODO: Eventually add something to printk so we can format the rad
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 46705dacdd081..7751be9452c15 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -215,6 +215,13 @@ struct drm_dp_mst_branch {
 	 */
 	struct list_head destroy_next;
 
+	/**
+	 * @rad: Relative Address of the MST branch.
+	 * For &drm_dp_mst_topology_mgr.mst_primary, it's rad[8] are all 0,
+	 * unset and unused. For MST branches connected after mst_primary,
+	 * in each element of rad[] the nibbles are ordered by the most
+	 * signifcant 4 bits first and the least significant 4 bits second.
+	 */
 	u8 rad[8];
 	u8 lct;
 	int num_ports;
-- 
2.39.5



