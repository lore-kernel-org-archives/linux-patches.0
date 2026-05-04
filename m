Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75499378D8C;
	Mon,  4 May 2026 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903315; cv=none; b=YpvER7uzc2UJ9n5PG/D6evepgN1Y84AtgzKy8/T0eKbJkz/Gcj6oBUnWnKlTu0YjXVtbyz+OdAf2749oFau1JYBUvqP+eQ2fxdsKYD/k7RG+qkKjI+uk7jyXaAmeCd4+Q527+6ubN4NiVYh4/ev4ADxf8xbzP7Yyk+5xwHwkVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903315; c=relaxed/simple;
	bh=pBpSD8p2OK721IFUai9BqA8L3Pt/ll2ok4mIS7sqPQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvtvTqan8CksQ5LTJhk6XX5OHJBqkxNqDXSzMDssZB8EzQU0UNpQWC2A2lsP+7pzn2P+owLFseo599qDMnTshrBrMcPCrpFUV25jLK7ncrh5AAPXMUn1JekL4CP0/KEIFgmw7DLEDci3xqKlIidcIk/GCP5I5tNeyrYFioeEsB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DZeubnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DZeubnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A009C2BCB8;
	Mon,  4 May 2026 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903315;
	bh=pBpSD8p2OK721IFUai9BqA8L3Pt/ll2ok4mIS7sqPQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DZeubnrfOBTFboEHWjbB6RqnFM86Xb1aYplqP1dZp9E7uQo9CmT9r4y51wS8jHA3
	 pqPvgPmrJYEuqA4aNUCrxxfLgafZJc1QmmP4Y/uC/MhdnoBZKi44FWkt/TtHGwaImZ
	 m5ETShYjXQf+/zZEbhpHh6KAMyFVEEr6NpTyc2H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.0 187/307] tpm: tpm_tis: add error logging for data transfer
Date: Mon,  4 May 2026 15:51:12 +0200
Message-ID: <20260504135149.916247031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,6 +471,8 @@ static int tpm_tis_send_data(struct tpm_
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
+			dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be set. sts = 0x%08x\n",
+				status);
 			goto out_err;
 		}
 	}
@@ -491,6 +493,8 @@ static int tpm_tis_send_data(struct tpm_
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
+		dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be unset. sts = 0x%08x\n",
+			status);
 		goto out_err;
 	}
 


