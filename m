Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBA1210ED
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUeXtg66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F30C433C8;
	Wed,  4 Oct 2023 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444335;
	bh=qwSHBLVHGysUxDFLdkdtnFAjEqOOitIJ9SqcAcnW7Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUeXtg66jQ9icJgEp9jicF5u402+rrN1Bu+OjCWWqJdYiQlIAqtQ8t8Kz/lMCWQMN
	 Iuxpeo5TVa5lKnifX7X+RnT/uYgeZHpYeR4u5kcrJl7uZPGBFWEgC85figs6A6YmwM
	 YR2XyV36JzWHHAs4fnWCUtQkyRTzKV6gmTKrumIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 185/321] thermal/of: add missing of_node_put()
Date: Wed,  4 Oct 2023 19:55:30 +0200
Message-ID: <20231004175237.816635201@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit 8a81cf96f5510aaf9a65d103f7405079a7b0fcc5 ]

for_each_child_of_node performs an of_node_get on each
iteration, so a break out of the loop requires an
of_node_put.

This was done using the Coccinelle semantic patch
iterators/for_each_child.cocci

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 22272f9c5934a..e615f735f4c03 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -38,8 +38,10 @@ static int of_find_trip_id(struct device_node *np, struct device_node *trip)
 	 */
 	for_each_child_of_node(trips, t) {
 
-		if (t == trip)
+		if (t == trip) {
+			of_node_put(t);
 			goto out;
+		}
 		i++;
 	}
 
@@ -402,8 +404,10 @@ static int thermal_of_for_each_cooling_maps(struct thermal_zone_device *tz,
 
 	for_each_child_of_node(cm_np, child) {
 		ret = thermal_of_for_each_cooling_device(tz_np, child, tz, cdev, action);
-		if (ret)
+		if (ret) {
+			of_node_put(child);
 			break;
+		}
 	}
 
 	of_node_put(cm_np);
-- 
2.40.1



