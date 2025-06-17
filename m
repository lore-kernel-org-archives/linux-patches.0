Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B972FA630;
	Tue, 17 Jun 2025 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179093; cv=none; b=MLzR8PmJDOQcwfw2P5vjQ3FRy5V2DqXNKBtOMe9dlrnAzaxaYo8fUk+3cTUZiAIAQIRqhkPOrXw3NpRkHU6sDQ2n6xFDezn2y23PwKOu9+ohoNSqPqGDIvYD9hyWlWaVODZyHpcWOjTPOazapy7CE7sodUTl5gZ3SYyq8fXSMkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179093; c=relaxed/simple;
	bh=0SUb4EEoU7nVA6xdQZY7aAGQgxHnCtopSSOlQbEJHSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YIiejfugfOAGoeXITSThsLMbG8apl116EWMwBr8w1ON2Dd5S7VAQdUl6IAbZ1E6cWYLD4HQJP04St1pEJbyAQBCZCt7SNg8qkcAy9RwXQhektH01cHIFzByLOUGJxwVh+lkwy2XT5xDkTsU8+9CNVrHsTZJQWgJKuu+D5Dt4kno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y168APuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y168APuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B80CC4CEE3;
	Tue, 17 Jun 2025 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179093;
	bh=0SUb4EEoU7nVA6xdQZY7aAGQgxHnCtopSSOlQbEJHSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y168APuWh+smjf5bT2JH4aQwG1q11f+8piKAqicKiiugskc33ZH/iC65c44/+v1JA
	 lSKQLMUAL125tjN3S6BdKNh9c94YWNFb1MZKf5Aj8T0FvkbSFNL9KbZhyMrsIc+1iN
	 zyLN6XbeSAChQ7HvIUjC+kx2vAGvNSp5Yk01ZUOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 646/780] ASoC: Intel: avs: Verify content returned by parse_int_array()
Date: Tue, 17 Jun 2025 17:25:54 +0200
Message-ID: <20250617152517.791109035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 93e246b6769bdacb09cfff4ea0f00fe5ab4f0d7a ]

The first element of the returned array stores its length. If it is 0,
any manipulation beyond the element at index 0 ends with null-ptr-deref.

Fixes: 5a565ba23abe ("ASoC: Intel: avs: Probing and firmware tracing over debugfs")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-8-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/debugfs.c b/sound/soc/intel/avs/debugfs.c
index 8c4edda97f757..0e826ca20619c 100644
--- a/sound/soc/intel/avs/debugfs.c
+++ b/sound/soc/intel/avs/debugfs.c
@@ -373,7 +373,10 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 		return ret;
 
 	num_elems = *array;
-	resource_mask = array[1];
+	if (!num_elems) {
+		ret = -EINVAL;
+		goto free_array;
+	}
 
 	/*
 	 * Disable if just resource mask is provided - no log priority flags.
@@ -381,6 +384,7 @@ static ssize_t trace_control_write(struct file *file, const char __user *from, s
 	 * Enable input format:   mask, prio1, .., prioN
 	 * Where 'N' equals number of bits set in the 'mask'.
 	 */
+	resource_mask = array[1];
 	if (num_elems == 1) {
 		ret = disable_logs(adev, resource_mask);
 	} else {
-- 
2.39.5



