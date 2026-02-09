Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC0137997D;
	Mon,  9 Feb 2026 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647162; cv=none; b=gEjqijV3AtUUk3wRcbg5/eEhIU7HO5cCc+ln8PUTKCJILO5qm3drRBlrPzqSkXOranXOauAocrovZ9Xw8oO6nvW7oqGqRTJp6OP1UQqwUTwqRVTGBxPtgtJkXMD985KhwjAhycIdOBlRKzbOqXxtkT4LS0Wg5nnz/zS9JUiYOZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647162; c=relaxed/simple;
	bh=GPX/F9PLtjxW4EeZyH98RKJrXTMjCxt4DtxtL283wKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj6JdUP0DHBEG6iy29BBuH7NcmOUTVQVbAurliFadJzfmrzwGmMME9ZEbTddQ+uT2iNBIV1iujqgPYYzdzb0PdorZq1POYm8wfLGPXqjh2wJik7IlXE6xlBS4WNYK6XZIptyVEGuxdSu8woOL0Miq9AqVC2LM/fWLFsOBVyBcvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DenY32jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DenY32jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9A1C116C6;
	Mon,  9 Feb 2026 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647162;
	bh=GPX/F9PLtjxW4EeZyH98RKJrXTMjCxt4DtxtL283wKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DenY32jVCJ0MDUgeEXECb8ul3Vabiljese7T6/oR3R7keDSACX+SBPPthiScYkDRp
	 aT+OxaV8Olsa/y+yIWCwrpotIoFjx9Td4G/5r3S3MEOM4gwALrGQIRGxzVd7X4tmKU
	 UiwFkcDcjdoOZ+uZVWonIylLNpBfJp19e7Kr71ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 007/175] pmdomain: qcom: rpmpd: fix off-by-one error in clamping to the highest state
Date: Mon,  9 Feb 2026 15:21:20 +0100
Message-ID: <20260209142320.742452247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1001,7 +1001,7 @@ static int rpmpd_aggregate_corner(struct
 
 	/* Clamp to the highest corner/level if sync_state isn't done yet */
 	if (!pd->state_synced)
-		this_active_corner = this_sleep_corner = pd->max_state - 1;
+		this_active_corner = this_sleep_corner = pd->max_state;
 	else
 		to_active_sleep(pd, pd->corner, &this_active_corner, &this_sleep_corner);
 


