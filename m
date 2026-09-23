Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD3B53C3D5;
	Wed, 23 Sep 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175107; cv=none; b=r56qB9D+FjHbkMGgwwgIH194Bd70yjFw8i3QfopkP3ZxqksLDTrxwSgc+xnjwAzA9gj4HfIKyF+N9cVGL4GGePpWyyrs2CggaOa8CJLZ/5By+sIvWdQdA4A4DSnQQvapZikagVlIOm8k4gbLMN/e3nStYTzygdwGvdT0XDiDckI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175107; c=relaxed/simple;
	bh=xMXBWbXwHLvXS4GmZJdgUGLewTrbTh9rlNHS0KWS2O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyX2adz0CKnb5RmpxzkffFm9s5OE1CyqK9Hk72GBTY7HJU4ofOBCJ97LkRhxGTsIBzOHvAbTofnC1hs756zZ4W4KXA26b2rvUEzSbtYdbl4W2IEGSvl1ZoB3ns9HtSescxydEHFmO/LFTPbJF7kqKofxl34qnk/CbxurEQgPMZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ydUp/qe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ydUp/qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3981A1F00898;
	Wed, 23 Sep 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175106;
	bh=Z+Aic1tpJgyQLJV7ZqcUD2h7Rr8pxuZIox8iM3HcSzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ydUp/qevCaxd5CN3fDML/vT2ptii7N6HnnreLgof7gLJfufv5YELRj4bmwT8yKqB
	 GQjKI29FjfC2Pkq9r2oLCYmqqM5EpYcZTm1JvAOh764lv5cI8QVSKcy5QLuEQlQuSf
	 n7zMgdJMs7uaU6ysEuByaNi8qvfck1OSBNbykNDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 278/398] power: sequencing: fix NULL-pointer dereference in pwrseq_unit_new()
Date: Wed, 23 Sep 2026 16:05:52 +0200
Message-ID: <20260923140650.622037455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 115b303e8e093d964089ec6f3c40d984d77b33d0 upstream.

If memory allocation fails in pwrseq_unit_setup_deps(), pwrseq_unit_put()
is called to release the partially initialized unit. However, we've
never initialized unit->list and pwrseq_unit_release() will
unconditionally call list_del() on it. Initialize unit->list right after
allocating the unit struct.

Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260903-pwrseq-kunit-v1-0-1f893d2cabc2%40oss.qualcomm.com?part=1
Link: https://patch.msgid.link/20260909-pwrseq-kunit-v2-2-ef496afc89d2@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -101,6 +101,7 @@ static struct pwrseq_unit *pwrseq_unit_n
 	}
 
 	kref_init(&unit->ref);
+	INIT_LIST_HEAD(&unit->list);
 	INIT_LIST_HEAD(&unit->deps);
 	unit->enable = data->enable;
 	unit->disable = data->disable;


