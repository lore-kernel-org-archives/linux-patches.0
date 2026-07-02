Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD06A34107D;
	Thu,  2 Jul 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009756; cv=none; b=fojAWxIFYyXYAOBKrfyMUgL22sZhhcBM6ooG6CMMbeXSlm140m/9p3QSXFKEBsQtjmByKAve6O81Au/Cu436hW/ZfVIqnw44xYduzA+sBpCcy/e9FhAKKgEKUZsKDQ3HjG4udxRqipfNcwyoQA60XPm/vAZF7iXll1h9jiiCgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009756; c=relaxed/simple;
	bh=SRB0YTO/1/vjC9vyMLoC7h/hgoQif6rI2WZsPKM4eNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGu5szGOBBdz7yL0TtHhEhOvjIIcY1LfSjTPr2mPIaI0gSmqKSeX0Jml8L9ydbjzxRo03QpcEwLLcoDIFZFpHZ4LRwyVpcFGY4pAgHLNV+HXpC1UWfgpZeeASjQ+zdZi/GQZbepu0kvHlErKPx0iF+qV+lyhN8vkFaKPtvSP0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoZKMM0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoZKMM0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D548F1F00A3A;
	Thu,  2 Jul 2026 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009754;
	bh=2vEbSfGEoiEydjZAnQOzIJYnL0ZQHR1keWH6hIhwI0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FoZKMM0qnrETpqIZPWJoLuCjA97ZuSBBhTrvewJ5pKb61igr2NIHxh97OIS0ZJAPj
	 RAhd0N3+ThHsYmNL+ToLUZZuB4y96syqF/f6Ee0vZae3EDDZUR+zJ3FJC0GhrW0eP1
	 iNHgbqbSVe0LYUwtqyfZ3Sd7L70gYjkAUIRJk0e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 74/95] power: reset: linkstation-poweroff: fix use-after-free in the linkstation_poweroff_init()
Date: Thu,  2 Jul 2026 18:20:17 +0200
Message-ID: <20260702155110.770843419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8eec545cde69e46e9a1d2b7d915ce4f5df85b3bd upstream.

Move of_node_put(dn) after the of_match_node() call, which still needs
the node pointer. The node reference is correctly released after use.

Fixes: e2f471efe1d6 ("power: reset: linkstation-poweroff: prepare for new devices")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260407073025.271865-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/reset/linkstation-poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/reset/linkstation-poweroff.c
+++ b/drivers/power/reset/linkstation-poweroff.c
@@ -163,10 +163,10 @@ static int __init linkstation_poweroff_i
 	dn = of_find_matching_node(NULL, ls_poweroff_of_match);
 	if (!dn)
 		return -ENODEV;
-	of_node_put(dn);
 
 	match = of_match_node(ls_poweroff_of_match, dn);
 	cfg = match->data;
+	of_node_put(dn);
 
 	dn = of_find_node_by_name(NULL, cfg->mdio_node_name);
 	if (!dn)


