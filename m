Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCB63EBF00;
	Tue, 17 Mar 2026 16:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765481; cv=none; b=g5mbXfNEeRFnQhkehEs48gZPOJPpZXOlU1JuQaXKYeQ1zKr69/Bgs4IKb2p+8RtpuDoLjRH1gCQEcHeHUs7nsKWY+eiJkT16kGBVeiNLo1Bo6I30yDQe4qIB5NPvfjWsTDTbuJn2P6NqNvXv6nxL+UWYGyhmlqipDJ+MY9chRMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765481; c=relaxed/simple;
	bh=xhogMsM6LQ/T1zfW2h06pTIXmEG9VgQfdCse3KuPpeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRjykjIvg+QThWv12//Oj3qWjOVI2qwE8WlO7MRAL5LJq95okC3hqFgU7EhJbaNVUdNzyrKhEHA9hFXUaCfDL3tkGlyR4KWDA/3zWiLbB1wBk1KBqwhIC/mezVr1v+piFdENY7XMMPM/uBcXz/8iEQEnNCYGzvBy9DLmRI+oVzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHPgJJk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHPgJJk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DDEC4CEF7;
	Tue, 17 Mar 2026 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765481;
	bh=xhogMsM6LQ/T1zfW2h06pTIXmEG9VgQfdCse3KuPpeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHPgJJk/CrUnXIV90SWRA3rWfDGe0+60sEz0dGcGvFcu+0wZG/hxnBz3AlHRvuRwB
	 aFlW+yoj7QigiR+Cnxcg5eI1gCKuRbHlG6N+soIq06V4pg56ac9hVV9zTyW2YjrIZY
	 6TONzcFT5LgyeYSF0vTHG+PX6Y4mw58DI6QiZpAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 020/378] ASoC: cs42l43: Report insert for exotic peripherals
Date: Tue, 17 Mar 2026 17:29:37 +0100
Message-ID: <20260317163007.718415973@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6510e1324bcdc8caf21f6d17efe27604c48f0d64 ]

For some exotic peripherals the type detect can return a reserved value
of 0x4. This will currently return an error and not report anything to
user-space, update this to report the insert normally.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260223093616.3800350-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index b83bc4de1301d..3e04e6897b142 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -699,6 +699,7 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 	switch (type & CS42L43_HSDET_TYPE_STS_MASK) {
 	case 0x0: // CTIA
 	case 0x1: // OMTP
+	case 0x4:
 		return cs42l43_run_load_detect(priv, true);
 	case 0x2: // 3-pole
 		return cs42l43_run_load_detect(priv, false);
-- 
2.51.0



