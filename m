Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C184F402A;
	Thu, 17 Sep 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664590; cv=none; b=KNWPB+pCldl7UuihbD8S1rhD6dtxHlQFmS4OMMv+AEEe0a5ufrBOmkw+ESWUgG+s7/etMCzAIHP+Ys8NBiLsgH/7Yi4Oo+FyJVJ5VIJFXTpu/Us8MoCkQfW5/Kqgi4KmWserO1fdfUo4/xnELD49qQ1BQPd2GR8kVoesFM2JWTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664590; c=relaxed/simple;
	bh=QcH+8afO9MdYEutbTE2Fk3sbZfMaAelcMzxDb1vlwSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lV9McMU1fSdAO2ZuUzGgUDCWQ3rWqMQJnK6idbCpztrqTnAFJXpoEWDBNjEZ6ALF9ZxQJTA3LzoDY8U2f9GLrRnmfOD2/B6EyUm1d0piXZ+osDr66GR1yUEgnonTSlFMPXtxPGI5td7dtTgDZ5gO5WXlVWvIOy/ZKVYrHoq8FWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4hNac/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4hNac/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC37C1F000FF;
	Thu, 17 Sep 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664588;
	bh=ZzlIGL7q7jLvgs3WS4VjFcTgjnweaCjqbiK7oGEyEHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4hNac/HUO5seBty+KPU8CvRed8PhIy9+2hUXWIkZ7+O9un5UoByqQkvGg5/5GEtO
	 LSgcZNrrmF9VKOBXwbGnrN51VqysvjChoRvv0E/jaworSS/sYBNBHB2i/55F7GwlL8
	 YzYxf1TgGxd8mPgMwcie9xzNP2u/Ga/B6PSIZfpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0421/1250] HID: hidpp: fix potential UAF in hidpp_connect_event()
Date: Thu, 17 Sep 2026 16:03:36 +0100
Message-ID: <20260917151603.430692502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 6df6b1f2c49678211f65647c300bc51dda02893b ]

If input_register_device() fails, we call input_free_device(), but keep
stale pointer to the old device in hidpp->input, which could potentially
lead to UAF. Fix that by resetting it to NULL before returning from
hidpp_connect_event().

Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 4ba652ae54765..83d625f361f49 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4280,6 +4280,7 @@ static void hidpp_connect_event(struct work_struct *work)
 
 	ret = input_register_device(input);
 	if (ret) {
+		hidpp->input = NULL;
 		input_free_device(input);
 		return;
 	}
-- 
2.53.0



