Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90515E8B;
	Mon, 30 Dec 2024 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574310; cv=none; b=KxzwONgQtb6VqjY6UUQCSWl6rKD5lKo77xrzQPVq4ZYPALXFOjPddWRZ07QV8AEee/O1flJdMZu84rRotUXG1BydQBsTbBJwJ+t7re02igmULIr1iZJm68imEeeCs+pziqa6wFuyyHAp3C0MBoPVFkxfqjXg0Xmk1Qix0KHiZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574310; c=relaxed/simple;
	bh=iQxWG7pgjBPTsfcWbNLm5zSqCDGGyIcX2MG+Uyeo5mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fv8hAU3EuKzoZr2HPwvaEIXqND7zWIAqvCi60riwoZF2sGlG3QRQydMr7vJmYAojNCxeM+2Ks8uioXVZYCD5Se8bGNypYPuKLC1cU/+k93EdWv51G2YDrZ/hnA+rgfbTk4fjqKJGUB8TwJv+oYBS2C8Tj3DB01Ih/VVOGTI+GOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSD6rSQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSD6rSQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E104CC4CED0;
	Mon, 30 Dec 2024 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574310;
	bh=iQxWG7pgjBPTsfcWbNLm5zSqCDGGyIcX2MG+Uyeo5mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSD6rSQNiUciMzPsDTP9sbmnTi/YlNRFoe+0wx3JoB245/tz6lc88foisWLZStmrL
	 EntEwulCLu2Es5Z7YYySqjJmNbiPtuLA5pAGqZA15UjiQaa+1baB9aggbOQ2UZ3uaF
	 iDB733Xz6xELafoeRzIZD0YUx/JCWGsehqiaTJ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Koch <linrunner@gmx.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 099/114] power: supply: cros_charge-control: hide start threshold on v2 cmd
Date: Mon, 30 Dec 2024 16:43:36 +0100
Message-ID: <20241230154221.926936315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit c28dc9fc24f5fa802d44ef7620a511035bdd803e upstream.

ECs implementing the v2 command will not stop charging when the end
threshold is reached. Instead they will begin discharging until the
start threshold is reached, leading to permanent charge and discharge
cycles. This defeats the point of the charge control mechanism.

Avoid the issue by hiding the start threshold on v2 systems.
Instead on those systems program the EC with start == end which forces
the EC to reach and stay at that level.

v1 does not support thresholds and v3 works correctly,
at least judging from the code.

Reported-by: Thomas Koch <linrunner@gmx.net>
Fixes: c6ed48ef5259 ("power: supply: add ChromeOS EC based charge control driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241208-cros_charge-control-v2-v1-3-8d168d0f08a3@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_charge-control.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/cros_charge-control.c b/drivers/power/supply/cros_charge-control.c
index 108b121db442..9b0a7500296b 100644
--- a/drivers/power/supply/cros_charge-control.c
+++ b/drivers/power/supply/cros_charge-control.c
@@ -139,6 +139,10 @@ static ssize_t cros_chctl_store_threshold(struct device *dev, struct cros_chctl_
 		return -EINVAL;
 
 	if (is_end_threshold) {
+		/* Start threshold is not exposed, use fixed value */
+		if (priv->cmd_version == 2)
+			priv->current_start_threshold = val == 100 ? 0 : val;
+
 		if (val < priv->current_start_threshold)
 			return -EINVAL;
 		priv->current_end_threshold = val;
@@ -234,12 +238,10 @@ static umode_t cros_chtl_attr_is_visible(struct kobject *kobj, struct attribute
 {
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(attr, n);
 
-	if (priv->cmd_version < 2) {
-		if (n == CROS_CHCTL_ATTR_START_THRESHOLD)
-			return 0;
-		if (n == CROS_CHCTL_ATTR_END_THRESHOLD)
-			return 0;
-	}
+	if (n == CROS_CHCTL_ATTR_START_THRESHOLD && priv->cmd_version < 3)
+		return 0;
+	else if (n == CROS_CHCTL_ATTR_END_THRESHOLD && priv->cmd_version < 2)
+		return 0;
 
 	return attr->mode;
 }
-- 
2.47.1



