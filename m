Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B619E7FE;
	Tue, 16 Jul 2024 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145147; cv=none; b=jyl5A1WFpx9b7tdkoyDsiUfoWSFavirTNhixAaf2B1dvxdHS7SftmSS1bXzO43oDW9JZ+kPXeIJdd2Jvj4j+ui/DtaC8785f7lYDWJ4iXl9VCndrxW14PAw316uMB7ankawLMKmoy4jJpss2kOfMpoEZfSLAT/m7H8mJ04DnKkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145147; c=relaxed/simple;
	bh=ZlMlOePAREFVrODLeoaax3yEt7lQh4Di8vyo/IVSaKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATS7U1iuljG1yTIMmCMtxNFIfUKxerLeR1JIVcepxgR5cKukKXBVjC8Y5lTv1K5InZWEBXLxo0QY1430NGWjrjP3ly6bemYMVIOpcUKxfzR5YW/f/8e+BYr9kFoab7MU9oQSV2uM5+tB1Qh71wo88/Dp6Vyg5NYirABWtqLe95U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2r6gfFyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2r6gfFyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD084C4AF0B;
	Tue, 16 Jul 2024 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145147;
	bh=ZlMlOePAREFVrODLeoaax3yEt7lQh4Di8vyo/IVSaKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2r6gfFyODPcFhPeVzTs4pneg9o05wdkQZQojFjusHYP1xLT0R3USJNhwDKdEbTtbK
	 6VKqYjykrC4T1j0mx1MwUFL5a8y6DEyXdLGDubJxSALTlxOSRReyGfnjRBUAcS/j1y
	 aFV2RIQRU/Dw33+mC14ISMX/SonH+Yw6dNH25Txo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 114/143] mmc: davinci_mmc: Prevent transmitted data size from exceeding sgms length
Date: Tue, 16 Jul 2024 17:31:50 +0200
Message-ID: <20240716152800.362672407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

commit 16198eef11c1929374381d7f6271b4bf6aa44615 upstream.

No check is done on the size of the data to be transmiited. This causes
a kernel panic when this size exceeds the sg_miter's length.

Limit the number of transmitted bytes to sgm->length.

Cc: stable@vger.kernel.org
Fixes: ed01d210fd91 ("mmc: davinci_mmc: Use sg_miter for PIO")
Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Link: https://lore.kernel.org/r/20240711081838.47256-2-bastien.curutchet@bootlin.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/davinci_mmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index d7427894e0bc..c302eb380e42 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -224,6 +224,9 @@ static void davinci_fifo_data_trans(struct mmc_davinci_host *host,
 	}
 	p = sgm->addr;
 
+	if (n > sgm->length)
+		n = sgm->length;
+
 	/* NOTE:  we never transfer more than rw_threshold bytes
 	 * to/from the fifo here; there's no I/O overlap.
 	 * This also assumes that access width( i.e. ACCWD) is 4 bytes
-- 
2.45.2



