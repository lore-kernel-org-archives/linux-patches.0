Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EE854903;
	Tue, 14 May 2024 11:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684651; cv=none; b=SHRwk61KwCGFUwUzOeShpoleEwUzwBf8Vkxucl3Wt/k/ZYA3RMJB7owh+kQPr1yU+63YlREASEvMoOeaKNu+vJZkYxhxcocJqg+c1rax7bskCH/B3AIwCKR3iKAykLhGILY+9crV7MNVp61w896UHrdlHtomN/NuyXXSqJnlnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684651; c=relaxed/simple;
	bh=Z18dgXwERnm4JgBBbSoTtXmB3GyIi6GS8xa5KlQWls0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKCXz1qfBmqIwKWsSA52KMUXWyvUhtPbQcbuNY/UGtqDt6oT2wo55r6+homoLuRgECaF3FMUl+iIRSad7vJwwUEuKGmF60OErqcmVa8EdLJVZsC68FYcgUkXukFxfPt2u0pcH6ycBwfyHpdMTdNxkkgaaryJQOmDpLMVu58RwQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4L7LB2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4L7LB2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3658AC2BD10;
	Tue, 14 May 2024 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684651;
	bh=Z18dgXwERnm4JgBBbSoTtXmB3GyIi6GS8xa5KlQWls0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4L7LB2Q31pKOfSKuuXOe99djpmBT9v/dHN1ce2KQYWuCaZ5fVG5CBugV6oAV/5Gt
	 9u3TU6ZhNRVH9F1/awPcttZGKxlHEaTIyAyGUzR9ftDeKvsHb1pqrwZksHt0DR3Fi+
	 RZIHhqMpeROQEvEVfovoVkBdB0mZnOOJU5AjrJHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/301] ALSA: hda: intel-sdw-acpi: fix usage of device_get_named_child_node()
Date: Tue, 14 May 2024 12:15:41 +0200
Message-ID: <20240514101034.887886529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit c158cf914713efc3bcdc25680c7156c48c12ef6a ]

The documentation for device_get_named_child_node() mentions this
important point:

"
The caller is responsible for calling fwnode_handle_put() on the
returned fwnode pointer.
"

Add fwnode_handle_put() to avoid a leaked reference.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Fixes: 08c2a4bc9f2a ("ALSA: hda: move Intel SoundWire ACPI scan to dedicated module")
Message-ID: <20240426152731.38420-1-pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-sdw-acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/intel-sdw-acpi.c b/sound/hda/intel-sdw-acpi.c
index b57d72ea4503f..4e376994bf78b 100644
--- a/sound/hda/intel-sdw-acpi.c
+++ b/sound/hda/intel-sdw-acpi.c
@@ -41,6 +41,8 @@ static bool is_link_enabled(struct fwnode_handle *fw_node, u8 idx)
 				 "intel-quirk-mask",
 				 &quirk_mask);
 
+	fwnode_handle_put(link);
+
 	if (quirk_mask & SDW_INTEL_QUIRK_MASK_BUS_DISABLE)
 		return false;
 
-- 
2.43.0



