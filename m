Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E315276028;
	Mon,  9 Feb 2026 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647784; cv=none; b=WqIQmy0BQPy1IEHtrfRHm4DmaYdqQko6ckcKWZTeL9MUIpG4vd2KcserJw30iIzoyCOD7nfPjjvq4GO3gvwB51rbQowI/391ehQch95Y0mzi7oN4GecShp/lx7imczhQg40N+Urtzn0jt+fNX7bnoXGzhgxniiiGNLcrmsLnrhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647784; c=relaxed/simple;
	bh=M4777Af/8/6KxnkesjBuVgAM+7nSH2cFMhcxxQfGcT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+fLTrwgcstEvrvQDv8WgSljVvO70tN2aU05NHBsApQ2niPFPjblLTEqky19o67qjN8KknN2ad5waKbIQ/Avd2vTPeF0H1JZQS8JzCE5hbQd7OLnZ7o2i79atQd06kNo7EupopeABsuvZi3LPdZ7dsL3Su3v0n7GldwTgd319kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsNjtacp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsNjtacp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E097C116C6;
	Mon,  9 Feb 2026 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647784;
	bh=M4777Af/8/6KxnkesjBuVgAM+7nSH2cFMhcxxQfGcT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsNjtacpoRZs8qP1J0pC7kFJ/UmXFtAwbb22ivdG4sUMd5V93xbUNRimdEq5wwoCC
	 XAFQEq00q5OA5OMDDvNXYK06AzMTZg8/7PoFBkssMQ63HtTFvaP/nuJy4HKie9nn3G
	 TZ0lBG4pBm8EJr3U1RfzuuuV60aVnEv4pBNuf/eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 006/113] pmdomain: qcom: rpmpd: fix off-by-one error in clamping to the highest state
Date: Mon,  9 Feb 2026 15:22:35 +0100
Message-ID: <20260209142310.437997159@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


