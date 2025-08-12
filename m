Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4F961FFE;
	Tue, 12 Aug 2025 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022685; cv=none; b=ttEdxFuP3KeI1AK9J9hng63SvHRaD2Mht3SpInw4X0myEbWll5J2DwFIF7GoFRmrLNepidAzVOJQJWBGBjrkdqY76slMNcAsQGnEtwzmal4lcftX2O/7Ixexs5ZwjSBMB+TEVmvL3OIl68kB59A0ZO6y1kJ/olArZGEp7Tvb7yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022685; c=relaxed/simple;
	bh=O9YjqYb2DuHXDoTA0NUGUqrYpUs0+XDsWTArw+HR3+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGMioql+wQ/yYptBt0CHxo6RdxReL7HKjnBbCV1fqSffnyERyT1uNxIZrATVtq1FxbIXWN21H69/3so2nChUDuhmHlVlUWDyP89aYWQFzHLJZgC5h5oetCRpWdAbrz3dtiEKNU/N5KGRcew5lptZvDaXQVNjwyvnKoVVq6sVbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKbIylPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKbIylPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7049C4CEF0;
	Tue, 12 Aug 2025 18:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022685;
	bh=O9YjqYb2DuHXDoTA0NUGUqrYpUs0+XDsWTArw+HR3+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKbIylPlIiih+rHrFx5gxJDvfjU/JY0eJh5DBNTbVshSvgTxEPv06E/AtSUkExvDk
	 6SuqoKuPITSe8/gA12AQEHmPx2jYm+xBMMY5tMSPiyE6VBLAfh3GzqE/cPL723Ih92
	 DGE6slzH719vZ3Gtq6m4CWCXMffHYY2K6UKvEWLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Zhan <zhanjun@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/369] selftests: ALSA: fix memory leak in utimer test
Date: Tue, 12 Aug 2025 19:28:46 +0200
Message-ID: <20250812173023.389527404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 6260da046819b7bda828bacae148fc8856fdebd7 ]

Free the malloc'd buffer in TEST_F(timer_f, utimer) to prevent
memory leak.

Fixes: 1026392d10af ("selftests: ALSA: Cover userspace-driven timers with test")
Reported-by: Jun Zhan <zhanjun@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://patch.msgid.link/DE4D931FCF54F3DB+20250731100222.65748-1-wangyuli@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/utimer-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/alsa/utimer-test.c b/tools/testing/selftests/alsa/utimer-test.c
index 32ee3ce57721..37964f311a33 100644
--- a/tools/testing/selftests/alsa/utimer-test.c
+++ b/tools/testing/selftests/alsa/utimer-test.c
@@ -135,6 +135,7 @@ TEST_F(timer_f, utimer) {
 	pthread_join(ticking_thread, NULL);
 	ASSERT_EQ(total_ticks, TICKS_COUNT);
 	pclose(rfp);
+	free(buf);
 }
 
 TEST(wrong_timers_test) {
-- 
2.39.5



