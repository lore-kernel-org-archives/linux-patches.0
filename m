Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5652A1A9FAF;
	Mon,  4 May 2026 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904054; cv=none; b=Pp1vBu8ejy5VtY2JwPX3KRhZztDlFxuh9TsA7BcfxgcCDH4xAiTZ1AxZCk2AJhTqkwse6xCcNBT6pa9auh7bOsREdIBh4maVOUdjj3CNmkUaeBRk3w7g4uSEKBUCgG+QQdvn9Rj7j8p35Ig3G6VxaTkVE9a+wkzrFfChM+H7Tjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904054; c=relaxed/simple;
	bh=29TqC3ZVArH5yt2xVh2+JM9sLqeWfMzm/+RkuM92bDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8Uj7j4BeRBShfIm+LL9/r8Y83CZl9eAYC1cctrQEgnQfhcV5gVS97gnPx2bmCTV2dYcJ0oMTbekp10T+aNJdT3qxKKjJg1ZjkGXxqIGZEhugKuf2p47YZCK3L08/SlDStmUT60Uln1l/fUoEOdf4VXfRzWK30xMHNoWnk+xa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s08aqgt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s08aqgt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CC8C2BCB8;
	Mon,  4 May 2026 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904054;
	bh=29TqC3ZVArH5yt2xVh2+JM9sLqeWfMzm/+RkuM92bDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s08aqgt1BTdoBYsY2RkLdammue+9smb0BeAXjAbG63tZvW5hgepyVJfzTC17xcEKO
	 fh9d2yHg4qp2q4PYPb9AfegQqEUu+ZdcsgN18kRQTUUwmv1vERapXQGRJB3gHsrH8D
	 mD1pk/wAm6A4Yh1arIxd4vgVlGGFLpjt1wDbsLEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 158/275] tpm: tpm_tis: add error logging for data transfer
Date: Mon,  4 May 2026 15:51:38 +0200
Message-ID: <20260504135148.854515055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
 


