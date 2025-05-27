Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750AB194A45;
	Tue, 27 May 2025 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368378; cv=none; b=H7wDGjV1Z/Sx58z0hyQM4qOeRgqQ50J5+Cg6B98LPtnrxcFxUxd99WM7/JPwkAZUbL9OrCAU0WiRqg8toMPCoUAoB8R1OlHfwIJ0tpImbH4zCVVd0jmC9VM1owBSiLctaPuABQmgJn35AMcXXkhyrJ7lG1wtVZy5RpU2Xx//EXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368378; c=relaxed/simple;
	bh=WL4ujAyolLEKTYwVhsgZqtk0UFWFYK7a1uEfYWrlC7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAZU8L3g8M1VMzQqDEwtPRtYGm3M5nLVeGNHDlzOCyZddLlN31rxx09083SZ0i00ubuM533W0YEcbt879h4UEEZZqQKpSJ7A6mTAuxb3nIi4rExNTgZwA09Fc7sSBXrObfZVVhOIRk6sBi3BEfb17ZMGGHbcyuMjZAIhFd7MpaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAJJdfFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAJJdfFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09B5C4CEE9;
	Tue, 27 May 2025 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368378;
	bh=WL4ujAyolLEKTYwVhsgZqtk0UFWFYK7a1uEfYWrlC7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAJJdfFZidc+d75Z0fqaPlEmSPlGrcDfRXriU0EUlOzcXYjYiiKV9Wx9o5ldyeGjH
	 y7T8g6uh2mn/rtgrwpXHndGjV/F+9oQQrxB+xqx25FZWcZzONQTwZKsudd+Nl+mtSb
	 8ln5opDk2239DdjJAE7u1zGbUHI0BcUVZT8WUdhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.14 688/783] remoteproc: qcom_wcnss: Fix on platforms without fallback regulators
Date: Tue, 27 May 2025 18:28:05 +0200
Message-ID: <20250527162541.152168447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 4ca45af0a56d00b86285d6fdd720dca3215059a7 ]

Recent change to handle platforms with only single power domain broke
pronto-v3 which requires power domains and doesn't have fallback voltage
regulators in case power domains are missing. Add a check to verify
the number of fallback voltage regulators before using the code which
handles single power domain situation.

Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sdm632-fairphone-fp3
Link: https://lore.kernel.org/r/20250511234026.94735-1-matti.lehtimaki@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 775b056d795a8..2c7e519a2254b 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -456,7 +456,8 @@ static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
 	if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < num_pd_vregs)
+			num_vregs += num_pd_vregs - wcnss->num_pds;
 	} else {
 		num_vregs += num_pd_vregs;
 	}
-- 
2.39.5



