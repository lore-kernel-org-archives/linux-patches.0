Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E59187551;
	Wed,  3 Jul 2024 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005793; cv=none; b=p2ZDSPvthRS6Dc9uwHFYv1CmIgEYXnEWBlKpHXXuOHp1sg3zIBu3NY8xUs3GT0+RywfKbBI1x3ZQYHqNItdV3sx/H9U9/kwnfyHqhtick5rW48ZWyD8yx1cxqNQXeKVRy/QmLpw/VxvouiqLebpHoT/D58OSXBGXjiuIygOeg0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005793; c=relaxed/simple;
	bh=Va4ogR3LjV6CIHLlDit2gzbQnsjEcz5vaW8Z89pzDj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn7xtBSmv7jBmmfCmdZaLiEuNcBXNlks00TLRLgO2kEkYqt7/oYeZ4nn4hqQARbri+1r6tkDhheWejSM17eNgRRpdOzgjRtGE7ia51LC+F6wH/e4R3B00r91h6m23M50gDICpj1JlQFRmn8E6HmMxLh6BKRU3YPt1iqFZNxmg0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKLPDBaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKLPDBaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655EFC2BD10;
	Wed,  3 Jul 2024 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005792;
	bh=Va4ogR3LjV6CIHLlDit2gzbQnsjEcz5vaW8Z89pzDj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKLPDBaDftVYbmD9POfDp+FbPHr5FUxWR0h8N7k9geUYwScq7pOatgOh2248sqQPZ
	 Leqp7ABlN7OZv4lXvwE0CK8R/lRqvPNWV3AADRATSzjbyU51sD9/P+ew6BHPOikHo/
	 npN5BnxbP+mKzRCM8TmvJmDCUAxacLosSsWYA4rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/356] ptp: fix integer overflow in max_vclocks_store
Date: Wed,  3 Jul 2024 12:38:54 +0200
Message-ID: <20240703102920.595166778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 81d23d2a24012e448f651e007fac2cfd20a45ce0 ]

On 32bit systems, the "4 * max" multiply can overflow.  Use kcalloc()
to do the allocation to prevent this.

Fixes: 44c494c8e30e ("ptp: track available ptp vclocks information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Link: https://lore.kernel.org/r/ee8110ed-6619-4bd7-9024-28c1f2ac24f4@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 0bdfdd4bb0fa2..be58d5257bcb6 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -280,8 +280,7 @@ static ssize_t max_vclocks_store(struct device *dev,
 	if (max < ptp->n_vclocks)
 		goto out;
 
-	size = sizeof(int) * max;
-	vclock_index = kzalloc(size, GFP_KERNEL);
+	vclock_index = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!vclock_index) {
 		err = -ENOMEM;
 		goto out;
-- 
2.43.0



