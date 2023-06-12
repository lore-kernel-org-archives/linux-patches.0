Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E6C134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C111C433D2;
	Mon, 12 Jun 2023 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566692;
	bh=h7wDYnHETVKvVKihkDO65vT57WRsgkdC7ZhWEeKrWFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEoq6aE9P9lhrttRUSiiY2GFMjy4hK8/v7j0vNUnNg61dME56/d6FD1h7+JngGl8G
	 EVIr5MtaClN+mWcriRfEHnS/Ddu5nuEfujHiozcdhUuA/xICLOKag5iXFkcnmiJ1lS
	 oT95GzZ/Vh0IDyz/arUU/x2lx2GY9SbiluEbUjDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/132] gpio: sim: fix memory corruption when adding named lines and unnamed hogs
Date: Mon, 12 Jun 2023 12:27:30 +0200
Message-ID: <20230612101715.567539889@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kent Gibson <warthog618@gmail.com>

[ Upstream commit 95ae9979bfe3174c2ee8d64409c44532f2881907 ]

When constructing the sim, gpio-sim constructs an array of named lines,
sized based on the largest offset of any named line, and then initializes
that array with the names of all lines, including unnamed hogs with higher
offsets.  In doing so it writes NULLs beyond the extent of the array.

Add a check that only named lines are used to initialize the array.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Signed-off-by: Kent Gibson<warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index cff68f31a09fd..803676e307d73 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -717,8 +717,10 @@ static char **gpio_sim_make_line_names(struct gpio_sim_bank *bank,
 	if (!line_names)
 		return ERR_PTR(-ENOMEM);
 
-	list_for_each_entry(line, &bank->line_list, siblings)
-		line_names[line->offset] = line->name;
+	list_for_each_entry(line, &bank->line_list, siblings) {
+		if (line->name && (line->offset <= max_offset))
+			line_names[line->offset] = line->name;
+	}
 
 	return line_names;
 }
-- 
2.39.2



