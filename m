Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD3933D6FC;
	Mon, 20 Apr 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700880; cv=none; b=EPA6CYj2pzsL4qK/W2SzbhFF2WG2j6ZWwaz2Owsa7KkvRzE+oC9j2mq8WP8QiL1YnXSdOPzulfPuSHs9XntNmNy09jiGHl9YHxTFJs27B9d1KimCE0oPWFDJj6MM6qZ9MbnByFRvAQvK6XGacPL7fahrgU36+AxqOOeGzbX+Zas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700880; c=relaxed/simple;
	bh=VZFtceVuq6BwT9GzVD1JHjI5dcc1JRoIGh4fQmYs2kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFLGaD3Xml7Z4geI9dDhfVGh7RzjvDR1YX6sIxG73VqjhPlhDlExZjlvMa/STOlMPuvK3T6qTAHWU4v1zIVSwEq6xQggVbFgHV2RMVnUxjPpCGQRtoDAIkQjFkeRVtg/eoCGwdElfdv4aNSe7BzLpXkluLFhyd/yH9X1h1LOWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gccye7NJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gccye7NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2206C19425;
	Mon, 20 Apr 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700880;
	bh=VZFtceVuq6BwT9GzVD1JHjI5dcc1JRoIGh4fQmYs2kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gccye7NJY1QmlQMX0mYVbvPkwHmrYRZ2ri5icqTXN2KR+OCMF3qHmIiv3Ga3cRNY5
	 YtMn4LtYSpz6yI9durmDvtT4QqoPHFCG33bKojoy634LjfJTZa859fNKQZlzqJ3FmS
	 Af0EpJZ88ozLcuW3oe5mdbbXzrerzuKcjxB1QDrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/198] ASoC: Intel: avs: Fix memory leak in avs_register_i2s_test_boards()
Date: Mon, 20 Apr 2026 17:41:14 +0200
Message-ID: <20260420153939.025462877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



