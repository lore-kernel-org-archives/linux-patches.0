Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6F14F9C8;
	Tue, 20 Feb 2024 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464532; cv=none; b=Dwz7P2FpsCdfT55TnAUSN9ujxgnOwwwa2LBd9OfEXgFS6jIfuC9nJN8Fjkb3zI6FwwOhk6s+atbgspGyWqiEM1aoxkndK/C/rgKWuoFQ8mGC/OlktzTXYePvOBFU8sOQynX45NswP0iKSs8BASxLQExS5F+WVMAhkcWDbymn4hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464532; c=relaxed/simple;
	bh=W27IFsxGVMZZvi7AvmYbW+cCvtmIgwgJjujHIYygYbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFlcH90LXegYkXZqfuV6Ofn6fMMXH3BFA//+VqrzOrlBifkkKsMD7/aZVv/Zjes5fBeqSFIEjfmYYEoKu+d++QjU0JHkOSdk3ypYACcJmUAOxULKZzpNoShLPZqZfrpV0rGtUc8yu2b8sVAnEe8Qq9vwteG3K8xmjLDjBggM1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XTHTT38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XTHTT38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5DBC433C7;
	Tue, 20 Feb 2024 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464531;
	bh=W27IFsxGVMZZvi7AvmYbW+cCvtmIgwgJjujHIYygYbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XTHTT38jGQsDKRuJwBYfNNJTOMCT3PHvRPoHvDa0NSzJpSW9P8/POVjq8zmj54gl
	 aC6hFLE2r5vVscQtfXov4WXi2lM1SWTnHm5PNqkvjHLxWxaeDnVqP/sPli9n5NhGvH
	 RFoh6EC/c/Tg7uF2XkEuFW7pfH9f7Pq608br3K9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/309] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Tue, 20 Feb 2024 21:53:33 +0100
Message-ID: <20240220205634.903777938@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 6ef5d5b92f7117b324efaac72b3db27ae8bb3082 ]

There is a path in rt5645_jack_detect_work(), where rt5645->jd_mutex
is left locked forever. That may lead to deadlock
when rt5645_jack_detect_work() is called for the second time.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cdba4301adda ("ASoC: rt5650: add mutex to avoid the jack detection failure")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/1707645514-21196-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index edcb85bd8ea7..ea08b7cfc31d 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3314,6 +3314,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



