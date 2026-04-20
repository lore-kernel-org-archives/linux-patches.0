Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5E83358B0;
	Mon, 20 Apr 2026 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700369; cv=none; b=cjPRXCJWGSMUKwjFatn58Ub1zhnIWqMZrneyrtBzo2U6fcfUUF6ft8pqZpGrWBMmF5BkHgHad4Y/eDejXAdn56nh1POfhiihgGlp2IoB9A9NB40IKwcvKJk868PJ0OuzbipshkjBILXGhX2eSBvRhjdLxvgKnUiesM43WNxt/bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700369; c=relaxed/simple;
	bh=KMIOioqPwWJ48wNt6+t5jRxPNKaAdaGXSyE5yLv+7uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9pAtvbpNMTj5E8LD/rdlhMO+roaNtsSFh3ALLFBoUT8Q47byqJmz2W7VDZeO9a2XL5xMU4tmKaA20h6m3mgJkeAng6ApJjTM9UInihrcKr9+m/ONcz76OrKPOu9N7iAIyR6YpkrgM2rZIsgfvfTRWHXh/g4AQrgUA4Xo9ErmRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsKRYThh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsKRYThh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DA1C19425;
	Mon, 20 Apr 2026 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700368;
	bh=KMIOioqPwWJ48wNt6+t5jRxPNKaAdaGXSyE5yLv+7uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsKRYThhctX7OLgE+Din2sDhmkuTdEzf7oa9EvGmMrUj3RwOXWkhswzRXcq+tiyLJ
	 /eTLbGLVeTnXZ3oqVRkWCEG7pD9QvV4jT7g2dkDIqZle+hMKqisgQra+siFpI3ndZV
	 n2BklH5Gr0l5dZQZNp0qGTwh15VNbn6f/KKTjjFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 112/220] ASoC: Intel: avs: Fix memory leak in avs_register_i2s_test_boards()
Date: Mon, 20 Apr 2026 17:40:53 +0200
Message-ID: <20260420153938.064002504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c5408d818316061d6063c11a4f47f1ba25a3a708 ]

Caller is responsible for freeing array allocated with
parse_int_array().

Found out by Coverity.

Fixes: 7d859189de13 ("ASoC: Intel: avs: Allow to specify custom configurations with i2s_test")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260407085459.400628-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/board_selection.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/avs/board_selection.c b/sound/soc/intel/avs/board_selection.c
index 52e6266a7cb86..96dc637ccb20c 100644
--- a/sound/soc/intel/avs/board_selection.c
+++ b/sound/soc/intel/avs/board_selection.c
@@ -520,7 +520,8 @@ static int avs_register_i2s_test_boards(struct avs_dev *adev)
 	if (num_elems > max_ssps) {
 		dev_err(adev->dev, "board supports only %d SSP, %d specified\n",
 			max_ssps, num_elems);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	for (ssp_port = 0; ssp_port < num_elems; ssp_port++) {
@@ -528,11 +529,13 @@ static int avs_register_i2s_test_boards(struct avs_dev *adev)
 		for_each_set_bit(tdm_slot, &tdm_slots, 16) {
 			ret = avs_register_i2s_test_board(adev, ssp_port, tdm_slot);
 			if (ret)
-				return ret;
+				goto exit;
 		}
 	}
 
-	return 0;
+exit:
+	kfree(array);
+	return ret;
 }
 
 static int avs_register_i2s_board(struct avs_dev *adev, struct snd_soc_acpi_mach *mach)
-- 
2.53.0



