Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71076C9C;
	Tue, 20 Feb 2024 21:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463450; cv=none; b=be8LrqwD9x5aDGKadWggH3MfG9dPqjVL2X3BLXnz4pYlG89dVs2ufsJELH1r8WLjTrK4dyQmZV914bTFGRhh7/rLFlcnq5bmrburhfUqWzqn2gtIQZWKiM4qYiP7HPOxIONK4FhDgqZFEtXnFBnuZTlKItmNe85plbHOqyYTe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463450; c=relaxed/simple;
	bh=iWOiZyHWS/MgVqxzbzF7ASgOG0AftG4R2axkZw4JFGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5+DvISVUIcix6syMKA5zl9Nk9DBmpJdCTeNYd4AlfMhuyLmUjIu1AAWckjix/abRD0YI9kpYrUvLIOs3UNI/E/mohvSfX+CtsIGL6gqlzvC7jzg73BvElpe4yZ/IeftvFi6MvGTRaykuTCveFY6/A+pq1WdQy+p6VxzzUCYa80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gy5CwMoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gy5CwMoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C99FC433F1;
	Tue, 20 Feb 2024 21:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463450;
	bh=iWOiZyHWS/MgVqxzbzF7ASgOG0AftG4R2axkZw4JFGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gy5CwMoSnGSZNgoKnPHTixKrZet7YTGzs01/F6AmCSKq8EjbeisylILdZ48zL2XCa
	 hiWpgfsCxdcqien/UkO90iic848kC+MpfVGAUgGY9E+FIeipi/WZIP3o8IVB6/9qFQ
	 5TisFUEcLU6iwn81xwO+Tlha2t9csOPVscWaJLBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/331] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Tue, 20 Feb 2024 21:52:43 +0100
Message-ID: <20240220205639.080646203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



