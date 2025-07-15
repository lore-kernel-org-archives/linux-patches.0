Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCC92E2EEF;
	Tue, 15 Jul 2025 13:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586852; cv=none; b=bpe8ufzAzr0NXWajrEil9oTbNwoFD4YW1e8pSuMjGHYEMEWy4oD8FreMIx7RutIiE0As0Fl7FDO9aoPCaBGy4i+5VI5YQI1tr7W2VDqiI5J7ndFy/pin5QVufb5cxtCpPNG/zUHHH1hKxwIhw/I3+oIP9yaQFH7AqKxXojkza1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586852; c=relaxed/simple;
	bh=W27qVyyEBtHONF/cg5+PxUMtPXe0KZnKu3nhinSAeiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qsjur0IdYgppPq1YzCzgOCZhInlo3vH+OVs1R5gYORtLGcrUSwh86Jg1jhM3eMgFbZ9AU+Tsxlvt5lLvz071xZ/AmCec6FTB8GPWAXkn3jamBp2G7fgu0AD6CIAg7LU5pqUdnoFigLGSLfzqI4uIZrpPVwWfu6ZfTSUU4ucf1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0me23V74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0me23V74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410E6C4CEE3;
	Tue, 15 Jul 2025 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586851;
	bh=W27qVyyEBtHONF/cg5+PxUMtPXe0KZnKu3nhinSAeiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0me23V74CpdzSH7ClzzMsGPYtKvHbnovcksrsglx9FoY8pHLHk+Xw89NUI1DgIRs4
	 Cm4VBhbbqfAW+D/K475xNJZ7BmFtOX5x2bIctouegbP1qMeE2D1HYUhYD4EHSd/rja
	 hphNrwCLhndqiNimrDx/KL19EeHnCstj60/yDCG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.15 073/192] pwm: Fix invalid state detection
Date: Tue, 15 Jul 2025 15:12:48 +0200
Message-ID: <20250715130817.863024242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -549,7 +549,7 @@ static bool pwm_state_valid(const struct
 	 * and supposed to be ignored. So also ignore any strange values and
 	 * consider the state ok.
 	 */
-	if (state->enabled)
+	if (!state->enabled)
 		return true;
 
 	if (!state->period)


