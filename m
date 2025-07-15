Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B662192D8A;
	Tue, 15 Jul 2025 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585500; cv=none; b=He7lyjskdRUIf5cZRCHU6E433ERLupbAqCoKxtvKt6sgEMLoHzWlHJYz4LTOyp2+YNMcpU/PT/EmzC/afQK3o/r4bFhqOxyiNITFG8Pt/8kxH0Qe/PE8il//dDcqMXGO7ASupZ0FiywQrGbgIgm2QmvmcijQGF9sUP6gYrIl1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585500; c=relaxed/simple;
	bh=TkyT1mXx/OT0w6TlRbJ6H70zrL/N4zSdI69ibWMJegU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZ7zMuZUwwT8d020mJ3Z6Nn0b3HpEz5r/6FHnB8L1i1ez/Im53NZz6PTvo6T9hIoHRLrs4L2upfjnFqjCTb+71gVOnFrVrD+NygII7Rml+WEX9MsWZrCNZDAXmwCEMbvCZ5ta9OOZJeNr/2oSfIoPYplNh+Zw7YFc0UYN79XZWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkZJeu03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkZJeu03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AACC4CEE3;
	Tue, 15 Jul 2025 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585500;
	bh=TkyT1mXx/OT0w6TlRbJ6H70zrL/N4zSdI69ibWMJegU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkZJeu03ovsKFNbNR3U617DCs/6u+y0TVj+064gP35KYigiYLvTckF9gtajq0CxeH
	 fXgaHW7OYNW1nCk6Bc+hmn9VOMAgSAayN7diy/aUoN64LP3nnyKSUDv9/Z7H4MWq7Y
	 cE3wai47W+uEOQ3/e7Og9Rh8oSK0PgZ6yHrQohF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.12 064/163] pwm: Fix invalid state detection
Date: Tue, 15 Jul 2025 15:12:12 +0200
Message-ID: <20250715130811.318286803@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 9ee124caae1b0defd0e02c65686f539845a3ac9b upstream.

Commit 9dd42d019e63 ("pwm: Allow pwm state transitions from an invalid
state") intended to allow some state transitions that were not allowed
before. The idea is sane and back then I also got the code comment
right, but the check for enabled is bogus. This resulted in state
transitions for enabled states to be allowed to have invalid duty/period
settings and thus it can happen that low-level drivers get requests for
invalid states🙄.

Invert the check to allow state transitions for disabled states only.

Fixes: 9dd42d019e63 ("pwm: Allow pwm state transitions from an invalid state")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250704172416.626433-2-u.kleine-koenig@baylibre.com
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -148,7 +148,7 @@ static bool pwm_state_valid(const struct
 	 * and supposed to be ignored. So also ignore any strange values and
 	 * consider the state ok.
 	 */
-	if (state->enabled)
+	if (!state->enabled)
 		return true;
 
 	if (!state->period)


