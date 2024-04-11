Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7B134CC2;
	Thu, 11 Apr 2024 10:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832165; cv=none; b=T4iIMYyqEHHxArkF/5Q3x3ycoHu6QxzPLX11ll0wnBtFhEAvNTS/7wKEkFT7KTvnKeuDrBWAulkAitn2Z4sdP/nYQhxGK4bAA2ooSzr70Z7bNsWHXDR0BreSiCHvOvUySUSv7H0yPedMdSbZ8C7U0EhrpKE8GprL+uqxQPglR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832165; c=relaxed/simple;
	bh=Qoo6vFnBIsoGSnUdd8Z6tVpIk6/xym3E80mdj3wBkzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGWZDalTc+bk4fxljMkz6wdpHAqapQpnlc0VVRnf34bAx8yzKWvteFU7gakWoSu23ZEPSfNNjT65x2oYWg0WBOoGaRY7CeiT1UamgU05goXeqBL7B5ZpqPABlT35umfny8bYXkUd+Izo06VC+oCdL4MHjOFZv08T2nNU1tPefpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3/vEelz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3/vEelz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D753C433F1;
	Thu, 11 Apr 2024 10:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832165;
	bh=Qoo6vFnBIsoGSnUdd8Z6tVpIk6/xym3E80mdj3wBkzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3/vEelznsBHLrMfjpVS/3H6S2Y2bh7Eq6plBCEsgVeI3jZKCwwvaFp34N/NNXiCN
	 NpBM7q+N9dBrzDqTjG45ddLS3N3xKDbiH/SEWsaJR1/IDGCKcqktgHsTu1SejnSICf
	 HOThRQ9N4suQZ261hjtR/h9yCQsT9fmrBbc6OBm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/294] pstore/zone: Add a null pointer check to the psz_kmsg_read
Date: Thu, 11 Apr 2024 11:56:54 +0200
Message-ID: <20240411095443.125390361@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 98bc7e26e14fbb26a6abf97603d59532475e97f8 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118100206.213928-1-chentao@kylinos.cn
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/zone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index b50fc33f2ab29..2426fb6794fd3 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -973,6 +973,8 @@ static ssize_t psz_kmsg_read(struct pstore_zone *zone,
 		char *buf = kasprintf(GFP_KERNEL, "%s: Total %d times\n",
 				      kmsg_dump_reason_str(record->reason),
 				      record->count);
+		if (!buf)
+			return -ENOMEM;
 		hlen = strlen(buf);
 		record->buf = krealloc(buf, hlen + size, GFP_KERNEL);
 		if (!record->buf) {
-- 
2.43.0



