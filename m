Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61CE7E78F;
	Wed, 21 Feb 2024 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524443; cv=none; b=U51qQgXyBHKY0ryoMq4xIP2YgVA/66dFJGZord+lEAg9kwnHl8RC3LWSeeotOQO24X2Clu5q8BndMB2WbRqLhC4mmfRIsfiRAHJ3IGozp/QvGywzls2otOsqkEdtr/Lzqe6GdeZCejScYFv6ORcSrO77Ms3s3ivphKGpTpLBckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524443; c=relaxed/simple;
	bh=PxwlP9XENhhbsBO2ZFtAGUBa7l+4/q5TOu85Occ1Va4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UglmOmSNeGjVMLS6a02W3jsf3s8FS87a9HCP2qPAHourtZKpjOeUhwuR6O7utx2GA8viStxdCrTkhKknrTECEgGka89NEiJubnSDiuFJ0YQ3tLvV647emmGyqEOTSYK1C9TZxbGPlJW8Kb2bGr8nWeWbeqGQTteRwdfhUvUahmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7wmtqt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7wmtqt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C977C433F1;
	Wed, 21 Feb 2024 14:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524443;
	bh=PxwlP9XENhhbsBO2ZFtAGUBa7l+4/q5TOu85Occ1Va4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7wmtqt1IzhiOo8HJtxqyHBQxivnev0LW9Sfc3Y7qihi0ETK5UgXXgQQTpWI0HU3b
	 Vjsmq7vObrID8OyVD1eF0AZnGnLxs/ltCgi2Q1RhQ8IPSIQgNS7newu5RPSOewFp6i
	 lkQ64UK7x1Jlx2rrIJ359yJCX03HbcLOkwSD/zj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/379] PM: sleep: Fix error handling in dpm_prepare()
Date: Wed, 21 Feb 2024 14:07:04 +0100
Message-ID: <20240221130002.158766520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 544e737dea5ad1a457f25dbddf68761ff25e028b ]

Commit 2aa36604e824 ("PM: sleep: Avoid calling put_device() under
dpm_list_mtx") forgot to update the while () loop termination
condition to also break the loop if error is nonzero, which
causes the loop to become infinite if device_prepare() returns
an error for one device.

Add the missing !error check.

Fixes: 2aa36604e824 ("PM: sleep: Avoid calling put_device() under dpm_list_mtx")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c493e48e420f..fbc57c4fcdd0 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1897,7 +1897,7 @@ int dpm_prepare(pm_message_t state)
 	device_block_probing();
 
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_list)) {
+	while (!list_empty(&dpm_list) && !error) {
 		struct device *dev = to_device(dpm_list.next);
 
 		get_device(dev);
-- 
2.43.0



