Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022A42BE7B2;
	Tue,  6 Jan 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720740; cv=none; b=bup+5knJzSr6Wja7mLMvyYEDFKPHqwwm+wjSxxRduStUneQ7TP59oNeIAbjgEnMEvYRAo/YVgo+WOkHF/Xhte+Kd3NGSycIKgGfdgesG/CTMjSGg1oDiJLiXWK0iV/SAp5TvgLzcJeRnH6LFC1+ldbeT9Gn6/Il6j1h+Tj9z1Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720740; c=relaxed/simple;
	bh=YBVlaCTM2BbbSVhGc/uM4TmDzOuhcm2fgbskV7QPFKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqGynOs+v4B9SNPr38FBcjd6XQoVVmmwP47oVc2XE+YBRGvotpBMFyS/YSleVxbcerbbfLI6e3k/DlTVa0YLahTEhOyjv6yiIg/FGpkFifhQKgEb0xg1pG8JeYykJCIchwHHfAON71QTmVYv4p2Rkuq94Ppjsuzfk4EeNuJFtUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjhoSLqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjhoSLqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664EAC19423;
	Tue,  6 Jan 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720739;
	bh=YBVlaCTM2BbbSVhGc/uM4TmDzOuhcm2fgbskV7QPFKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjhoSLqVoIZvj1BuEHTc8nNo2QukOOqDsdhvQe/kVzQfhTDobWgrF4R6xiljgQz3b
	 zuDMtnXV1y0rfOwVluPeiSQyOd3+mhse9J7Or7xAep7Xwcugx+pKbEo+E09ZFk4Kya
	 qwUU5qNEfYwzHa0dg8gT1ZNfcqKVRhb8W8Lb2m2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/567] net: rose: fix invalid array index in rose_kill_by_device()
Date: Tue,  6 Jan 2026 18:01:50 +0100
Message-ID: <20260106170503.457606611@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index b8078b42f5de..1676c9f4ab84 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -205,7 +205,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



