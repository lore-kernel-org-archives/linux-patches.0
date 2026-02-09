Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277BE27CCF2;
	Mon,  9 Feb 2026 14:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648382; cv=none; b=iR8N9FyYmSCBLsWZYj7Uug8mkUMHfuO3D7/JAkMo8z2dpWQaQDGivoQ8wY/82d8uqQVU39ZyW2ZA0E1m0J6+FOBd8qZ+BvX6XAKMZigPuZxp8oiAI+vrJtASl78Fjgh7BMyMJgZBVXJNHmxyYZ5BHqw3a9+AX/cSur0QFjJ72lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648382; c=relaxed/simple;
	bh=xAXe0nYSDbbkPx9aY56gBAgoAyeUKEh/c+eZIL79wiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEGsBkPzSDXGK6GetpJ+tGBrRHzv/Ns9IyqVbC3PWXqeJ/wWBd3TXDV/weRiLnd/tEc5QMr6/8fESvnqJ9eoYittZChfAoBv6gOrQnkZuXpFLCu3m3zdI3bxnBktVTCyQPzSb56EYKs0KCe9uVXu7M5HVPloQxTacXCaxkdMA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9II7H8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9II7H8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AA8C116C6;
	Mon,  9 Feb 2026 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648382;
	bh=xAXe0nYSDbbkPx9aY56gBAgoAyeUKEh/c+eZIL79wiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9II7H8sHMuViBGOyutkoNRDMi9+V95NRvvEInM3aOU4guFUQgk9Es98tf3ZSKEUp
	 Fexqabzx7AAqa3/HD8/BK5+gdiJR3l73TB/C+s/KsWqEESJ8yNm7IwFH3IDqtw9aZ8
	 ehHyuCAySUO2xUVK4lYtt9i9THwx9hi+Ys1AGD/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 04/86] pmdomain: qcom: rpmpd: fix off-by-one error in clamping to the highest state
Date: Mon,  9 Feb 2026 15:23:27 +0100
Message-ID: <20260209142304.935243450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 8aa6f7697f5981d336cac7af6ddd182a03c6da01 upstream.

As it is indicated by the comment, the rpmpd_aggregate_corner() function
tries to clamp the state to the highest corner/level supported by the
given power domain, however the calculation of the highest state contains
an off-by-one error.

The 'max_state' member of the 'rpmpd' structure indicates the highest
corner/level, and as such it does not needs to be decremented.

Change the code to use the 'max_state' value directly to avoid the error.

Fixes: 98c8b3efacae ("soc: qcom: rpmpd: Add sync_state")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/qcom/rpmpd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/qcom/rpmpd.c
+++ b/drivers/pmdomain/qcom/rpmpd.c
@@ -825,7 +825,7 @@ static int rpmpd_aggregate_corner(struct
 
 	/* Clamp to the highest corner/level if sync_state isn't done yet */
 	if (!pd->state_synced)
-		this_active_corner = this_sleep_corner = pd->max_state - 1;
+		this_active_corner = this_sleep_corner = pd->max_state;
 	else
 		to_active_sleep(pd, pd->corner, &this_active_corner, &this_sleep_corner);
 


