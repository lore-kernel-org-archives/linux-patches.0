Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318813D5642;
	Wed, 20 May 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294404; cv=none; b=FnSdAd2DwyzW2cLSSzTEEEfOyTcDt6gTvYMEpZI3hAJhQYtSA++6YDeihKewd/gZG3Yaj0apdqhJJMX4q+HRhzVcjua9ow3zQKrvwkvU/RSYGwZ6gQbTT4HvaWAgQPFKTjIvMqkkQxoyk4RAKSSMLn4mUfmH9cUtEWmgkfBRDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294404; c=relaxed/simple;
	bh=IM6Z6JnZeilOSU7sVEtFS76oaBe7+SQPOdNDc8R9QPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjMtkWuIpVPw4YsCiNYJp1BITgqh6/R9E7+C919CoaO4zMr9NUgtHcLgU3zmgjpdDVpLpgz3c3blvtBRr7y+ZCDUalXjWvWY/LL3yMmtfMK0BVyB4xjdCpFikB1VRq+l652wAeTN6wVbVX5bi5WyY2zlZcuXO36HiIVHoCZvy/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUeiOUIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUeiOUIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA851F000E9;
	Wed, 20 May 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294402;
	bh=rLJ3GBOzdVYvwNqE03SDW1EF5lPyMwVSpXxJva0wwdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUeiOUIJ6cK8xN4Jsiy6E1HT/qNWfS2hUpKh8U0zqZ+PO/szJ1nBAoPEGcUH3cLHf
	 Huy67oXybk36ODGk7B8ldBvbowNSmlHqiCpuqXHcSL1Ee1PhoAnF56B+WQb+6tccgt
	 K4fcOaIpINPcnhcmhFtU5UTAY7s3iOqoiQFRx0XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0026/1146] OPP: Move break out of scoped_guard in dev_pm_opp_xlate_required_opp()
Date: Wed, 20 May 2026 18:04:36 +0200
Message-ID: <20260520162148.976843916@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 3d2398f44a2d48fb1c575a6e0bc6b38f3e689e22 ]

The commit ff9c512041f2 ("OPP: Use mutex locking guards")
unintentionally made the for loop run longer than required.

scoped_guard() is implemented as a for loop. The break statement now
breaks out out the scoped_guard() and not out of the outer for loop.
The outer loop always iterates to completion.

Fix it.

Fixes: ff9c512041f2 ("OPP: Use mutex locking guards")
Reported-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 866641666e410..da3f5eba43419 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2742,8 +2742,8 @@ struct dev_pm_opp *dev_pm_opp_xlate_required_opp(struct opp_table *src_table,
 					break;
 				}
 			}
-			break;
 		}
+		break;
 	}
 
 	if (IS_ERR(dest_opp)) {
-- 
2.53.0



