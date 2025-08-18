Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351BF32A3D2;
	Mon, 18 Aug 2025 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523554; cv=none; b=qZqbjtbLf3h7VcuFLe8I7zaIWBPeQ7w8C08P7CxfFhDO9At3GUvnE4nHA4ABDui897xlZlwAdZOnChWG1sZYtm9hHbzucfbAEgAtf0pfXHfa4SNTcW2qfMas1Cp2iu5BDwdD/QfYCceXJYUQlzY9I1CnmgrqblnDsJhOuZmoBc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523554; c=relaxed/simple;
	bh=M8xIW8MEa7ZOxJ95rjrJJgr6k715PBwCP32dStf/5jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdj+w870GwcGqme9Gl9wpoDGGo8WHzIxFdPqy20vOHD6WbEyGzxXj5m7iypwXgrn+KRgj3fzK7yQqXZFjaVNDbePBzB8pvZtvQfhAMdEsURCcGOADjDediBRuoFOS7s4zR/5iojpAsvAsoaHUJrxZo96X9fauzieHt4b4tGeuz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzJnQObA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzJnQObA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8071C4CEEB;
	Mon, 18 Aug 2025 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523554;
	bh=M8xIW8MEa7ZOxJ95rjrJJgr6k715PBwCP32dStf/5jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzJnQObAc20oK0T+M9bWCvPRzChsM0Prdtitd8s9klcvyLnVrCzZw713h7EQeVb14
	 at6qg+EyiIZVpaF8jRTTF/cz2giKRe3cougB8n0gnf2ZHroxwpP1gmBVPdeZa12ydN
	 ccPM8amDK7vK0qDNSwIcfsVIp8+rcL/3FOTVorUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 206/515] s390/sclp: Use monotonic clock in sclp_sync_wait()
Date: Mon, 18 Aug 2025 14:43:12 +0200
Message-ID: <20250818124506.295928003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 925f0707a67cae0a974c4bd5b718f0263dc56824 ]

sclp_sync_wait() should use the monotonic clock for the delay loop.
Otherwise the code won't work correctly when the clock is changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 840be75e75d4..9a55e2d04e63 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -719,7 +719,7 @@ sclp_sync_wait(void)
 	timeout = 0;
 	if (timer_pending(&sclp_request_timer)) {
 		/* Get timeout TOD value */
-		timeout = get_tod_clock_fast() +
+		timeout = get_tod_clock_monotonic() +
 			  sclp_tod_from_jiffies(sclp_request_timer.expires -
 						jiffies);
 	}
@@ -739,7 +739,7 @@ sclp_sync_wait(void)
 	/* Loop until driver state indicates finished request */
 	while (sclp_running_state != sclp_running_state_idle) {
 		/* Check for expired request timer */
-		if (get_tod_clock_fast() > timeout && timer_delete(&sclp_request_timer))
+		if (get_tod_clock_monotonic() > timeout && timer_delete(&sclp_request_timer))
 			sclp_request_timer.function(&sclp_request_timer);
 		cpu_relax();
 	}
-- 
2.39.5



