Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5153DE458;
	Mon,  4 May 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904627; cv=none; b=TzEhv1cYIC/GSpyg6DRMSYNFUvMv2oQCl8K74otoWrt3dLHpPrzptjylp+5TT40+aO8yuLJ57i0D9jN/SJgKW8GMmECjD+ZxYkE5ragt9ZVlRrwWT2EYOZZEgeTPkGtmPKc97PUJ6UkQmZvA5JmnpKwr5+mRtmeXdsXqLILFB44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904627; c=relaxed/simple;
	bh=xaBYFEUL03rh9iZOhTjuuuHdVLnGfNoclDCAp8omfpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwYEiEIK4GadYqePFYGbQ+bfCsarSQIDUjy5vIp3aYe3ZpMvOpSLToihmb1hSAGWf0zBMgJJ2JjjcuYxdm9o3DGZj4cec2CiGG9nKEwH2/rpI/+tgbk+qm6twPp+y95A2L+EvvhSyNhELzjEk6AkRcaiRoAuLIDFgNyuXcXL6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxyAQn8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxyAQn8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D90DC2BCB8;
	Mon,  4 May 2026 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904627;
	bh=xaBYFEUL03rh9iZOhTjuuuHdVLnGfNoclDCAp8omfpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxyAQn8VxOox/tfBj8fSdKtC24Yie+qQ9SOjxybZGkgFe4euk+iUzAy5nhAKU25ZB
	 g6uO5BELAGx7VzZG6VHG6cGX5DG/MyjsD9Y2xbNwGukv1x+DSj5kIX1PHyxpnuzfjO
	 glXOjm1vmQn8bZDjucr7nQHlBg1hle2k5DRuK/N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 113/215] tpm: tpm_tis: add error logging for data transfer
Date: Mon,  4 May 2026 15:52:12 +0200
Message-ID: <20260504135134.279029313@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Jacqueline Wong <jacqwong@google.com>

commit 0471921e2d1043dcc6de5cffb49dd37709521abe upstream.

Add logging to more easily determine reason for transmit failure

Cc: stable@vger.kernel.org # v6.6+
Fixes: 280db21e153d8 ("tpm_tis: Resend command to recover from data transfer errors")
Signed-off-by: Jacqueline Wong <jacqwong@google.com>
Signed-off-by: Jordan Hand <jhand@google.com>
Link: https://lore.kernel.org/r/20260415160006.2275325-2-jacqwong@google.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -472,6 +472,8 @@ static int tpm_tis_send_data(struct tpm_
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
+			dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be set. sts = 0x%08x\n",
+				status);
 			goto out_err;
 		}
 	}
@@ -492,6 +494,8 @@ static int tpm_tis_send_data(struct tpm_
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
+		dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be unset. sts = 0x%08x\n",
+			status);
 		goto out_err;
 	}
 


