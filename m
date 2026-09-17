Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9808B4848A3;
	Thu, 17 Sep 2026 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658933; cv=none; b=FamsGV75kX8P7eG47+/+UfMxecLqUGRJWrVkXGbSeicWwwIYgnCE8j63k6+3z/AcfrzL6rxfOwY5E3ED3aOOj8mqvrBKU4tz6kE4MupFMUk1yCkJJTJCX7sy1Fx/eJGN0DfewdnGvvi5xphMQDpbz5eeKb0Vr91Iawc3Q1Xwkis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658933; c=relaxed/simple;
	bh=reQSbWJWfM5p32z3jVqjPwb58zG0gDWYDOd2h3hD88s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2Xd4TNBxJy3te+YxXK6nh6F8KhFoaZp3W2KCTCFB7ElmL5MMuuAh49yU3k7JRmLI2VLDlHOnu5AVeWRWOkMlzBqrDLgKQSluXx0fkIljBCf+iu9nv540tCa7hwWcuyDEED3wIjec0U0kfsPiLMjAi3pycA26gQCJOXimp2uL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSw7kjCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSw7kjCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF8F1F00893;
	Thu, 17 Sep 2026 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658925;
	bh=K7hosKO4M6batmdgQ8AYG6EWXYdbyUmZNc7DAFZ+4ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSw7kjCWcfYnx4K8mjDTcTl83KWOk5EuiCUlf2ghOH2esSI2wWiEyE4t/yN13kSTK
	 xXV/yIP89onPK4bA6LlcGJ4MpKQsrZTQ688+SSLi2SoapdUQz6YmmULYJ63nHcVK1e
	 DMB+0v2HVoc8AkwUSz0TUWRxRKoQ7EtZ1zqxMaKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 078/733] OPP: of: Fix potential multiplication overflow when calculating freq
Date: Thu, 17 Sep 2026 16:06:26 +0100
Message-ID: <20260917151352.828132974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit e11811a552252740bd396ec38378e9570ee16578 ]

The multiplication be32_to_cpup(val++) * 1000 is performed using 32 bit
unsigned integers and hence uses a 32 bit multiplication; this will
overflow if be32_to_cpup(val++) is greater than 4294967 (which is
very unlikely at present). The result is assigned to an unsigned long
(which is a 64 bit value on 64 bit systems), so fix this potential
overflow by casting the first operand of the multiplication to
an unsigned int.

Fixes: b496dfbc94ab ("PM / OPP: Initialize OPP table from device tree")

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index c02e20632fa64..9c4fd1f0e944a 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1039,7 +1039,7 @@ static int _of_add_opp_table_v1(struct device *dev, struct opp_table *opp_table)
 
 	val = prop->value;
 	while (nr) {
-		unsigned long freq = be32_to_cpup(val++) * 1000;
+		unsigned long freq = (unsigned long)be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 		struct dev_pm_opp_data data = {
 			.freq = freq,
-- 
2.53.0



