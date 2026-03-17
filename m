Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD133EBF00;
	Tue, 17 Mar 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765644; cv=none; b=PfD4pqXgYwWPsjMq9Q0UlNVx7UfGD7z6mHwhGxxW2CnXfiEx15XLfez+DtF9jArATJjR+uH2jC9rRdN3R7LPG80suaGezTurwxUcMp0PPKYJlIMAzg6mW1al3qZcjH41yIzhbskht3y9LLTZIBN27wH0ZSoWNxZOSrXTnL7TmTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765644; c=relaxed/simple;
	bh=SvkvVi2rSuI5Vsa54hGgYNxh4y5N3xzhay4FQqTuQ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9RxmcWO5v03l4UySU54g1FmWnlli0WDbg2IIZRrU+cs37l4zAr0ajg5j3q/Pgq8/4SbD1A8ozNA0/LsOfgF2vk5nR7m/y8v0sqC1v/71eQl5HYR+nlJcr645VF5QoKzpVBxgZRQEwF0tT/A6qQhjig7XUlZQsAZg6c9F2RWl5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EJH4B9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EJH4B9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5255DC2BCAF;
	Tue, 17 Mar 2026 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765644;
	bh=SvkvVi2rSuI5Vsa54hGgYNxh4y5N3xzhay4FQqTuQ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EJH4B9AVyUvjtZ6/5IvUzWiavJiTw79+LHOXu6q+E54BBSYTfu65DVEfPSdz0ryZ
	 xG8C+Cgx0IhmP7ej5ZenhOD3uN96VZJrZuB34PGfnHNQ/D8GmOAl2Lj/EYn5LvRjTK
	 3dWEgRB2/d+nqfSPbGMunWO5TYxycweZjIErlH20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Cotifava <cotifavamatteo@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 057/378] ASoC: soc-core: drop delayed_work_pending() check before flush
Date: Tue, 17 Mar 2026 17:30:14 +0100
Message-ID: <20260317163009.089016183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: matteo.cotifava <cotifavamatteo@gmail.com>

[ Upstream commit 3c99c9f0ed60582c1c9852b685d78d5d3a50de63 ]

The delayed_work_pending() check before flush_delayed_work() in
soc_free_pcm_runtime() is unnecessary and racy. flush_delayed_work()
is safe to call unconditionally - it is a no-op when no work is
pending. Remove the check.

The original check was added by commit 9c9b65203492 ("ASoC: core:
only flush inited work during free") but delayed_work_pending()
followed by flush_delayed_work() has a time-of-check/time-of-use
window where work can become pending between the two calls.

Fixes: 9c9b65203492 ("ASoC: core: only flush inited work during free")
Signed-off-by: Matteo Cotifava <cotifavamatteo@gmail.com>
Link: https://patch.msgid.link/20260309215412.545628-2-cotifavamatteo@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index e4b21bf39e59f..182d2272c2f39 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -462,8 +462,7 @@ static void soc_free_pcm_runtime(struct snd_soc_pcm_runtime *rtd)
 
 	list_del(&rtd->list);
 
-	if (delayed_work_pending(&rtd->delayed_work))
-		flush_delayed_work(&rtd->delayed_work);
+	flush_delayed_work(&rtd->delayed_work);
 	snd_soc_pcm_component_free(rtd);
 
 	/*
-- 
2.51.0



